#pragma once
#include <initializer_list>
#include <iterator>
#include <kassert.hpp>
#include <kstddef.hpp>
#include <kstdlib.hpp>
#include <stl/allocator.hpp>
#include <stl/container.hpp>
#include <stl/pointer.hpp>
#include <stl/view.hpp>
#include <utility>

template <typename T, allocator A = default_allocator>
class heap_array {
protected:
	allocator_traits<A>::ptr_t m_arr = {};
	std::size_t m_size = 0;
	A alloc = {};

public:
	using value_type = T;
	using iterator_type = T*;

	constexpr T& m_at(idx_t idx) const { return ((T*)m_arr)[idx]; }
	constexpr heap_array() = default;
	constexpr heap_array(std::size_t size, A _alloc = A()) : m_size(size), alloc(_alloc) {
		this->m_arr = alloc.alloc(sizeof(T) * m_size);
		construct<T>(&*begin(), size);
	}
	template <convertible_iter_I<iterator_type> I, typename S>
		requires(!view<I, S>::Infinite)
	constexpr heap_array(const view<I, S>& v, const A& _alloc = A()) : m_size(v.size()), alloc(_alloc) {
		this->m_arr = alloc.alloc(sizeof(T) * m_size);
		I iter = v.begin();
		for (std::size_t i = 0; i < size(); i++, iter++)
			new (&m_at(i)) T(*iter);
	}
	template <convertible_iter_I<iterator_type> I, typename S>
	constexpr heap_array(const I& begin, const S& end, const A& _alloc = A()) : heap_array(view(begin, end), _alloc) {}
	template <container C>
	constexpr heap_array(const C& other, const A& _alloc = A()) : heap_array(other.cbegin(), other.cend(), _alloc) {}

	constexpr heap_array(const heap_array& other) : heap_array(other.begin(), other.end(), other.alloc) {}
	constexpr heap_array(heap_array&& other)
		: m_arr(alloc.move(other.alloc, other.m_arr)), m_size(other.m_size), alloc(std::move(other.alloc)) {
		other.unsafe_clear();
	}
	constexpr heap_array(std::initializer_list<T> list) : heap_array(list.begin(), list.end()) {}

	constexpr heap_array& operator=(const heap_array& other) {
		if (&other == this)
			return *this;
		this->~heap_array();
		new (this) heap_array(other);
		return *this;
	}
	constexpr heap_array& operator=(heap_array&& other) {
		this->~heap_array();
		new (this) heap_array(std::forward<heap_array<T, A>>(other));
		return *this;
	}
	constexpr void clear() {
		if (m_arr) {
			destruct(&*begin(), m_size);
			alloc.dealloc(m_arr);
		}
		this->unsafe_clear();
	}
	constexpr ~heap_array() {
		clear();
		alloc.destroy();
	}

	constexpr void unsafe_clear() {
		this->m_arr = nullptr;
		this->m_size = 0;
	}
	constexpr void unsafe_set(allocator_traits<A>::ptr_t arr, std::size_t l) {
		this->m_arr = arr;
		this->m_size = l;
	}

	constexpr T& at(idx_t idx) const {
		kassert(DEBUG_ONLY, WARNING, idx >= 0 && idx < size(), "OOB access in heap_array.at()\n");
		return m_at(idx);
	}
	template <typename Derived>
	constexpr auto& operator[](this Derived& self, idx_t idx) {
		return self.m_at(idx);
	}
	template <typename Derived>
	constexpr auto& front(this Derived& self) {
		return self.at(0);
	}
	template <typename Derived>
	constexpr auto& back(this Derived& self) {
		return self.at(self.size() - 1);
	}
	constexpr iterator_type begin() { return pointer<T, reinterpret>{ m_arr }(); }
	constexpr const iterator_type begin() const { return pointer<T, reinterpret>{ m_arr }(); }
	constexpr iterator_type end() { return begin() + m_size; }
	constexpr const iterator_type end() const { return begin() + m_size; }
	constexpr const pointer<T> cbegin() const { return begin(); }
	constexpr const pointer<T> cend() const { return cbegin() + size(); }
	constexpr std::size_t size() const volatile { return m_size; }
	constexpr bool empty() const { return !size(); }
};

template <typename T, allocator A = default_allocator_t<T>>
class vector;
template <typename T, typename A>
class vector_iterator;

template <typename T, typename A>
class std::incrementable_traits<vector_iterator<T, A>> {
public:
	using difference_type = idx_t;
};
template <typename T, typename A>
class std::indirectly_readable_traits<vector_iterator<T, A>> {
public:
	using value_type = T;
};

template <typename T, typename A>
class vector_iterator : public iterator_crtp<vector_iterator<T, A>> {
public:
	union {
		vector<T, A>* ptr;
		const vector<T, A>* cptr;
	};
	std::size_t offset;

	constexpr T* operator()() const { return cbase_ptr() + offset; }
	constexpr operator void*() const { return (*this)(); }
	constexpr T& operator*() { return ptr->at(offset); }
	constexpr T& operator*() const { return (*cptr)[offset]; }
	constexpr operator T*() { return base_ptr() + offset; }
	constexpr operator const T*() const { return cbase_ptr() + offset; }
	constexpr vector_iterator& operator+=(idx_t v) {
		offset += v;
		return *this;
	}
	constexpr idx_t operator-(const vector_iterator& other) { return ptr == other.ptr ? offset - other.offset : 0; }
	constexpr bool operator==(const vector_iterator& other) const { return ptr == other.ptr && offset == other.offset; }

protected:
	T* base_ptr() { return (T*)ptr->m_arr; }
	T* cbase_ptr() const { return (T*)cptr->m_arr; }
};

struct vec_resize {};

template <typename T, allocator A>
class vector : public heap_array<T, A> {
	friend class vector_iterator<T, A>;

protected:
	static constexpr std::size_t resize_ratio = 2;
	std::size_t m_capacity = 0;

	// unlike public reserve, allows shrinking
	void m_reserve(std::size_t size) {
		if (m_capacity >= size)
			destruct(&*begin() + m_capacity, m_capacity - size);
		if (m_capacity)
			this->m_arr = (T*)this->alloc.realloc(this->m_arr, sizeof(T) * m_capacity, sizeof(T) * size);
		else
			this->m_arr = (T*)this->alloc.alloc(sizeof(T) * size);
		if (m_capacity < size) {
			construct<T>(&*begin() + m_capacity, size - m_capacity);
		}
		if (m_capacity >= size) {
			this->m_size = size;
		}
		m_capacity = size;
	}

public:
	using value_type = T;
	using iterator_type = T*;
	using output_iterator_type = vector_iterator<T, A>;

	using heap_array<T, A>::heap_array;

	constexpr vector(std::size_t size, A _alloc = A()) : heap_array<T, A>(size, _alloc), m_capacity(this->m_size) {
		this->m_size = 0;
	}
	constexpr vector(std::size_t size, vec_resize, A _alloc = A())
		: heap_array<T, A>(size, _alloc), m_capacity(this->m_size) {}
	template <convertible_iter_I<iterator_type> I, typename S>
		requires(!view<I, S>::Infinite)
	constexpr vector(const view<I, S>& v, const A& _alloc = A())
		: heap_array<T, A>(v, _alloc), m_capacity(this->m_size) {}
	template <convertible_iter_I<iterator_type> I, typename S>
	constexpr vector(const I& begin, const S& end, const A& _alloc = A()) : vector(view(begin, end), _alloc) {}

	constexpr vector(std::initializer_list<T> list) : vector(list.begin(), list.end()) {}

	constexpr void unsafe_clear() {
		this->m_arr = nullptr;
		this->m_size = 0;
		m_capacity = 0;
	}
	constexpr void unsafe_set(allocator_traits<A>::ptr_t arr, std::size_t l, std::size_t c) {
		this->m_arr = arr;
		this->m_size = l;
		this->m_capacity = c;
	}

	constexpr T& at(uidx_t idx) {
		if (this->capacity() <= idx) {
			std::size_t newCap = m_capacity < 1 ? 1 : m_capacity;
			while (newCap <= idx)
				newCap = newCap * resize_ratio;
			reserve(newCap);
		}
		this->m_size = max(this->m_size, idx + 1);
		return this->m_at(idx);
	}
	constexpr const T& at(idx_t idx) const {
		kassert(DEBUG_ONLY, WARNING, idx >= 0 && idx < (idx_t)this->size(), "OOB access in vector.at()\n");
		return this->m_at(idx);
	}
	template <typename Derived>
	constexpr auto& operator[](this Derived& self, idx_t idx) {
		return self.m_at(idx);
	}

	constexpr iterator_type begin() { return &this->m_at(0); }
	constexpr const iterator_type begin() const { return &this->m_at(0); }
	constexpr iterator_type end() { return begin() + this->size(); }
	constexpr const iterator_type end() const { return begin() + this->size(); }
	constexpr const T* cbegin() const { return &this->m_at(0); }
	constexpr const T* cend() const { return cbegin() + this->size(); }
	constexpr output_iterator_type obegin() { return vector_iterator<T, A>{ {}, { this }, 0 }; }

	constexpr void reserve(std::size_t size) {
		if (m_capacity >= size)
			return;
		m_reserve(size);
	}
	// Allows shrinking
	constexpr void resize(std::size_t size) {
		reserve(size);
		this->m_size = size;
	}
	constexpr void shrink_to_fit() { m_reserve(this->size()); }

	constexpr void append(const T& elem) { this->at(this->size()) = elem; }
	template <convertible_iter_I<iterator_type> I, typename S>
		requires(!view<I, S>::Infinite)
	constexpr void append(const view<I, S>& other) {
		reserve(this->size() + other.size());
		I iter = other.begin();
		for (; iter != other.end(); iter++)
			append(*iter);
	}
	template <container C>
	constexpr void append(const C& other) {
		append(view(other.cbegin(), other.cend()));
	}
	constexpr void append(const T* elems, std::size_t count) { append(view<const T*, const T*>(elems, elems + count)); }

	constexpr void emplace_back(T&& elem) { this->at(this->size()) = elem; }
	template <std::same_as<std::remove_reference_t<T>> TF>
	constexpr void emplace_back(TF&& elem) {
		this->at(this->size()) = std::forward<TF>(elem);
	}
	template <typename... Args>
	constexpr void emplace_back(Args&&... args) {
		this->at(this->size()) = T(std::forward<Args>(args)...);
	}

	constexpr void insert(T& elem, std::size_t idx) {
		if (idx >= this->size())
			this->at(idx) = elem;
		else {
			std::size_t i = this->size();
			this->at(i) = this->m_at(i - 1);
			for (i--; i > idx; i--)
				this->m_at(i) = std::move(this->m_at(i - 1));
			this->m_at(i) = std::forward<T>(elem);
		}
	}
	constexpr void insert(T&& elem, uidx_t idx) {
		if (idx >= this->size())
			this->at(idx) = elem;
		else {
			resize(this->size() + 1);
			for (idx_t i = this->size() - 1; i > idx; i--)
				this->m_at(i) = std::move(this->m_at(i - 1));
			this->m_at(idx) = std::forward<T>(elem);
		}
	}

	void erase(uidx_t idx) {
		if (idx >= this->size())
			return;
		for (std::size_t i = idx + 1; i < this->size(); i++)
			this->m_at(i - 1) = this->m_at(i);
		this->m_size--;
	}
	void erase(uidx_t idx, std::size_t count) {
		if (idx >= this->size())
			return;
		for (std::size_t i = 0; i < count; i++)
			erase(idx);
	}

	T* c_arr() const {
		T* arr2 = new T[this->size()];
		for (std::size_t i = 0; i < this->size(); i++)
			arr2[i] = this->m_at(i);
		return arr2;
	}
	constexpr std::size_t capacity() const volatile { return m_capacity; }
};

template <typename T>
vector(T*, std::size_t) -> vector<T>;
