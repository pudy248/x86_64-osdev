#pragma once
#include <concepts>
#include <cstddef>
#include <iterator>
#include <kassert.hpp>
#include <stl/container.hpp>
#include <stl/iterator.hpp>
#include <type_traits>

template <typename C, typename T>
concept condition = requires(C comparator, T obj) {
	{ comparator(obj) } -> std::convertible_to<bool>;
};
template <typename C, typename T>
concept comparator = requires(C comparator, T lhs, T rhs) {
	{ comparator(lhs, rhs) } -> std::convertible_to<int>;
};

template <std::input_iterator I, std::sentinel_for<I> S = I> class view {
protected:
	I m_begin;
	S m_sentinel;

	constexpr static I from(const I& start, const idx_t index) {
		if constexpr (std::random_access_iterator<I>)
			return start + index;
		else {
			I iter = start;
			for (idx_t i = 0; i < index; ++i, ++iter);
			return iter;
		}
	}

public:
	using value_type = std::iter_value_t<I>;
	using T = value_type;
	using reference_type = std::iter_reference_t<I>;

	constexpr static bool Infinite = std::same_as<S, std::unreachable_sentinel_t>;

	constexpr view(const I& begin = I{}, const S& end = S{})
		: m_begin(begin)
		, m_sentinel(end) {};

	constexpr view(I& begin, S& end)
		: m_begin(begin)
		, m_sentinel(end) {};

	constexpr view(const I& begin, idx_t length)
		: m_begin(begin)
		, m_sentinel(begin + length) {};

	template <typename I2, typename S2>
	constexpr view(const view<I2, S2>& other)
		: m_begin(other.begin())
		, m_sentinel(other.end()) {}

	template <container C>
	constexpr view(C& c)
		: view(c.begin(), c.end()) {}
	template <container C>
	constexpr view(const C& c)
		: view(c.cbegin(), c.cend()) {}

	constexpr view subspan(idx_t start) const { return view(from(m_begin, start), m_sentinel); }
	constexpr view subspan(idx_t start, idx_t end) const {
		I new_begin = from(m_begin, start);
		I new_sentinel = from(new_begin, end - start);
		return view(new_begin, new_sentinel);
	}

	constexpr I begin() { return m_begin; }
	constexpr const I begin() const { return m_begin; }
	constexpr const I cbegin() const { return m_begin; }
	constexpr S end() { return m_sentinel; }
	constexpr const S end() const { return m_sentinel; }
	constexpr const S cend() const { return m_sentinel; }
	constexpr std::size_t size() const {
		if (Infinite) return -1;
		if constexpr (std::sized_sentinel_for<I, I>)
			return end() - begin();
		else {
			idx_t v = 0;
			for (I iter = m_begin; iter != m_sentinel; ++v, ++iter);
			return v;
		}
	}
	constexpr bool empty() const { return end() == begin(); }

	template <comparable_iter_R<I> R> constexpr idx_t find(const R& elem) const {
		I iter = begin();
		for (idx_t i = 0; iter != end(); ++i, ++iter)
			if (*iter == elem) return i;
		return -1;
	}
	template <comparable_iter_I<I> I2, typename S2> constexpr idx_t find_first(const view<I2, S2>& elems) const {
		if (view<I2, S2>::Infinite) return -1;
		idx_t index = -1;
		idx_t which = -1;
		I2 iter2 = elems.begin();
		for (idx_t i = 0; iter2 != elems.end(); ++i, ++iter2) {
			idx_t index2 = find(*iter2);
			if (index2 != -1 && (index2 < index || which == -1)) {
				index = index2;
				which = i;
			}
		}
		return index;
	}
	template <comparable_iter_R<I> R> constexpr idx_t count(const R& elem) const {
		I iter = begin();
		idx_t ctr = 0;
		for (idx_t i = 0; iter != end(); ++i, ++iter)
			if (*iter == elem) ++ctr;
		return ctr;
	}
	template <comparable_iter_I<I> I2, typename S2> constexpr idx_t count(const view<I2, S2>& elems) const {
		if (view<I2, S2>::Infinite) return 0;
		idx_t ctr = 0;
		I2 iter2 = elems.begin();
		for (idx_t i = 0; iter2 != elems.end(); ++i, ++iter2) ctr += count(*iter2);
		return ctr;
	}
	template <comparable_iter_R<I> R> constexpr bool contains(const R& elem) const { return find(elem) != -1; }
	template <comparable_iter_I<I> I2, typename S2> constexpr idx_t contains_which(const view<I2, S2>& elems) const {
		if (view<I2, S2>::Infinite) return -1;
		idx_t index = -1;
		idx_t which = -1;
		I2 iter2 = elems.begin();
		for (idx_t i = 0; iter2 != elems.end(); ++i, ++iter2) {
			idx_t index2 = find(*iter2);
			if (index2 != -1 && (index2 < index || which == -1)) {
				index = index2;
				which = i;
			}
		}
		return which;
	}
	template <comparable_iter_I<I> I2, typename S2> constexpr idx_t find_span(const view<I2, S2>& elems) const {
		if (view<I2, S2>::Infinite) return -1;
		I iter = begin();
		for (idx_t i = 0; iter != end(); ++i, ++iter)
			if (span(iter, end()).starts_with(elems)) return i;
		return -1;
	}
	template <comparable_iter_I<I> I2, typename S2> constexpr bool contains_span(const view<I2, S2>& elems) const {
		return find_span(elems) != -1;
	}
	template <comparable_iter_R<I> R> constexpr bool starts_with(const R& elem) const {
		return begin() != end() && elem == *begin();
	}
	template <comparable_iter_R<I> R> constexpr bool ends_with(const R& elem) const {
		if (Infinite) return false;
		if constexpr (std::bidirectional_iterator<I>)
			return begin() != end() && *(--end()) == elem;
		else
			return begin() != end() && *from(size() - 1) == elem;
	}
	template <comparable_iter_I<I> I2, typename S2> constexpr bool starts_with(const view<I2, S2>& other) const {
		if (view<I2, S2>::Infinite) return false;
		I iter1 = begin();
		I2 iter2 = other.begin();
		while (1) {
			if (iter2 == other.end()) return true;
			if (iter1 == end() || *iter1 != *iter2) return false;
			++iter1;
			++iter2;
		}
		return true;
	}
	template <comparable_iter_I<I> I2, typename S2>
		requires requires {
			std::bidirectional_iterator<I>;
			std::bidirectional_iterator<I2>;
		}
	constexpr bool ends_with(const view<I2, S2>& other) const {
		if (view<I2, S2>::Infinite) return false;
		if constexpr (std::bidirectional_iterator<I> && !Infinite) {
			I iter1 = end();
			I2 iter2 = other.end();
			while (iter2 != other.begin()) {
				if (iter1 == begin()) return false;
				--iter1;
				--iter2;
				if (*iter1 != *iter2) return false;
			}
			return true;
		} else {
			if (size() < other.size()) return false;
			return subspan(size() - other.size()).starts_with(other);
		}
	}
	template <comparable_iter_I<I> I2, typename S2> constexpr bool equals(const view<I2, S2>& other) const {
		if (Infinite || view<I2, S2>::Infinite) return false;
		I iter1 = begin();
		I2 iter2 = other.begin();
		while (iter1 != end()) {
			if (iter2 == other.end() || *iter1 != *iter2) return false;
			++iter1;
			++iter2;
		}
		return iter2 == other.end();
	}
	template <comparable_iter_I<I> I2, typename S2> constexpr bool operator==(const view<I2, S2>& other) const {
		return equals(other);
	}

	template <typename Derived> constexpr auto& operator[](this Derived self, idx_t index) {
		kassert(DEBUG_ONLY, WARNING, Infinite || index < (idx_t)self.size(), "Out of bounds access to view.");
		return *from(self.begin(), index);
	}
	template <convertible_iter_I<I> I2, typename S2>
		requires(!view<I2, S2>::Infinite)
	constexpr void blit(const view<I2, S2>& other, idx_t index = 0) {
		I iter1 = from(begin(), index);
		I2 iter2 = other.begin();
		for (; iter1 != end() && iter2 != other.end(); ++iter1, ++iter2) *iter1 = *iter2;
	}
	template <convertible_iter_I<I> I2, typename S2>
		requires requires {
			requires !Infinite;
			requires std::forward_iterator<I2>;
		}
	constexpr void fill(const view<I2, S2>& other) {
		I iter1 = begin();
		I2 iter2 = other.begin();
		for (; iter1 != end(); ++iter1, ++iter2) {
			if (iter2 == other.end()) iter2 = other.begin();
			*iter1 = *iter2;
		}
	}
	template <std::convertible_to<T> R> constexpr void fill(R&& val) {
		if constexpr (std::same_as<std::make_unsigned_t<std::remove_cv_t<R>>, uint8_t>) {
			memset(begin(), val, size());
		} else {
			for (I i = begin(); i != end(); ++i) *i = std::forward<R>(val);
		}
	}

	template <typename F, typename R> R fold(const F& f, const R& r) {
		R tmp = r;
		for (auto& elem : *this) { tmp = f(tmp, elem); }
		return tmp;
	}

	template <typename T2>
		requires(!Infinite && (sizeof(T) == 1 || sizeof(T2) == 1)) // Type aliasing required to not be UB for now
	constexpr view<T2*> reinterpret_as() const {
		return view<T2*>((T2*)begin(), (T2*)end());
	}
};

template <typename T> class span : public view<T*, T*> {
public:
	using value_type = T;
	using view<T*, T*>::view;
	constexpr span(std::initializer_list<T> list)
		: span(list.begin(), list.end()) {}
};
template <typename T> class span<const T> : public view<const T*, const T*> {
public:
	using value_type = const T;
	using view<const T*, const T*>::view;
	constexpr span(std::initializer_list<T> list)
		: span(list.begin(), list.end()) {}
};
template <typename T> class ispan : public view<T*, std::unreachable_sentinel_t> {
public:
	using value_type = T;
	using view<T*, std::unreachable_sentinel_t>::view;
};
template <typename T> class ispan<const T> : public view<const T*, std::unreachable_sentinel_t> {
public:
	using value_type = const T;
	using view<const T*, std::unreachable_sentinel_t>::view;
};

template <container C> view(C&) -> view<container_iterator_t<C>>;
template <container C> view(const C&) -> view<container_const_iterator_t<C>>;
template <typename T> view(T*) -> view<T*, std::unreachable_sentinel_t>;

template <typename I> span(const I&, const I&) -> span<decltype(*std::declval<I>())>;
template <container C> span(C&) -> span<std::remove_reference_t<decltype(*std::declval<container_iterator_t<C>>())>>;
template <container C>
span(const C&) -> span<std::remove_reference_t<decltype(*std::declval<container_const_iterator_t<C>>())>>;
template <typename T> span(T*, T*) -> span<T>;
template <typename T> span(T*, idx_t) -> span<T>;
template <typename T> ispan(T*) -> ispan<T>;