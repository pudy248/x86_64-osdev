#pragma once
#include <cstddef>
#include <kstddefs.h>
#include <kstdlib.hpp>

#define abs(a) (a < 0 ? -a : a)
#define min(a,b) ((a) < (b) ? (a) : (b))
#define max(a,b) ((a) > (b) ? (a) : (b))

template<typename T> class span {
protected:
	T* m_arr;
	int m_length;
public:
	constexpr span() : m_arr(NULL), m_length(0) { }
	constexpr span(const T* _arr, int size, int offset = 0) : m_arr((T*)_arr + offset), m_length(size) { }
	constexpr span(const span<T>& vec, int length, int offset = 0) : m_arr(vec.m_arr + offset), m_length(length) { }

	constexpr span(const span<T>& vec) : span(vec, vec.size(), 0) { }
	constexpr span(span<T>&& other) = default;

	constexpr span& operator=(const span<T>& other) {
		m_arr = other.m_arr;
		m_length = other.m_length;
		return *this;
	}
	constexpr span& operator=(span<T>&& other) {
		m_arr = other.m_arr;
		m_length = other.m_length;
		return *this;
	}
	
	constexpr T& at(int idx) {
		if (size() == 0) {
			//globals->vga_console.putstr("OOB access to span.\r\n");
			return *new T();
		}
		return m_arr[idx];
	}
	constexpr const T& at(int idx) const {
		if (size() == 0) {
			//globals->vga_console.putstr("OOB access to span.\r\n");
			return *new T();
		}
		return m_arr[idx];
	}
	constexpr T& operator[](int idx) {
		return at(idx);
	}
	constexpr const T& operator[](int idx) const {
		return at(idx);
	}
	constexpr T& front() {
		return at(0);
	}
	constexpr const T& front() const {
		return at(0);
	}
	constexpr T& back() {
		return at(size() - 1);
	}
	constexpr const T& back() const {
		return at(size() - 1);
	}
	constexpr span<T> subspan(int start) {
		return span<T>(*this, this->size() - start, start);
	}
	constexpr const span<T> subspan(int start) const {
		return span<T>(*this, this->size() - start, start);
	}

	constexpr int find(const T& elem) const {
		for (int i = 0; i < size(); i++) if (at(i) == elem) return i;
		return -1;
	}
	constexpr int find(const span<T>& elems) const {
		int index = m_length;
		for (int i = 0; i < elems.size(); i++) {
			int index2 = find(elems[i]);
			if (index2 != -1 && index2 < index)
				index = index2;
		}
		if (index == m_length)
			index = -1;
		return index;
	}
	constexpr bool contains(const T& elem) const {
		return find(elem) > -1;
	}
	constexpr bool contains(const span<T>& elems) const {
		return find(elems) > -1;
	}
	constexpr bool contains_which(const span<T>& elems) const {
		for (int i = 0; i < elems.size(); i++) {
			if (find(elems[i]) >= 0) return i;
		}
		return -1;
	}

    constexpr bool starts_with(const span<T> other) const {
		if (size() < other.size()) return false;
		for (int i = 0; i < other.size(); i++)
			if(at(i) != other.at(i))
				return false;
		return true;
	}
    constexpr bool starts_with(const T t) const {
		return starts_with(span<T>(&t, 1));
	}
    constexpr bool starts_with(const T* ptr, int length) const {
		return starts_with(span<T>(ptr, length));
	}

    constexpr bool ends_with(const span<T> other) const {
		if (size() < other.size()) return false;
		for (int i = size() - 1; i >= size() - other.size(); i--)
			if(at(i) != other.at(i - size() + other.size()))
				return false;
		return true;
	}
    constexpr bool ends_with(const T t) const {
		return ends_with(span<T>(&t, 1));
	}
    constexpr bool ends_with(const T* ptr, int length) const {
		return ends_with(span<T>(ptr, length));
	}

	constexpr T* begin() const {
		return unsafe_arr();
	}
	constexpr T* end() const {
		return unsafe_arr() + size();
	}

	constexpr bool equals(const span<T> other) const {
		return size() == other.size() && starts_with(other);
	}
	constexpr bool equals(const T* ptr, int length) const {
		return equals(span<T>(ptr, length));
	}

	constexpr T* unsafe_arr() const volatile {
		return m_arr;
	}
	constexpr int size() const volatile {
		return m_length;
	}
};

template<typename T> class vector : public span<T> {
protected:
	constexpr static float resize_ratio = 2;
	int m_capacity;

	void unsafe_clear() {
		this->m_arr = NULL;
		this->m_length = 0;
		m_capacity = 0;
	}
public:
	constexpr vector() : span<T>(NULL, 0), m_capacity(0) { }
	vector(int size) : m_capacity(size) {
		this->m_length = 0;
		this->m_arr = new T[m_capacity];
	}
	vector(vector<T>&& other) : span<T>(other.m_arr, other.m_length), m_capacity(other.m_capacity) {
		other.unsafe_clear();
	}
	
	vector(const T* _arr, int size, int start = 0) {
		m_capacity = size;
		this->m_length = m_capacity;
		this->m_arr = new T[m_capacity];
		for (int i = 0; i < this->m_length; i++)
			this->m_arr[i] = _arr[start + i];
	}
	vector(const vector<T>& other, int start = 0) : vector(other.unsafe_arr(), other.size(), start) { }
	vector(const span<T>& other, int start = 0) : vector(other.unsafe_arr(), other.size(), start) { }

	vector& operator=(const vector<T> &other) {
        if (&other == this) return *this;
		clear();
		m_capacity = other.size();
		this->m_length = m_capacity;
		this->m_arr = new T[m_capacity];
		for (int i = 0; i < this->m_length; i++)
			this->m_arr[i] = other.m_arr[i];
        return *this;
    }
    vector& operator=(vector<T> &&other) {
		clear();
		this->m_arr = other.m_arr;
		m_capacity = other.m_capacity;
		this->m_length = other.m_length;
		other.unsafe_clear();
        return *this;
    }
	void clear() {
		delete[] this->m_arr;
		unsafe_clear();
	}
	~vector() {
		clear();
	}

	void unsafe_set(T* arr, int l, int c) {
		this->m_arr = arr;
		this->m_length = l;
		this->m_capacity = c;
	}

	constexpr T& at(int idx) {
		if (this->capacity() <= idx) {
			int newCap = max(m_capacity, 1);
			while (newCap <= idx) newCap *= resize_ratio;
			reserve(newCap);
		}
		this->m_length = max(this->m_length, idx + 1);
		return this->m_arr[idx];
	}

	void reserve(int size) {
		if (m_capacity >= size) return;
		T* newArr = new T[size];
		if (this->m_arr) {
			for (int i = 0; i < this->m_length; i++)
				newArr[i] = this->m_arr[i];
			delete[] this->m_arr;
		}
		this->m_arr = newArr;
        m_capacity = size;
    }
	void resize(int size) {
		reserve(size);
		this->m_length = size;
	}

	void append(T elem) {
		this->at(this->size()) = elem;
	}
	void append(const span<T>& other) {
		for(int i = 0; i < other.size(); i++)
			append(other.at(i));
	}
	void append(const T* elems, int count) {
		append(span<T>(elems, count));
	}

	void insert(T elem, int idx) {
		if (idx >= this->size()) this->at(idx) = elem;
		else {
			int i = this->size();
			this->at(i) = this->m_arr[i - 1];
			for (i--; i > idx; i--)
				this->m_arr[i] = this->m_arr[i - 1];
			this->m_arr[i] = elem;
		}
	}
	void insert(const span<T>& elems, int idx) {
		for (int i = 0; i < elems.size(); i++)
			insert(elems.at(i), idx + i);
	}
	void insert(const T* elems, int count, int idx) {
		insert(span<T>(elems, count), idx);
	}
	
	void blit(const span<T>& elems, int idx) {
		for (int i = 0; i < elems.size(); i++) {
			this->at(idx + i) = elems.at(i);
		}
	}

	void erase(int idx) {
		if (idx >= this->size()) return;
		for (int i = idx + 1; i < this->size(); i++)
			this->m_arr[i - 1] = this->m_arr[i];
		this->m_length--;
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
	constexpr int capacity() const volatile {
		return m_capacity;
	}
};

template <typename T> class ostream {
public:
    vector<T> data;
    ostream() = default;

	void swrite(T elem) {
		data.append(elem);
	}
	void swrite(span<T> elems) {
		for (int i = 0; i < elems.size(); i++)
			write(elems[i]);
	}
};

template <typename T> class istream {
public:
    span<T> data;
    int idx = 0;
    istream() = default;
    istream(const span<T> s) : data(s) {}

    constexpr bool readable() const {
		return idx < data.size();
	}

	T sread() {
		return data.at(idx++);
	}
	span<T> sread(int count) {
		span<T> tmp = span<T>(data, idx, count);
		idx += count;
		return tmp;
	}

	span<T> read_while(bool(*condition)(span<T>)) {
		int sIdx = idx;
		while(condition(data.subspan(idx)) && readable()) idx++;
		return span<T>(data, idx - sIdx, sIdx);
	}
	span<T> read_until(bool(*condition)(span<T>)) {
		int sIdx = idx;
		while(!condition(data.subspan(idx)) && readable()) idx++;
		return span<T>(data, idx - sIdx, sIdx);
	}
	span<T> read_until_inc(bool(*condition)(span<T>)) {
		int sIdx = idx;
		while(!condition(data.subspan(idx)) && readable()) idx++;
		idx++;
		return span<T>(data, idx - sIdx, sIdx);
	}
};
