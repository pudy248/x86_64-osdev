#pragma once
#include <initializer_list>
#include <iterator>
#include <kassert.hpp>
#include <kstddefs.hpp>
#include <kstdlib.hpp>
#include <stl/allocator.hpp>
#include <stl/container.hpp>
#include <stl/view.hpp>
#include <utility>

template <typename T, allocator A = default_allocator> class vector;
template <typename T, typename A> class vector_iterator;

template <typename T, typename A> class std::incrementable_traits<vector_iterator<T, A>> {
public:
	using difference_type = idx_t;
};
template <typename T, typename A> class std::indirectly_readable_traits<vector_iterator<T, A>> {
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

	constexpr T* operator()() const { return &(*cptr)[offset]; }
	constexpr operator T*() const { return (*this)(); }
	constexpr T& operator*() { return ptr->at(offset); }
	constexpr T& operator*() const { return (*cptr)[offset]; }
	constexpr operator T*() { return &**this; }
	constexpr operator const T*() const { return &**this; }
	constexpr vector_iterator& operator+=(idx_t v) {
		offset += v;
		return *this;
	}
	constexpr idx_t operator-(const vector_iterator& other) {
		return ptr == other.ptr ? offset - other.offset : 0;
	}
	constexpr bool operator==(const vector_iterator& other) const {
		return ptr == other.ptr && offset == other.offset;
	}
};

template <typename T, allocator A> class vector {
protected:
	static constexpr std::size_t resize_ratio = 2;
	allocator_traits<A>::ptr_t m_arr;
	std::size_t m_size;
	A alloc;
	std::size_t m_capacity;

public:
	using value_type = T;
	using iterator_type = vector_iterator<T, A>;

	constexpr T& m_at(idx_t idx) const { return ((T*)m_arr)[idx]; }
	constexpr vector()
		: m_arr(nullptr)
		, m_size(0)
		, m_capacity(0) {}
	vector(std::size_t size, A _alloc = A())
		: m_size(0)
		, alloc(_alloc)
		, m_capacity(size) {
		this->m_arr = (T*)alloc.alloc(sizeof(T) * m_capacity);
		new (this->m_arr) T[m_capacity];
	}
	template <convertible_iter_I<iterator_type> I, typename S>
		requires(!view<I, S>::Infinite)
	constexpr vector(const view<I, S>& v, const A& _alloc = A())
		: m_size(v.size())
		, alloc(_alloc)
		, m_capacity(v.size()) {
		this->m_arr = (T*)alloc.alloc(sizeof(T) * m_capacity);
		I iter = v.begin();
		for (std::size_t i = 0; i < size(); i++, iter++) { new (&m_at(i)) T(*iter); }
	}
	template <convertible_iter_I<iterator_type> I, typename S>
	constexpr vector(const I& begin, const S& end, const A& _alloc = A())
		: vector(view(begin, end), _alloc) {}

	vector(const vector& other)
		: vector(other.begin(), other.end(), other.alloc) {}
	constexpr vector(vector&& other)
		: m_arr(other.m_arr)
		, m_size(other.m_size)
		, alloc(std::move(other.alloc))
		, m_capacity(other.m_capacity) {
		other.unsafe_clear();
	}
	vector(std::initializer_list<T> list)
		: vector(list.begin(), list.end()) {}

	vector& operator=(const vector& other) {
		if (&other == this) return *this;
		this->~vector();
		new (this) vector(other);
		return *this;
	}
	vector& operator=(vector&& other) {
		this->~vector();
		new (this) vector(std::forward<vector<T, A>>(other));
		return *this;
	}
	void clear() {
		if (m_arr) {
			destruct(&*begin(), m_capacity);
			alloc.dealloc(m_arr);
		}
		this->unsafe_clear();
	}
	~vector() {
		clear();
		alloc.destroy();
	}

	constexpr void unsafe_clear() {
		this->m_arr = nullptr;
		this->m_size = 0;
		m_capacity = 0;
	}
	constexpr void unsafe_set(allocator_traits<A>::ptr_t arr, std::size_t l, std::size_t c) {
		this->m_arr = (T*)arr;
		this->m_size = l;
		this->m_capacity = c;
	}

	constexpr T& at(uidx_t idx) {
		if (this->capacity() <= idx) {
			std::size_t newCap = m_capacity < 1 ? 1 : m_capacity;
			while (newCap <= idx) newCap = newCap * resize_ratio;
			reserve(newCap);
		}
		this->m_size = max(this->m_size, idx + 1);
		return m_at(idx);
	}
	constexpr const T& at(idx_t idx) const {
		kassert(DEBUG_ONLY, WARNING, idx >= 0 && idx < size(), "OOB access in vector.at()\n");
		return m_at(idx);
	}
	template <typename Derived> constexpr auto& operator[](this Derived& self, idx_t idx) {
		return self.m_at(idx);
	}
	constexpr iterator_type begin() { return vector_iterator<T, A>{ {}, { this }, 0 }; }
	constexpr const iterator_type begin() const {
		return vector_iterator<T, A>{ {}, { .cptr = this }, 0 };
	}
	constexpr iterator_type end() { return vector_iterator<T, A>{ {}, { this }, this->size() }; }
	constexpr const iterator_type end() const {
		return vector_iterator<T, A>{ {}, { .cptr = this }, this->size() };
	}

	void reserve(std::size_t size) {
		if (m_capacity >= size) return;
		if (m_capacity)
			m_arr = (T*)alloc.realloc(m_arr, sizeof(T) * m_capacity, sizeof(T) * size);
		else
			m_arr = (T*)alloc.alloc(sizeof(T) * size);
		for (std::size_t i = m_capacity; i < size; i++) new (&m_at(i)) T();
		m_capacity = size;
	}
	void resize(std::size_t size) {
		reserve(size);
		this->m_size = size;
	}

	constexpr void append(T& elem) { this->at(this->size()) = std::forward<T>(elem); }
	constexpr void append(T&& elem) { this->at(this->size()) = std::forward<T>(elem); }
	template <convertible_iter_I<iterator_type> I, typename S>
		requires(!view<I, S>::Infinite)
	constexpr void append(const view<I, S>& other) {
		reserve(size() + other.size());
		I iter = other.begin();
		for (; iter != other.end(); iter++) append(*iter);
	}
	constexpr void append(const T* elems, std::size_t count) {
		append(view<T*, T*>(elems, elems + count));
	}

	constexpr void insert(T& elem, std::size_t idx) {
		if (idx >= this->size())
			this->at(idx) = elem;
		else {
			std::size_t i = this->size();
			this->at(i) = m_at(i - 1);
			for (i--; i > idx; i--) m_at(i) = std::move(m_at(i - 1));
			m_at(i) = std::forward<T>(elem);
		}
	}
	constexpr void insert(T&& elem, uidx_t idx) {
		if (idx >= this->size())
			this->at(idx) = elem;
		else {
			resize(size() + 1);
			for (idx_t i = this->size() - 1; i > idx; i--) m_at(i) = std::move(m_at(i - 1));
			m_at(idx) = std::forward<T>(elem);
		}
	}

	void erase(uidx_t idx) {
		if (idx >= this->size()) return;
		for (std::size_t i = idx + 1; i < this->size(); i++) m_at(i - 1) = m_at(i);
		this->m_size--;
	}
	void erase(uidx_t idx, std::size_t count) {
		if (idx >= this->size()) return;
		for (std::size_t i = 0; i < count; i++) erase(idx);
	}

	T* c_arr() const {
		T* arr2 = new T[this->size()];
		for (std::size_t i = 0; i < this->size(); i++) arr2[i] = m_at(i);
		return arr2;
	}
	constexpr std::size_t size() const volatile { return m_size; }
	constexpr std::size_t capacity() const volatile { return m_capacity; }
};

template <typename T> vector(T*, std::size_t) -> vector<T>;
