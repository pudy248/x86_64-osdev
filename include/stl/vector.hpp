#pragma once
#include <cstddef>
#include <utility>
#include <initializer_list>
#include <kstddefs.hpp>
#include <kstdlib.hpp>
#include <stl/container.hpp>

template <typename T> class span_v {
protected:
	T* m_arr;
	int m_size;
public:
	constexpr span_v() : m_arr(nullptr), m_size(0) { }
	constexpr span_v(const T* begin, const T* end) : m_arr((T*)begin), m_size(end - begin) { }
	template <container<T> C> constexpr span_v(const C& other) : span_v<T>(other.begin(), other.end()) { }

	constexpr T& at(int idx) {
		kassert(idx >= 0 && idx < size(), "OOB access in span_v.at()\n");
		return m_arr[idx];
	}
	constexpr const T& at(int idx) const {
		kassert(idx >= 0 && idx < size(), "OOB access in span_v.at()\n");
		return m_arr[idx];
	}
	constexpr T* begin() const {
		return m_arr;
	}
	constexpr int size() const {
		return m_size;
	}
};

template <typename T> class span : public basic_container<T, span_v<T>> {
public:
	using basic_container<T, span_v<T>>::basic_container;
	template <container<T> C> constexpr span(const C& other) : basic_container<T, span_v<T>>(other.begin(), other.end()) { }
	template <std::size_t N> constexpr span(const T(&other)[N]) : basic_container<T, span_v<T>>(other, other + N) { }
};

template<typename T> class vector_v {
protected:
	static constexpr float resize_ratio = 2;
	T* m_arr;
	int m_size;
	int m_capacity;
public:
	constexpr vector_v() : m_arr(nullptr), m_size(0), m_capacity(0) { }

	vector_v(int size) : m_size(0), m_capacity(size) {
		this->m_arr = new T[m_capacity];
	}
	template <std::convertible_to<T> R>
	vector_v(const R* begin, const R* end) : m_size(end - begin), m_capacity(end - begin) {
		this->m_arr = new T[m_capacity];
		for (int i = 0; i < this->m_size; i++)
			new (&this->m_arr[i]) T (begin[i]);
	}
	
	template <container<T> C2>
	vector_v(const C2& other) : vector_v(other.begin(), other.end()) { }

	vector_v(const vector_v<T>& other) : vector_v<T>(other.begin(), other.end()) { }
	constexpr vector_v(vector_v<T>&& other) : m_arr(other.m_arr), m_size(other.m_size), m_capacity(other.m_capacity) {
		other.unsafe_clear();
	}
	
	vector_v(std::initializer_list<int> list) : vector_v(list.begin(), list.end()) { }

	vector_v& operator=(const vector_v<T> &other) {
        if (&other == this) return *this;
		clear();
		m_capacity = other.size();
		this->m_size = m_capacity;
		this->m_arr = new T[m_capacity];
		for (int i = 0; i < this->m_size; i++)
			this->m_arr[i] = other.m_arr[i];
        return *this;
    }
    vector_v& operator=(vector_v<T> &&other) {
		clear();
		this->m_arr = other.m_arr;
		m_capacity = other.m_capacity;
		this->m_size = other.m_size;
		other.unsafe_clear();
        return *this;
    }
	void clear() {
		delete[] this->m_arr;
		unsafe_clear();
	}
	~vector_v() {
		clear();
	}

	constexpr void unsafe_clear() {
		this->m_arr = nullptr;
		this->m_size = 0;
		m_capacity = 0;
	}
	constexpr void unsafe_set(T* arr, int l, int c) {
		this->m_arr = arr;
		this->m_size = l;
		this->m_capacity = c;
	}

	constexpr T& at(int idx) {
		if (this->capacity() <= idx) {
			int newCap = m_capacity < 1 ? 1 : m_capacity;
			while (newCap <= idx) newCap = (float)newCap * resize_ratio;
			reserve(newCap);
		}
		this->m_size = max(this->m_size, idx + 1);
		return this->m_arr[idx];
	}
	constexpr const T& at(int idx) const {
		kassert(idx >= 0 && idx < size(), "OOB access in vector_v.at()\n");
		return m_arr[idx];
	}
	constexpr T* begin() const {
		return m_arr;
	}

	void reserve(int size) {
		if (m_capacity >= size) return;
		T* newArr = new T[size];
		if (this->m_arr) {
			for (int i = 0; i < this->m_size; i++)
				newArr[i] = std::move(this->m_arr[i]);
			delete[] this->m_arr;
		}
		this->m_arr = newArr;
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
			this->at(i) = this->m_arr[i - 1];
			for (i--; i > idx; i--)
				this->m_arr[i] = std::move(this->m_arr[i - 1]);
			this->m_arr[i] = std::forward<T>(elem);
		}
	}
	constexpr void insert(T&& elem, int idx) {
		if (idx >= this->size()) this->at(idx) = elem;
		else {
			resize(size() + 1);
			for (int i = this->size() - 1; i > idx; i--)
				this->m_arr[i] = std::move(this->m_arr[i - 1]);
			this->m_arr[idx] = std::forward<T>(elem);
		}
	}
	//template <container<T> C2>
	//constexpr void insert(const C2& elems, int idx) {
	//	for (int i = 0; i < elems.size(); i++)
	//		insert(elems.at(i), idx + i);
	//}
	//void insert(const T* elems, int count, int idx) {
	//	insert(span<T>(elems, count), idx);
	//}
	
	template <container<T> C2>
	void blit(const C2& elems, int idx) {
		for (int i = 0; i < elems.size(); i++) {
			this->at(idx + i) = elems.at(i);
		}
	}

	void erase(int idx) {
		if (idx >= this->size()) return;
		for (int i = idx + 1; i < this->size(); i++)
			this->m_arr[i - 1] = this->m_arr[i];
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
			arr2[i] = this->m_arr[i];
		return arr2;
	}
	constexpr int size() const volatile {
		return m_size;
	}
	constexpr int capacity() const volatile {
		return m_capacity;
	}
};

template <typename T> class vector : public basic_container<T, vector_v<T>> {
public:
	using basic_container<T, vector_v<T>>::basic_container;
	constexpr vector(const vector<T>& other) : basic_container<T, vector_v<T>>(other) { }
	constexpr vector(vector<T>&& other) : basic_container<T, vector_v<T>>(other) { }
	constexpr vector<T>& operator=(const vector<T>& other) {
		*(vector_v<T>*)this = *(vector_v<T>*)&other;
		return *this;
	}
	constexpr vector<T>& operator=(vector<T>&& other) {
		*(vector_v<T>*)this = std::move(*(vector_v<T>*)&other);
		return *this;
	}
	template <std::size_t N, std::convertible_to<T> R> constexpr vector(const R(&other)[N]) : basic_container<T, vector_v<T>>(other, other + N) { }
};

template <typename T, std::size_t N> class array_v {
protected:
	T m_arr[N];
public:
	constexpr array_v() : m_arr() { }
	template <std::convertible_to<T> R>
	constexpr array_v(const R* begin, const R* end) {
		std::size_t i = 0;
		for (; i < min((std::size_t)(end - begin), N); i++) {
			new (&m_arr[i]) T (begin[i]);
		}
		for (; i < N; i++) {
			m_arr[i] = R();
		}
	}

	constexpr T& at(int idx) {
		kassert(idx >= 0 && idx < size(), "OOB access in array_v.at()\n");
		return m_arr[idx];
	}
	constexpr const T& at(int idx) const {
		kassert(idx >= 0 && idx < size(), "OOB access in array_v.at()\n");
		return m_arr[idx];
	}
	constexpr T* begin() {
		return m_arr;
	}
	constexpr const T* begin() const {
		return m_arr;
	}
	constexpr int size() const {
		return N;
	}
};

template <typename T, std::size_t N> class array : public basic_container<T, array_v<T, N>> {
public:
	using basic_container<T, array_v<T, N>>::basic_container;
	template <container<T> C> constexpr array(const C& other) : basic_container<T, array_v<T, N>>(other.begin(), other.end()) { }
	template <std::size_t N2, std::convertible_to<T> R> constexpr array(const R(&other)[N2]) : basic_container<T, array_v<T, N2>>(other, other + N) { }
};

template <typename C, typename T>
requires container<C, T>
class basic_ostream {
public:
    C data;
	int offset = 0;
	
    constexpr basic_ostream() = default;
	template <container<T> C2>
    constexpr basic_ostream(C2&& s) : data(s) {}

	constexpr void swrite(T elem) {
		data.at(offset++) = elem;
	}
	template <container<T> C2>
	constexpr void swrite(const C2& elems) {
		for (int i = 0; i < elems.size(); i++)
			swrite(elems[i]);
	}
};

template <typename C, typename T>
requires container<C, T>
class basic_istream {
public:
    C data;
    int offset = 0;
    constexpr basic_istream() = default;
	template <container<T> C2>
    constexpr basic_istream(const C2& s) : data(s) {}
	template <container<T> C2>
    constexpr basic_istream(C2&& s) : data(s) {}

    constexpr bool readable() const {
		return offset < data.size();
	}
	constexpr operator bool() const {
		return readable();
	}
	constexpr T front() {
        return data.at(offset);
    }
	constexpr T sread() {
		return data.at(offset++);
	}

	template <container<T> C2, container<T> C3>
	constexpr C2 read_until(bool(*condition)(C3), bool inclusive = false) {
		int sIdx = offset;
		while(!condition(C3(data, data.size() - offset, sIdx)) && readable()) offset++;
		if (inclusive && readable()) offset++;
		return C2(data, offset - sIdx, sIdx);
	}
	template <container<T> C2, container<T> C3>
	constexpr C2 read_while(bool(*condition)(C3)) {
		int sIdx = offset;
		while(condition(C3(data, data.size() - offset, sIdx)) && readable())
			offset++;
		return C2(data, offset - sIdx, sIdx);
	}
	template <container<T> C2>
	constexpr C2 read_until_v(const T val, bool inclusive = false) {
		int sIdx = offset;
		while(front() != val && readable()) offset++;
		if (inclusive && readable()) offset++;
		return C2(data, offset - sIdx, sIdx);
	}
	constexpr int read_while_v(const T val) {
		int sIdx = offset;
		while(front() == val && readable())
			offset++;
		return offset - sIdx;
	}
};

template <typename T> class container_wrapper_v {
public:
	void* _container;
	T&(*_at)(void*, int);
	T*(*_begin)(void*);
	int(*_size)(void*);

	template <container<T> C>
	constexpr container_wrapper_v(C& other) : _container(&other), _at((T&(*)(void*,int))&C::static_at), _begin((T*(*)(void*))&C::static_begin), _size((int(*)(void*))&C::static_size) { }
	constexpr container_wrapper_v(T* begin, T* end) { 
		print("container_wrapper_v initialization with pointers not supported!\n");
		inf_wait();
	}
	T& at(int idx) {
		return _at(_container, idx);
	}
	T* begin() {
		return _begin(_container);
	}
	int size() {
		return _size(_container);
	}
};

template <typename T> class container_wrapper : public basic_container<T, container_wrapper_v<T>> {
public:
	using basic_container<T, container_wrapper_v<T>>::basic_container;
	template <container<T> C> constexpr container_wrapper(C& other) : basic_container<T, container_wrapper_v<T>>(other) { }
};
