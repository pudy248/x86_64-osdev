#pragma once
#include <concepts>
#include <cstdint>
#include <kassert.hpp>
#include <kcstring.hpp>
#include <stl/allocator.hpp>
#include <stl/iterator.hpp>
#include <stl/pointer.hpp>
#include <stl/vector.hpp>
#include <sys/ktime.hpp>
#include <utility>

static uint32_t simple_hash(pointer<const void, type_cast> key, size_t key_size) {
	uint32_t hash = 2166136261u;
	pointer<const uint8_t, type_cast> ptr = key;
	for (size_t i = 0; i < key_size; i++) {
		hash ^= ptr[i];
		hash *= 16777619u;
	}
	return hash;
}
template <typename Key, typename HashT>
static constexpr HashT default_hash(const Key& k) {
	if constexpr (std::same_as<Key, cstr_t> || std::same_as<Key, ccstr_t>)
		return simple_hash(k, strlen(k));
	else
		return simple_hash(&k, sizeof(k));
}
template <typename Key, typename Value, std::integral Hash = uint32_t, allocator A = default_allocator<void>>
class unordered_map;
template <typename Key, typename Value, std::integral Hash = uint32_t>
class unordered_map_iterator;
template <typename Key, typename Value, std::integral Hash>
class std::indirectly_readable_traits<unordered_map_iterator<Key, Value, Hash>> {
public:
	using value_type = std::pair<const Key, Value>;
};

template <typename Key, typename Value, std::integral Hash>
class unordered_map_iterator : public random_access_iterator_interface<unordered_map_iterator<Key, Value, Hash>> {
public:
	span<Hash> hashes;
	pointer<const Key> keys;
	pointer<Value> values;
	std::size_t offset;
	constexpr unordered_map_iterator(span<Hash> h, pointer<const Key> k, pointer<Value> v, std::size_t o)
		: hashes(h), keys(k), values(v), offset(o) {
		if (offset < hashes.size() && !hashes[offset])
			++*this;
	}
	constexpr std::pair<const Key, Value&> operator*() {
		return std::pair<const Key, Value&>(keys[offset], values[offset]);
	}
	constexpr std::pair<const Key, const Value&> operator*() const {
		return std::pair<const Key, const Value&>(keys[offset], values[offset]);
	}
	constexpr unordered_map_iterator& operator+=(std::ptrdiff_t v) {
		while (v) {
			int sign = v > 0 ? 1 : -1;
			do {
				offset += sign;
				if (offset < 0 || offset >= hashes.size())
					break;
				// if (offset < 0)
				// 	offset = hashes.size() - 1;
				// else if (offset >= hashes.size())
				// 	offset = 0;
			} while (!hashes[offset]);
			v -= sign;
		}
		return *this;
	}
	constexpr bool operator==(const unordered_map_iterator& other) const {
		return keys() == other.keys() && offset == other.offset;
	}
};

template <typename Key, typename Value, std::integral HashT, allocator A>
class unordered_map {
protected:
	friend class unordered_map_iterator<Key, Value, HashT>;
	A alloc;
	heap_array<HashT, allocator_reference<A>> key_hashes;
	heap_array<Key, allocator_reference<A>> keys;
	heap_array<Value, allocator_reference<A>> values;
	std::size_t m_size;

	static constexpr double max_load = 0.7;
	static constexpr double resize_ratio = 4;

	HashT (*hash_fn)(const Key&) = &default_hash;
	static constexpr HashT default_hash(const Key& k) {
		if constexpr (std::same_as<Key, cstr_t> || std::same_as<Key, ccstr_t>)
			return simple_hash(k, strlen(k));
		else
			return simple_hash(&k, sizeof(k));
	}
	//Hash (*double_hash)(Hash) = &default_double_hash;
	//static Hash default_double_hash(Hash h) { return simple_hash(&h, sizeof(h)); }

	constexpr std::ptrdiff_t m_hash(HashT key_hash, HashT expected) {
		HashT i = key_hash;
		while (key_hashes[i % capacity()] != expected) {
			// Linear search (Good for sparse maps, as on average 8 or 4 (depending on hash width) keys are read
			//   per cache line, so searches shorter than this are effectively instant)
			i++;
			// Double hash, improves clustering performance
			// i = double_hash(i);
			if (i % capacity() == key_hash % capacity())
				return -1;
		}
		return i % capacity();
	}
	constexpr std::ptrdiff_t m_find(const Key& k, HashT key_hash) {
		HashT i = key_hash;
		do {
			i = m_hash(i, key_hash);
			if (keys[i] == k)
				return i;
			else
				i = (i + 1) % capacity();
		} while (i != key_hash);
		return -1;
	}

public:
	using value_type = std::pair<const Key, Value&>;
	using iterator_type = unordered_map_iterator<Key, Value, HashT>;

	constexpr unordered_map(A _alloc = A())
		: alloc(_alloc), key_hashes(0, alloc), keys(0, alloc), values(0, alloc), m_size(0) {}
	constexpr unordered_map(std::size_t capacity, A _alloc = A())
		: alloc(_alloc), key_hashes(capacity, alloc), keys(capacity, alloc), values(capacity, alloc), m_size(0) {}
	constexpr unordered_map(decltype(hash_fn) hash_fn, A _alloc = A())
		: alloc(_alloc), key_hashes(0, alloc), keys(0, alloc), values(0, alloc), m_size(0), hash_fn(hash_fn) {}
	constexpr unordered_map(decltype(hash_fn) hash_fn, std::size_t capacity, A _alloc = A())
		: alloc(_alloc)
		, key_hashes(capacity, alloc)
		, keys(capacity, alloc)
		, values(capacity, alloc)
		, m_size(0)
		, hash_fn(hash_fn) {}

	constexpr value_type at(const Key& key) {
		std::ptrdiff_t i = m_find(key, hash_fn(key));
		kassert(DEBUG_ONLY, WARNING, i >= 0, "Accessed missing key in hashmap.");
		return value_type(keys[i], values[i]);
	}
	constexpr Value& operator[](const Key& key) { return at(key).second; }

	constexpr void rehash(std::size_t size) {
		unordered_map new_map{hash_fn, size};
		new_map.m_size = m_size;
		for (std::size_t i = 0; i < capacity(); i++) {
			if (!key_hashes[i])
				continue;
			size_t j = new_map.m_hash(key_hashes[i], 0);
			new_map.key_hashes[j] = key_hashes[i];
			key_hashes[i] = 0;
			new_map.keys[j] = std::move(keys[i]);
			new_map.values[j] = std::move(values[i]);
		}
		*this = std::move(new_map);
	}
	constexpr void insert(Key&& key, Value&& value) {
		HashT key_hash = hash_fn(key);
		std::ptrdiff_t i = m_hash(key, 0);
		key_hashes[i] = key_hash;
		keys[i] = std::move(key);
		values[i] = std::move(value);
		m_size++;
		if ((double)size() / capacity() > max_load)
			rehash(capacity() * resize_ratio);
	}
	template <typename KP, typename VP>
	constexpr void insert(KP&& key, VP&& value) {
		HashT key_hash = hash_fn(key);
		std::ptrdiff_t i = m_hash(key, 0);
		key_hashes[i] = key_hash;
		keys[i] = std::forward<KP>(key);
		values[i] = std::forward<VP>(value);
		m_size++;
		if ((double)size() / capacity() > max_load)
			rehash(capacity() * resize_ratio);
	}

	constexpr void erase(const Key& key) {
		std::ptrdiff_t i = m_find(key, hash_fn(key));
		kassert(DEBUG_ONLY, WARNING, i >= 0, "Accessed missing key in hashmap.");
		key_hashes[i] = 0;
		values[i] = {};
	}

	constexpr iterator_type begin() { return {key_hashes, keys.begin(), values.begin(), 0}; }
	constexpr const iterator_type cbegin() { return {key_hashes, keys.begin(), values.begin(), 0}; }
	constexpr iterator_type end() { return {key_hashes, keys.begin(), values.begin(), capacity()}; }
	constexpr const iterator_type cend() const { return {key_hashes, keys.begin(), values.begin(), capacity()}; }

	constexpr std::size_t size() const { return m_size; }
	constexpr std::size_t capacity() const { return key_hashes.size(); }
};

template <typename Key, typename Value, std::integral HashT = uint32_t,
	bool (*cmp_fn)(const Key&, const Key&) =
		[](const Key& a, const Key& b) {
			if constexpr (requires { a < b; })
				return a < b;
			else
				return false;
		},
	HashT (*hash_fn)(const Key&) = default_hash<Key, HashT>, allocator A = default_allocator<void>>
class sorted_map;
template <typename Key, typename Value, typename MapTuple, std::integral Hash = uint32_t>
class sorted_map_iterator;
template <typename Key, typename Value, std::integral Hash, typename MapTuple>
class std::indirectly_readable_traits<sorted_map_iterator<Key, Value, MapTuple, Hash>> {
public:
	using value_type = std::pair<const Key, Value>;
};

struct sorted_map_sentinel {};
template <typename Key, typename Value, typename MapTuple, std::integral HashT>
class sorted_map_iterator : public forward_iterator_interface<sorted_map_iterator<Key, Value, MapTuple, HashT>> {
public:
	using forward_iterator_interface<sorted_map_iterator<Key, Value, MapTuple, HashT>>::operator++;
	span<HashT> hashes;
	span<MapTuple> elements;
	HashT pos;
	constexpr sorted_map_iterator(const span<HashT>& h, const span<MapTuple>& e, HashT o)
		: hashes(h), elements(e), pos(o) {}
	constexpr std::pair<Key&, Value&> operator*() {
		return std::pair<Key&, Value&>(elements[pos].key, elements[pos].value);
	}
	constexpr std::pair<const Key&, const Value&> operator*() const {
		return std::pair<const Key&, const Value&>(elements[pos].key, elements[pos].value);
	}
	constexpr sorted_map_iterator& operator++() {
		if (pos != -1u)
			pos = elements[pos].list_next;
		return *this;
	}
	constexpr bool operator==(const sorted_map_sentinel&) const { return pos == -1u; }
};

template <typename Key, typename Value, std::integral HashT, bool (*cmp_fn)(const Key&, const Key&),
	HashT (*hash_fn)(const Key&), allocator A>
class sorted_map {
protected:
	struct map_tuple {
		Key key;
		Value value;
		HashT list_next;
	};
	friend class sorted_map_iterator<Key, Value, HashT>;
	A alloc;
	heap_array<HashT, allocator_reference<A>> key_hashes;
	heap_array<map_tuple, allocator_reference<A>> elements;
	std::size_t m_size;
	HashT list_head = -1;

	static constexpr double max_load = 0.7;
	static constexpr double resize_ratio = 4;

	constexpr std::ptrdiff_t m_hash(HashT key_hash, HashT expected) {
		HashT i = key_hash;
		while (key_hashes[i % capacity()] != expected) {
			i++;
			if (i % capacity() == key_hash % capacity())
				return -1;
		}
		return i % capacity();
	}
	constexpr std::ptrdiff_t m_find(const Key& k, HashT key_hash) {
		if (!capacity())
			return -1;
		HashT i = key_hash;
		do {
			i = m_hash(i, key_hash);
			if (elements[i].key == k)
				return i;
			else
				i = (i + 1) % capacity();
		} while (i != key_hash);
		return -1;
	}
	constexpr void m_insert(HashT hash, Key&& key, Value&& value) {
		m_size++;
		if (!capacity())
			rehash(4);
		else if ((double)size() / capacity() > max_load)
			rehash(capacity() * resize_ratio);

		std::ptrdiff_t i = m_hash(hash, 0);
		key_hashes[i] = hash;
		elements[i] = {std::move(key), std::move(value), -1u};
		if (list_head == -1u || cmp_fn(elements[i].key, elements[list_head].key)) {
			elements[i].list_next = list_head;
			list_head = i;
		} else {
			HashT j = list_head;
			for (; elements[j].list_next != -1u; j = elements[j].list_next) {
				if (cmp_fn(elements[i].key, elements[elements[j].list_next].key)) {
					elements[i].list_next = elements[j].list_next;
					elements[j].list_next = i;
					return;
				}
			}
			elements[j].list_next = i;
		}
	}

public:
	using value_type = std::pair<const Key, Value&>;
	using iterator_type = sorted_map_iterator<Key, Value, map_tuple, HashT>;

	constexpr sorted_map(A _alloc = A()) : alloc(_alloc), key_hashes(0, alloc), elements(0, alloc), m_size(0) {}
	constexpr sorted_map(std::size_t capacity, A _alloc = A())
		: alloc(_alloc), key_hashes(capacity, alloc), elements(capacity, alloc), m_size(0) {}

	constexpr value_type at(const Key& key) {
		std::ptrdiff_t i = m_find(key, hash_fn(key));
		kassert(DEBUG_ONLY, WARNING, i >= 0, "Accessed missing key in hashmap.");
		return value_type(elements[i].key, elements[i].value);
	}
	constexpr Value& operator[](const Key& key) { return at(key).second; }

	constexpr void rehash(std::size_t size) {
		sorted_map new_map{size};
		for (auto [key, value] : *this)
			new_map.insert(std::move(key), std::move(value));
		//for (std::size_t i = 0; i < capacity(); i++) {
		//	if (!key_hashes[i])
		//		continue;
		//	size_t j = new_map.m_hash(key_hashes[i], 0);
		//	new_map.key_hashes[j] = key_hashes[i];
		//	key_hashes[i] = 0;
		//	new_map.elements[j] = std::move(elements[i]);
		//	new_map.elements[j].list_next = new_map.list_head;
		//	new_map.list_head = j;
		//}
		*this = std::move(new_map);
	}
	template <typename KP, typename VP>
	constexpr void insert(KP&& key, VP&& value) {
		HashT key_hash = hash_fn(key);
		m_insert(key_hash, std::forward<KP>(key), std::forward<VP>(value));
	}

	constexpr void erase(const Key& key) {
		std::ptrdiff_t i = m_find(key, hash_fn(key));
		kassert(DEBUG_ONLY, WARNING, i >= 0, "Accessed missing key in hashmap.");
		key_hashes[i] = 0;
		if (i == list_head)
			list_head = elements[i].list_next;
		else
			for (map_tuple& tup : elements)
				if (tup.list_next == i)
					tup.list_next = elements[i].list_next;
		elements[i] = {};
		m_size--;
	}

	constexpr iterator_type begin() { return {key_hashes, elements, list_head}; }
	constexpr const iterator_type cbegin() { return {key_hashes, elements, list_head}; }
	constexpr sorted_map_sentinel end() { return {}; }
	constexpr const sorted_map_sentinel cend() const { return {}; }

	constexpr std::size_t size() const { return m_size; }
	constexpr std::size_t capacity() const { return key_hashes.size(); }
};
