#pragma once
#include <concepts>
#include <type_traits>

template <typename I, typename T> concept iterator = 
requires (I it) {
	//{ *it } -> std::convertible_to<std::add_const_t<T>>;
	//!std::is_const_v<std::remove_pointer_t<I>>;
	std::same_as<I, T>;
};

template <iterator<char>> class test {};
test<char*> t1;
test<const char*> t2;

template <typename C, typename I> concept container_iterable_from =
requires(const I begin, const I end) {
	C(begin, end);
};

template <typename C, typename T> concept container = 
requires(C c) {
	requires requires(int i) { { c.at(i) } -> std::convertible_to<T>; };
	{ c.size() } -> std::convertible_to<int>;
	{ *c.begin() } -> std::convertible_to<T>;
	container_iterable_from<C, T*>;
};

template <typename T, typename Impl>
class basic_container {
	constexpr inline Impl* this_c() const { return (Impl*)this; }
public:
	constexpr basic_container() = default;

	template<std::convertible_to<T> R>
	constexpr basic_container(const R* begin, int size, int offset = 0) {
		new (this) Impl (begin + offset, begin + size + offset);
	}
	template<container<T> C2>
	constexpr basic_container(const C2& begin, int size, int offset = 0) {
		new (this) Impl (begin.begin() + offset, begin.begin() + size + offset);
	}
	template <std::size_t N> 
	constexpr basic_container(const T(&other)[N]) { 
		new (this) Impl (other, other + N);
	}

	constexpr T& operator[](int idx) {
		return this_c()->at(idx);
	}
	constexpr const T& operator[](int idx) const {
		return this_c()->at(idx);
	}
	constexpr T& front() {
		return this_c()->at(0);
	}
	constexpr const T& front() const {
		return this_c()->at(0);
	}
	constexpr T& back() {
		return this_c()->at(this_c()->size() - 1);
	}
	constexpr const T& back() const {
		return this_c()->at(this_c()->size() - 1);
	}

	template <container<T> C2>
	constexpr C2 subspan(int start) {
		return C2(this_c()->begin() + start, this_c()->end());
	}
	template <container<T> C2>
	constexpr const C2 subspan(int start) const {
		return C2(this_c()->begin() + start, this_c()->end());
	}

	constexpr int find(const T& elem) const {
		for (int i = 0; i < this_c()->size(); i++) if (this_c()->at(i) == elem) return i;
		return -1;
	}
	template <container<T> C2>
	constexpr int find(const C2& elems) const {
		int index = this_c()->size();
		for (int i = 0; i < elems.size(); i++) {
			int index2 = find(elems[i]);
			if (index2 != -1 && index2 < index)
				index = index2;
		}
		if (index == this_c()->size())
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
		if (this_c()->size() < other.size()) return false;
		for (int i = 0; i < other.size(); i++)
			if(this_c()->at(i) != other.at(i))
				return false;
		return true;
	}
    constexpr bool starts_with(const T t) const {
		return this_c()->at(0) == t;
	}
    constexpr bool starts_with(const T* ptr, int length) const {
		return starts_with(span<T>(ptr, ptr + length));
	}

	template <container<T> C2>
    constexpr bool ends_with(const C2 other) const {
		if (this_c()->size() < other.size()) return false;
		for (int i = this_c()->size() - 1; i >= this_c()->size() - other.size(); i--)
			if(this_c()->at(i) != other.at(i - this_c()->size() + other.size()))
				return false;
		return true;
	}
    constexpr bool ends_with(const T t) const {
		return this_c()->at(this_c()->size() - 1) == t;
	}
    constexpr bool ends_with(const T* ptr, int length) const {
		return ends_with(span<T>(ptr, length, 0));
	}

	constexpr T* end() {
		return this_c()->begin() + this_c()->size();
	}
	constexpr const T* end() const {
		return this_c()->begin() + this_c()->size();
	}

	template <container<T> C2>
	constexpr bool equals(const C2 other) const {
		return this_c()->size() == other.size() && starts_with(other);
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
		return ((Impl*)_this)->at(idx);
	}
	static constexpr T* static_begin(basic_container* _this) {
		return ((Impl*)_this)->begin();
	}
	static constexpr int static_size(basic_container* _this) {
		return ((Impl*)_this)->size();
	}
};
