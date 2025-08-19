#pragma once
#include <concepts>
#include <cstdint>
#include <kassert.hpp>
#include <kcstring.hpp>
#include <stl/allocator.hpp>
#include <stl/pointer.hpp>
#include <stl/vector.hpp>
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
	pointer<std::pair<const Key, Value>, type_cast> values;
	std::size_t offset;
	constexpr unordered_map_iterator(span<Hash> h, pointer<std::pair<const Key, Value>, type_cast> v, std::size_t o)
		: hashes(h), values(v), offset(o) {}
	constexpr std::pair<const Key, Value>& operator*() { return values[offset]; }
	constexpr const std::pair<const Key, Value>& operator*() const { return values[offset]; }
	constexpr unordered_map_iterator& operator+=(std::ptrdiff_t v) {
		while (v) {
			int sign = v > 0 ? 1 : -1;
			do {
				if (offset < 0 || offset > hashes.size())
					break;
				offset += sign;
			} while (!hashes[offset]);
			v -= sign;
		}
		return *this;
	}
	constexpr bool operator==(const unordered_map_iterator& other) const {
		return values() == other.values() && offset == other.offset;
	}
};

template <typename Key, typename Value, std::integral HashT, allocator A>
class unordered_map {
protected:
	friend class unordered_map_iterator<Key, Value, HashT>;
	A alloc;
	heap_array<HashT, allocator_reference<A>> key_hashes;
	heap_array<std::pair<Key, Value>, allocator_reference<A>> values;
	std::size_t m_size;

	static constexpr double max_load = 0.7;
	static constexpr double resize_ratio = 4;

	HashT (*hash_fn)(const Key&) = &default_hash;
	static constexpr HashT default_hash(const Key& k) {
		if constexpr (std::same_as<Key, cstr_t> || std::same_as<Key, ccstr_t>) {
			return simple_hash(k, strlen(k));
		} else {
			return simple_hash(&k, sizeof(k));
		}
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
			if (values[i].first == k)
				return i;
			else
				i = (i + 1) % capacity();
		} while (i != key_hash);
		return -1;
	}

public:
	using value_type = std::pair<const Key, Value>;
	using iterator_type = unordered_map_iterator<Key, Value, HashT>;

	constexpr unordered_map(A _alloc = A()) : alloc(_alloc), key_hashes(0, alloc), values(0, alloc), m_size(0) {}
	constexpr unordered_map(std::size_t capacity, A _alloc = A())
		: alloc(_alloc), key_hashes(capacity, alloc), values(capacity, alloc), m_size(0) {}
	constexpr unordered_map(decltype(hash_fn) hash_fn, A _alloc = A())
		: alloc(_alloc), key_hashes(0, alloc), values(0, alloc), m_size(0), hash_fn(hash_fn) {}
	constexpr unordered_map(decltype(hash_fn) hash_fn, std::size_t capacity, A _alloc = A())
		: alloc(_alloc), key_hashes(capacity, alloc), values(capacity, alloc), m_size(0), hash_fn(hash_fn) {}

	constexpr value_type& at(const Key& key) {
		std::ptrdiff_t i = m_find(key, hash_fn(key));
		kassert(DEBUG_ONLY, WARNING, i >= 0, "Accessed missing key in hashmap.");
		return pointer<value_type, type_cast>(values.begin())[i];
	}
	constexpr Value& operator[](const Key& key) { return at(key).second; }

	constexpr void rehash(std::size_t size) {
		unordered_map new_map{ hash_fn, size };
		new_map.m_size = m_size;
		for (std::size_t i = 0; i < capacity(); i++) {
			if (!key_hashes[i])
				continue;
			size_t j = new_map.m_hash(key_hashes[i], 0);
			new_map.key_hashes[j] = key_hashes[i];
			new_map.values[j] = std::move(values[i]);
		}
		*this = new_map;
	}
	constexpr void insert(Key&& key, Value&& value) {
		HashT key_hash = hash_fn(key);
		std::ptrdiff_t i = m_hash(key, 0);
		key_hashes[i] = key_hash;
		values[i].first = std::move(key);
		values[i].second = std::move(value);
		m_size++;
		if ((double)size() / capacity() > max_load) {
			rehash(capacity() * resize_ratio);
		}
	}
	template <typename KP, typename VP>
	constexpr void insert(KP&& key, VP&& value) {
		HashT key_hash = hash_fn(key);
		std::ptrdiff_t i = m_hash(key, 0);
		key_hashes[i] = key_hash;
		values[i].first = std::forward<KP>(key);
		values[i].second = std::forward<VP>(value);
		m_size++;
		if ((double)size() / capacity() > max_load) {
			rehash(capacity() * resize_ratio);
		}
	}

	constexpr void erase(const Key& key) {
		std::ptrdiff_t i = m_find(key, hash_fn(key));
		kassert(DEBUG_ONLY, WARNING, i >= 0, "Accessed missing key in hashmap.");
		key_hashes[i] = 0;
		values[i] = {};
	}

	constexpr iterator_type begin() { return { key_hashes, values.begin(), 0 }; }
	constexpr const iterator_type cbegin() { return { key_hashes, values.begin(), 0 }; }
	constexpr iterator_type end() { return { key_hashes, values.begin(), capacity() }; }
	constexpr const iterator_type cend() const { return { key_hashes, values.begin(), capacity() }; }

	constexpr std::size_t size() const { return m_size; }
	constexpr std::size_t capacity() const { return key_hashes.size(); }
	constexpr ~unordered_map() {
		key_hashes.~heap_array<HashT, allocator_reference<A>>();
		values.~heap_array<std::pair<Key, Value>, allocator_reference<A>>();
		alloc.~A();
	}
};
