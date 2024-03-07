#pragma once
#include <concepts>
#include <type_traits>
#include <kstdlib.hpp>

template <typename I, typename T> concept iterator = std::same_as<std::remove_const_t<std::remove_pointer_t<I>>*, T*>;

template <typename C, typename I> concept container_iterable_from =
requires(const I& begin, const I& end) {
	C(begin, end);
};

template <typename C, typename T> concept container = 
requires(C c) {
	requires requires(int i) { { c.at(i) } -> std::convertible_to<T>; };
	{ c.size() } -> std::convertible_to<int>;
	{ *c.begin() } -> std::convertible_to<T>;
	container_iterable_from<C, T*>;
};

template <typename T> class span;

template <typename T, container<T> C>
class basic_container : public C {
public:
	using C::C;
	template <iterator<T> I>
	requires container_iterable_from<C, I>
	constexpr basic_container(const I& begin, const I& end) : C(begin, end) { }
	template <iterator<T> I>
	requires container_iterable_from<C, I>
	constexpr basic_container(const I& begin, int size, int offset = 0) : C(begin + offset, begin + size + offset) { }
	template <container<T> C2>
	constexpr basic_container(const C2& begin, int size, int offset = 0) : C(begin.begin() + offset, begin.begin() + size + offset) { }

	constexpr T& operator[](int idx) {
		return this->at(idx);
	}
	constexpr const T& operator[](int idx) const {
		return this->at(idx);
	}
	constexpr T& front() {
		return this->at(0);
	}
	constexpr const T& front() const {
		return this->at(0);
	}
	constexpr T& back() {
		return this->at(this->size() - 1);
	}
	constexpr const T& back() const {
		return this->at(this->size() - 1);
	}

	template <container<T> C2>
	constexpr C2 subspan(int start) {
		return C2(this->begin() + start, this->end());
	}
	template <container<T> C2>
	constexpr const C2 subspan(int start) const {
		return C2(this->begin() + start, this->end());
	}

	constexpr int find(const T& elem) const {
		for (int i = 0; i < this->size(); i++) if (this->at(i) == elem) return i;
		return -1;
	}
	template <container<T> C2>
	constexpr int find(const C2& elems) const {
		int index = this->size();
		for (int i = 0; i < elems.size(); i++) {
			int index2 = find(elems[i]);
			if (index2 != -1 && index2 < index)
				index = index2;
		}
		if (index == this->size())
			index = -1;
		return index;
	}
	constexpr bool contains(const T& elem) const {
		return find(elem) > -1;
	}
	template <container<T> C2>
	constexpr bool contains(const C2& elems) const {
		return find(elems) > -1;
	}

	template <container<T> C2>
	constexpr int contains_which(const C2& elems) const {
		for (int i = 0; i < elems.size(); i++) {
			if (find(elems[i]) >= 0) return i;
		}
		return -1;
	}

	template <container<T> C2>
    constexpr bool starts_with(const C2 other) const {
		if (this->size() < other.size()) return false;
		for (int i = 0; i < other.size(); i++)
			if(this->at(i) != other.at(i))
				return false;
		return true;
	}
    constexpr bool starts_with(const T t) const {
		return this->at(0) == t;
	}
    constexpr bool starts_with(const T* ptr, int length) const {
		return starts_with(span<T>(ptr, ptr + length));
	}

	template <container<T> C2>
    constexpr bool ends_with(const C2 other) const {
		if (this->size() < other.size()) return false;
		for (int i = this->size() - 1; i >= this->size() - other.size(); i--)
			if(this->at(i) != other.at(i - this->size() + other.size()))
				return false;
		return true;
	}
    constexpr bool ends_with(const T t) const {
		return this->at(this->size() - 1) == t;
	}
    constexpr bool ends_with(const T* ptr, int length) const {
		return ends_with(span<T>(ptr, length, 0));
	}

	constexpr T* end() {
		return this->begin() + this->size();
	}
	constexpr const T* end() const {
		return this->begin() + this->size();
	}

	template <container<T> C2>
	constexpr bool equals(const C2 other) const {
		return this->size() == other.size() && starts_with(other);
	}
	constexpr bool equals(const T* ptr, int length) const {
		return equals(span<T>(ptr, length));
	}
	template <container<T> C2>
	constexpr bool operator==(const C2 other) const {
		return equals(other);
	}
	template <container<T> C2>
	constexpr bool operator!=(const C2 other) const {
		return !equals(other);
	}

	static constexpr T& static_at(basic_container* _this, int idx) {
		return _this->at(idx);
	}
	static constexpr T* static_begin(basic_container* _this) {
		return _this->begin();
	}
	static constexpr int static_size(basic_container* _this) {
		return _this->size();
	}
};
