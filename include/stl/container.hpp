#pragma once
#include <concepts>
#include <kassert.hpp>
#include <kstdlib.hpp>
#include <type_traits>

namespace __container_sfinae {
template <typename _C> struct __container_owning_value {
	bool value = false;
};
template <typename _C>
	requires requires { _C::is_owning; }
struct __container_owning_value<_C> {
	bool value = _C::is_owning;
};

template <typename _C> struct __container_reference_type {
	using type = _C::value_type&;
};
template <typename _C>
	requires requires { typename _C::reference_type; }
struct __container_reference_type<_C> {
	using type = _C::reference_type;
};

template <typename _C> struct __container_size_type {
	using type = std::size_t;
};
template <typename _C>
	requires requires { typename _C::size_type; }
struct __container_size_type<_C> {
	using type = _C::size_type;
};

template <typename _C> struct __container_difference_type {
	using type = std::ptrdiff_t;
};
template <typename _C>
	requires requires { typename _C::difference_type; }
struct __container_difference_type<_C> {
	using type = _C::difference_type;
};

template <typename _C> struct __container_iterator_type {
	using type = _C::value_type*;
};
template <typename _C>
	requires requires { typename _C::iterator_type; }
struct __container_iterator_type<_C> {
	using type = _C::iterator_type;
};

template <typename _C> struct __container_const_iterator_type {
	using type = const _C::value_type*;
};
template <typename _C>
	requires requires { typename _C::const_iterator_type; }
struct __container_const_iterator_type<_C> {
	using type = _C::const_iterator_type;
};
}

template <typename C>
	requires requires { typename C::value_type; }
struct container_traits {
	static constexpr bool is_owning = __container_sfinae::__container_owning_value<C>::value;
	using reference_type = __container_sfinae::__container_reference_type<C>::type;
	using size_type = __container_sfinae::__container_size_type<C>::type;
	using difference_type = __container_sfinae::__container_difference_type<C>::type;
	using iterator_type = __container_sfinae::__container_iterator_type<C>::type;
	using const_iterator_type = __container_sfinae::__container_const_iterator_type<C>::type;
};

template <typename C> using container_value_t = C::value_type;
template <typename C> using container_reference_t = container_traits<C>::reference_type;
template <typename C> using container_size_t = container_traits<C>::size_type;
template <typename C> using container_difference_t = container_traits<C>::difference_type;
template <typename C> using container_iterator_t = container_traits<C>::iterator_type;
template <typename C> using container_const_iterator_t = container_traits<C>::const_iterator_type;

template <typename C>
concept container = requires(C c) {
	typename C::value_type;
	requires std::same_as<decltype(c.begin()), container_iterator_t<C>>;
	requires std::same_as<decltype(c.end()), container_iterator_t<C>>;
};

template <typename C, typename T>
concept container_of = requires(C c) {
	requires container<C>;
	requires std::convertible_to<container_value_t<C>, T>;
};

template <template <typename...> typename C>
concept container_template = container<C<int>>;

template <typename T> class container_wrapper {
public:
	using value_type = T;

	void* _container;
	T& (*_at)(void*, int);
	const T& (*_cat)(void*, int);

	T* (*_begin)(void*);
	const T* (*_cbegin)(void*);
	T* (*_end)(void*);
	const T* (*_cend)(void*);

	void (*_reserve)(void*, int);
	int (*_size)(void*);

	template <container_of<T> C>
	constexpr container_wrapper(C& other)
		: _container(&other)
		, _at((T & (*)(void*, int)) & C::static_at)
		, _cat((const T& (*)(void*, int))&C::static_cat)
		, _begin((T * (*)(void*)) & C::static_begin)
		, _cbegin((const T* (*)(void*))&C::static_cbegin)
		, _end((T * (*)(void*)) & C::static_end)
		, _cend((const T* (*)(void*))&C::static_cend)
		, _reserve((void (*)(void*, int))&C::static_reserve)
		, _size((int (*)(void*))&C::static_size) {}

	constexpr container_wrapper(T*, T*) {
		kassert(ALWAYS_ACTIVE, ERROR, false,
				"container_wrapper initialization with pointers not supported!");
	}
	T& at(int idx) { return _at(_container, idx); }
	const T& at(int idx) const { return _cat(_container, idx); }
	T* begin() { return _begin(_container); }
	const T* begin() const { return _cbegin(_container); }
	const T* cbegin() { return _cbegin(_container); }
	T* end() { return _end(_container); }
	const T* end() const { return _cend(_container); }
	const T* cend() { return _cend(_container); }
	void reserve(int size) { return _reserve(_container, size); }
	int size() const { return _size(_container); }
};