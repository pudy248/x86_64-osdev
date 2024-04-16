#pragma once
#include <concepts>
#include <kstdlib.hpp>
#include <type_traits>

template <typename I, typename T>
concept iterator = requires(I it) {
	{ *it } -> std::convertible_to<std::add_const_t<T>>;
};

template <typename C, typename T>
concept condition = requires(C comparator, T obj) {
	{ comparator(obj) } -> std::convertible_to<bool>;
};
template <typename C, typename T>
concept comparator = requires(C comparator, T lhs, T rhs) {
	{ comparator(lhs, rhs) } -> std::convertible_to<int>;
};

template <typename C, typename T>
concept container = requires(const C c) {
	requires requires(int i) {
		{ c.at(i) } -> std::convertible_to<const T>;
	};
	{ c.size() } -> std::convertible_to<int>;
	{ *c.begin() } -> std::convertible_to<const T>;
};

template <typename C, typename T>
concept container_writeable = requires(C c) {
	requires requires(int i) {
		{ c.at(i) } -> std::convertible_to<T&>;
	};
	requires requires(T * begin, T * end) {
		C(begin, end);
	};
};

template <typename T> class span;

template <typename T, typename Impl>
//requires container<Impl, T>
class basic_container {
public:
	constexpr basic_container() = default;

	template <std::convertible_to<T> R> constexpr basic_container(const R* begin, int size, int offset = 0) {
		new (this) Impl(begin + offset, begin + size + offset);
	}
	template <container<T> C2> constexpr basic_container(const C2& begin, int size, int offset = 0) {
		new (this) Impl(begin.begin() + offset, begin.begin() + size + offset);
	}
	template <std::size_t N> constexpr basic_container(const T (&other)[N]) {
		new (this) Impl(other, other + N);
	}

	template <class Derived> constexpr T& operator[](this Derived& self, int idx) {
		return self.at(idx);
	}
	template <class Derived> constexpr T& front(this Derived& self) {
		return self.at(0);
	}
	template <class Derived> constexpr T& back(this Derived& self) {
		return self.at(self.size() - 1);
	}

	template <container_writeable<T> C2 = span<T>, class Derived> constexpr C2 subspan(this Derived& self, int start) {
		return C2(self.begin() + start, self.end());
	}
	template <container_writeable<T> C2 = span<T>, class Derived>
	constexpr C2 subspan(this Derived& self, int start, int end) {
		return C2(self.begin() + start, self.begin() + start + end);
	}
	template <container<T> C2, class Derived> void blit(this Derived& self, const C2& elems, int idx) {
		for (int i = 0; i < elems.size(); i++) {
			self.at(idx + i) = elems.at(i);
		}
	}

	template <class Derived> constexpr int find(this const Derived& self, const T& elem) {
		for (int i = 0; i < self.size(); i++)
			if (self.at(i) == elem)
				return i;
		return -1;
	}
	template <container<T> C2, class Derived> constexpr int find(this const Derived& self, const C2& elems) {
		int index = self.size();
		for (int i = 0; i < elems.size(); i++) {
			int index2 = self.find(elems[i]);
			if (index2 != -1 && index2 < index)
				index = index2;
		}
		if (index == self.size())
			index = -1;
		return index;
	}
	template <class Derived> constexpr bool contains(this const Derived& self, const T& elem) {
		return self.find(elem) > -1;
	}
	template <container<T> C2, class Derived> constexpr bool contains(this const Derived& self, const C2& elems) {
		return self.find(elems) > -1;
	}

	template <container<T> C2, class Derived> constexpr int contains_which(this const Derived& self, const C2& elems) {
		for (int i = 0; i < elems.size(); i++) {
			if (self.find(elems[i]) >= 0)
				return i;
		}
		return -1;
	}

	template <container<T> C2, class Derived> constexpr bool starts_with(this const Derived& self, const C2 other) {
		if (self.size() < other.size())
			return false;
		for (int i = 0; i < other.size(); i++)
			if (self.at(i) != other.at(i))
				return false;
		return true;
	}
	template <class Derived> constexpr bool starts_with(this const Derived& self, const T t) {
		return self.at(0) == t;
	}
	template <class Derived> constexpr bool starts_with(this const Derived& self, const T* ptr, int length) {
		return self.starts_with(span<T>(ptr, ptr + length));
	}

	template <container<T> C2, class Derived> constexpr bool ends_with(this const Derived& self, const C2 other) {
		if (self.size() < other.size())
			return false;
		for (int i = self.size() - 1; i >= self.size() - other.size(); i--)
			if (self.at(i) != other.at(i - self.size() + other.size()))
				return false;
		return true;
	}
	template <class Derived> constexpr bool ends_with(this const Derived& self, const T t) {
		return self.at(self.size() - 1) == t;
	}
	template <class Derived> constexpr bool ends_with(this const Derived& self, const T* ptr, int length) {
		return self.ends_with(span<T>(ptr, length, 0));
	}

	template <class Derived> constexpr auto end(this Derived& self) {
		return self.begin() + self.size();
	}

	template <container<T> C2, class Derived> constexpr bool equals(this const Derived& self, const C2 other) {
		return self.size() == other.size() && self.starts_with(other);
	}
	template <class Derived> constexpr bool equals(this const Derived& self, const T* ptr, int length) {
		return self.equals(span<T>(ptr, length));
	}
	template <container<T> C2, class Derived> constexpr bool operator==(this const Derived& self, const C2 other) {
		return self.equals(other);
	}
	template <container<T> C2, class Derived> constexpr bool operator!=(this const Derived& self, const C2 other) {
		return !self.equals(other);
	}

	static constexpr const T& static_cat(basic_container* _this, int idx) {
		return ((const Impl*)_this)->at(idx);
	}
	static constexpr T& static_at(basic_container* _this, int idx) {
		return ((Impl*)_this)->at(idx);
	}
	static constexpr const T* static_cbegin(basic_container* _this) {
		return ((const Impl*)_this)->begin();
	}
	static constexpr T* static_begin(basic_container* _this) {
		return ((Impl*)_this)->begin();
	}
	static constexpr void static_reserve(basic_container* _this, int size) {
		((Impl*)_this)->reserve(size);
	}
	static constexpr int static_size(basic_container* _this) {
		return ((Impl*)_this)->size();
	}
};

template <typename T> class container_wrapper : public basic_container<T, container_wrapper<T>> {
public:
	void* _container;
	const T& (*_cat)(void*, int);
	T& (*_at)(void*, int);
	const T* (*_cbegin)(void*);
	T* (*_begin)(void*);
	void (*_reserve)(void*, int);
	int (*_size)(void*);

	template <container<T> C>
	constexpr container_wrapper(C& other)
		: _container(&other)
		, _cat((const T& (*)(void*, int)) & C::static_cat)
		, _at((T & (*)(void*, int)) & C::static_at)
		, _cbegin((const T* (*)(void*)) & C::static_cbegin)
		, _begin((T * (*)(void*)) & C::static_begin)
		, _reserve((void (*)(void*, int)) & C::static_reserve)
		, _size((int (*)(void*)) & C::static_size) {
	}

	constexpr container_wrapper(T* begin, T* end) {
		print("container_wrapper initialization with pointers not supported!\n");
		inf_wait();
	}
	const T& at(int idx) const {
		return _cat(_container, idx);
	}
	T& at(int idx) {
		return _at(_container, idx);
	}
	const T* begin() const {
		return _cbegin(_container);
	}
	T* begin() {
		return _begin(_container);
	}
	void reserve(int size) {
		return _reserve(_container, size);
	}
	int size() const {
		return _size(_container);
	}
};
