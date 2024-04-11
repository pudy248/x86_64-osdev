#pragma once
#include <concepts>
#include <utility>
#include <initializer_list>
#include <kstddefs.hpp>
#include <kstdlib.hpp>
#include <stl/container.hpp>
#include <stl/allocator.hpp>

template <typename T> class span : public basic_container<T, span<T>> {
protected:
	T* m_arr;
	int m_size;
public:
	using basic_container<T, span<T>>::basic_container;
	constexpr span() : m_arr(nullptr), m_size(0) { }
	template<std::convertible_to<T> R>
	constexpr span(const R* begin, const R* end) : m_arr((T*)begin), m_size(end - begin) { }
	template <container<T> C>
	constexpr span(const C& other) : span(other.begin(), other.end()) { }
	
	template <class Derived>
	constexpr T& at(this Derived& self, int idx) {
		kassert(idx >= 0 && idx < self.size(), "OOB access in span.at()\n");
		return self.m_arr[idx];
	}
	template <typename Derived>
	constexpr auto begin(this Derived& self) {
		return self.m_arr;
	}
	constexpr int size() const {
		return m_size;
	}
};

template<typename T, allocator A = default_allocator> class vector : public basic_container<T, vector<T, A>> {
protected:
	static constexpr int resize_ratio = 2;
	A alloc;
	allocator_traits<A>::ptr_t m_arr;
	int m_size;
	int m_capacity;
public:
	constexpr T& m_at(int idx) const {
		return ((T*)m_arr)[idx];
	}
	using basic_container<T, vector<T, A>>::basic_container;
	constexpr vector() : m_arr(nullptr), m_size(0), m_capacity(0) { }
	vector(int size, A _alloc = A()) : alloc(_alloc), m_size(0), m_capacity(size) {
		this->m_arr = alloc.alloc(sizeof(T) * m_capacity);
		new (this->m_arr) T[m_capacity];
	}
	template<std::convertible_to<T> R>
	vector(const R* begin, const R* end, A _alloc = A()) : alloc(_alloc), m_size(end - begin), m_capacity(end - begin) {
		this->m_arr = alloc.alloc(sizeof(T) * m_capacity);
		for (int i = 0; i < this->m_size; i++)
			new (&m_at(i)) T(begin[i]);
	}

	template <container<T> C2>
	vector(const C2& other, A _alloc = A()) : vector(other.begin(), other.end(), _alloc) { }
	template<allocator A2>
	vector(const vector<T, A2>& other, A _alloc = A()) : vector(other.begin(), other.end(), _alloc) { }
	vector(const vector& other) : vector(other.begin(), other.end(), A()) { }
	constexpr vector(vector&& other) : alloc(std::move(other.alloc)), m_arr(other.m_arr), m_size(other.m_size), m_capacity(other.m_capacity) {
		other.unsafe_clear();
	}
	vector(std::initializer_list<int> list) : vector(list.begin(), list.end()) { }

	template<allocator A2>
	vector& operator=(const vector<T, A2>& other) {
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
			destruct(begin(), m_capacity);
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
	constexpr void unsafe_set(allocator_traits<A>::ptr_t arr, int l, int c) {
		this->m_arr = arr;
		this->m_size = l;
		this->m_capacity = c;
	}

	constexpr T& at(int idx) {
		if (this->capacity() <= idx) {
			int newCap = m_capacity < 1 ? 1 : m_capacity;
			while (newCap <= idx) newCap = newCap * resize_ratio;
			reserve(newCap);
		}
		this->m_size = max(this->m_size, idx + 1);
		return m_at(idx);
	}
	constexpr const T& at(int idx) const {
		kassert(idx >= 0 && idx < size(), "OOB access in vector.at()\n");
		return m_at(idx);
	}
	constexpr T* begin() {
		return (T*)m_arr;
	}
	constexpr const T* begin() const {
		return (T*)m_arr;
	}

	void reserve(int size) {
		if (m_capacity >= size) return;
		if (m_capacity) m_arr = alloc.realloc(m_arr, sizeof(T) * m_capacity, sizeof(T) * size);
		else m_arr = alloc.alloc(size);
		for (int i = m_capacity; i < size; i++) new (&m_at(i)) T();
        m_capacity = size;
    }
	void resize(int size) {
		reserve(size);
		this->m_size = size;
	}

	constexpr void append(T& elem) {
		this->at(this->size()) = std::forward<T>(elem);
	}
	constexpr void append(T&& elem) {
		this->at(this->size()) = std::forward<T>(elem);
	}
	template <container<T> C2>
	constexpr void append(const C2& other) {
		for(int i = 0; i < other.size(); i++)
			append(other.at(i));
	}
	constexpr void append(const T* elems, int count) {
		append(span<T>(elems, count));
	}

	constexpr void insert(T& elem, int idx) {
		if (idx >= this->size()) this->at(idx) = elem;
		else {
			int i = this->size();
			this->at(i) = m_at(i - 1);
			for (i--; i > idx; i--)
				m_at(i) = std::move(m_at(i - 1));
			m_at(i) = std::forward<T>(elem);
		}
	}
	constexpr void insert(T&& elem, int idx) {
		if (idx >= this->size()) this->at(idx) = elem;
		else {
			resize(size() + 1);
			for (int i = this->size() - 1; i > idx; i--)
				m_at(i) = std::move(m_at(i - 1));
			m_at(idx) = std::forward<T>(elem);
		}
	}
	
	template <container<T> C2>
	void blit(const C2& elems, int idx) {
		for (int i = 0; i < elems.size(); i++) {
			this->at(idx + i) = elems.at(i);
		}
	}

	void erase(int idx) {
		if (idx >= this->size()) return;
		for (int i = idx + 1; i < this->size(); i++)
			m_at(i - 1) = m_at(i);
		this->m_size--;
	}
	void erase(int idx, int count) {
		if (idx >= this->size()) return;
		for (int i = 0; i < count; i++)
			erase(idx);
	}

	T* c_arr() const {
		T* arr2 = new T[this->size()];
		for (int i = 0; i < this->size(); i++)
			arr2[i] = m_at(i);
		return arr2;
	}
	constexpr int size() const volatile {
		return m_size;
	}
	constexpr int capacity() const volatile {
		return m_capacity;
	}
};
