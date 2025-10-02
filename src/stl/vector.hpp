#pragma once
#include <concepts>
#include <initializer_list>
#include <iterator>
#include <kassert.hpp>
#include <kstddef.hpp>
#include <kstdlib.hpp>
#include <stl/allocator.hpp>
#include <stl/container.hpp>
#include <stl/pointer.hpp>
#include <stl/ranges.hpp>
#include <utility>

template <typename T, allocator A = default_allocator<T>>
class heap_array {
protected:
	allocator_traits<A>::ptr_t m_arr = {};
	std::size_t m_size = 0;
	A alloc = {};

public:
	using value_type = T;
	using iterator_type = T*;

	constexpr T& m_at(std::ptrdiff_t idx) const { return ((T*)m_arr)[idx]; }
	constexpr heap_array() = default;
	constexpr heap_array(std::size_t size, A _alloc = A()) : m_size(size), alloc(_alloc) {
		this->m_arr = alloc.alloc(sizeof(T) * m_size);
		construct<T>(&*begin(), size);
	}
	template <std::input_iterator I, std::sized_sentinel_for<I> S>
	constexpr heap_array(I it, S sent, const A& _alloc = A()) : m_size(sent - it), alloc(_alloc) {
		this->m_arr = alloc.alloc(sizeof(T) * m_size);
		for (std::size_t i = 0; i < size(); i++, it++)
			new (&m_at(i)) T(*it);
	}
	template <ranges::range R>
	constexpr heap_array(const R& range, const A& _alloc = A())
		: heap_array(ranges::begin(range), ranges::end(range), _alloc) {}

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
	template <typename Derived>
	constexpr void clear(this Derived& self) {
		if (self.m_arr) {
			destruct(&*self.begin(), self.m_size);
			self.alloc.dealloc(self.m_arr);
		}
		self.unsafe_clear();
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

	constexpr T& at(std::ptrdiff_t idx) const {
		kassert(DEBUG_ONLY, WARNING, idx >= 0 && idx < size(), "OOB access in heap_array.at()\n");
		return m_at(idx);
	}
	template <typename Derived>
	constexpr auto& operator[](this Derived& self, std::ptrdiff_t idx) {
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
	constexpr iterator_type begin() { return pointer<T, reinterpret>{m_arr}(); }
	constexpr iterator_type data() { return begin(); }
	constexpr const iterator_type begin() const { return pointer<T, reinterpret>{m_arr}(); }
	constexpr iterator_type end() { return begin() + m_size; }
	constexpr const iterator_type end() const { return begin() + m_size; }
	constexpr const iterator_type cbegin() const { return begin(); }
	constexpr const iterator_type cend() const { return cbegin() + size(); }
	constexpr std::size_t size() const { return m_size; }
	constexpr bool empty() const { return !size(); }
};

template <typename T, allocator A = default_allocator<T>>
class vector;
template <typename T, typename A>
class vector_iterator;

template <typename T, typename A>
class std::incrementable_traits<vector_iterator<T, A>> {
public:
	using difference_type = std::ptrdiff_t;
};
template <typename T, typename A>
class std::indirectly_readable_traits<vector_iterator<T, A>> {
public:
	using value_type = T;
};

template <typename T, typename A>
class vector_iterator : public random_access_iterator_interface<vector_iterator<T, A>> {
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
	constexpr vector_iterator& operator+=(std::ptrdiff_t v) {
		offset += v;
		return *this;
	}
	constexpr std::ptrdiff_t operator-(const vector_iterator& other) {
		return ptr == other.ptr ? offset - other.offset : 0;
	}
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
	constexpr void m_reserve(std::size_t size) {
		if (m_capacity >= size)
			destruct(this->begin() + m_capacity, m_capacity - size);
		if (m_capacity)
			this->m_arr = (T*)this->alloc.realloc(this->m_arr, sizeof(T) * m_capacity, sizeof(T) * size);
		else
			this->m_arr = (T*)this->alloc.alloc(sizeof(T) * size);
		if (m_capacity < size)
			construct<T>(this->begin() + m_capacity, size - m_capacity);
		if (m_capacity >= size)
			this->m_size = size;
		m_capacity = size;
	}

public:
	using value_type = T;
	using iterator_type = T*;
	using output_iterator_type = std::back_insert_iterator<vector<T, A>>;

	using heap_array<T, A>::heap_array;

	constexpr vector(std::size_t size, A _alloc = A()) : heap_array<T, A>(size, _alloc), m_capacity(this->m_size) {
		this->m_size = 0;
	}
	constexpr vector(std::size_t size, vec_resize, A _alloc = A())
		: heap_array<T, A>(size, _alloc), m_capacity(this->m_size) {}
	template <std::input_iterator I, std::sentinel_for<I> S>
	constexpr vector(const I& begin, const S& end, const A& _alloc = A()) : vector(0, _alloc) {
		for (I iter = begin; iter != end; ++iter)
			push_back(*iter);
	}
	template <std::input_iterator I, std::sized_sentinel_for<I> S>
	constexpr vector(const I& begin, const S& end, const A& _alloc = A())
		: heap_array<T, A>(begin, end, _alloc), m_capacity(this->m_size) {}
	template <ranges::range R>
	constexpr vector(const R& range, const A& _alloc = A())
		: heap_array<T, A>(ranges::begin(range), ranges::end(range), _alloc), m_capacity(this->m_size) {}

	constexpr vector(std::initializer_list<T> list) : vector(list.begin(), list.end()) {}

	constexpr vector(const vector& other) : vector(other.begin(), other.end()) {}
	constexpr vector(vector&& other)
		: heap_array<T, A>(static_cast<heap_array<T, A>>(std::move(other))), m_capacity(other.m_capacity) {}
	constexpr vector& operator=(const vector& other) = default;
	constexpr vector& operator=(vector&& other) = default;

	constexpr std::size_t capacity() const { return m_capacity; }

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

	constexpr T& iat(std::size_t idx) {
		if (this->capacity() <= idx) {
			std::size_t newCap = m_capacity < 1 ? 1 : m_capacity;
			while (newCap <= idx)
				newCap = newCap * resize_ratio;
			reserve(newCap);
		}
		this->m_size = max(this->m_size, idx + 1);
		return this->m_at(idx);
	}
	constexpr T& at(std::ptrdiff_t idx) {
		kassert(DEBUG_ONLY, WARNING, idx >= 0 && idx < (std::ptrdiff_t)this->size(), "OOB access in vector.at()\n");
		return this->m_at(idx);
	}
	constexpr const T& at(std::ptrdiff_t idx) const {
		kassert(DEBUG_ONLY, WARNING, idx >= 0 && idx < (std::ptrdiff_t)this->size(), "OOB access in vector.at()\n");
		return this->m_at(idx);
	}
	template <typename Derived>
	constexpr auto& operator[](this Derived& self, std::ptrdiff_t idx) {
		return self.m_at(idx);
	}

	constexpr iterator_type begin() { return (iterator_type)this->m_arr; }
	constexpr const iterator_type begin() const { return (const iterator_type)this->m_arr; }
	constexpr iterator_type end() { return begin() + this->size(); }
	constexpr const iterator_type end() const { return begin() + this->size(); }
	constexpr const T* cbegin() const { return (T*)this->m_arr; }
	constexpr const T* cend() const { return cbegin() + this->size(); }
	//constexpr output_iterator_type obegin() { return vector_iterator<T, A>{ {}, { this }, 0 }; }
	constexpr output_iterator_type oend() {
		return std::back_inserter(*this);
		// return vector_iterator<T, A>{ {}, { this }, this->size() };
	}

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

	constexpr void push_back(const T& elem) { this->iat(this->size()) = elem; }
	template <typename... Ts>
		requires std::constructible_from<T, Ts...>
	constexpr void push_back(Ts&&... args) {
		this->iat(this->size()) = T(args...);
	}
	template <ranges::range R>
	constexpr void push_back(const R& other) {
		if constexpr (ranges::sized_range<R>)
			reserve(this->size() + ranges::size(other));
		auto iter = ranges::begin(other);
		for (; iter != ranges::end(other); iter++)
			push_back(*iter);
	}
	constexpr void push_back(const T* elems, std::size_t count) {
		push_back(view<const T*, const T*>(elems, elems + count));
	}

	constexpr void emplace_back(T&& elem) { this->iat(this->size()) = elem; }
	template <std::same_as<std::remove_reference_t<T>> TF>
	constexpr void emplace_back(TF&& elem) {
		this->iat(this->size()) = std::forward<TF>(elem);
	}
	template <typename... Args>
	constexpr void emplace_back(Args&&... args) {
		this->iat(this->size()) = T(std::forward<Args>(args)...);
	}

	constexpr void insert(T& elem, std::size_t idx) {
		if (idx >= this->size())
			this->iat(idx) = elem;
		else {
			std::size_t i = this->size();
			this->iat(i) = this->m_at(i - 1);
			for (i--; i > idx; i--)
				this->m_at(i) = std::move(this->m_at(i - 1));
			this->m_at(i) = std::forward<T>(elem);
		}
	}
	constexpr void insert(T&& elem, std::size_t idx) {
		if (idx >= this->size())
			this->iat(idx) = elem;
		else {
			resize(this->size() + 1);
			for (std::size_t i = this->size() - 1; i > idx; i--)
				this->m_at(i) = std::move(this->m_at(i - 1));
			this->m_at(idx) = std::forward<T>(elem);
		}
	}

	constexpr void erase(std::size_t idx) {
		if (idx >= this->size())
			return;
		for (std::size_t i = idx + 1; i < this->size(); i++)
			this->m_at(i - 1) = this->m_at(i);
		this->m_size--;
	}
	constexpr void erase(std::size_t idx, std::size_t count) {
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
};

template <typename T>
vector(T*, std::size_t) -> vector<T>;
template <typename I, typename S>
vector(const I& begin, const S& end) -> vector<std::iter_value_t<I>>;
