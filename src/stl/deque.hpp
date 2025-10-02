#pragma once
#include <cstddef>
#include <kassert.hpp>
#include <kstddef.hpp>
#include <stl/allocator.hpp>
#include <stl/queue.hpp>
#include <stl/vector.hpp>
#include <utility>

template <typename T, allocator A = default_allocator<T>>
class deque : protected vector<T, A> {
protected:
	std::size_t ibegin = 0;
	std::size_t iend = 0;

	constexpr std::size_t inc_begin() {
		if (size() + 1 >= capacity())
			reserve(max(1u, capacity()) * vector<T, A>::resize_ratio);
		std::size_t h = ibegin;
		ibegin = (ibegin + 1) % this->capacity();
		return h;
	}
	constexpr std::size_t dec_begin() {
		if (ibegin == 0)
			ibegin = this->capacity() - 1;
		else
			ibegin -= 1;
		return ibegin;
	}
	constexpr std::size_t inc_end() {
		std::size_t t = iend;
		iend = (iend + 1) % this->capacity();
		return t;
	}
	constexpr std::size_t dec_end() {
		kassert(DEBUG_ONLY, WARNING, ibegin != iend, "OOB access in queue.");
		std::size_t t = iend;
		iend = (iend + 1) % this->capacity();
		return t;
	}

public:
	friend class vector<T, A>;

	using vector<T, A>::vector;
	using vector<T, A>::capacity;

	constexpr queue_iterator<T> begin() { return {vector<T, A>::m_arr, vector<T, A>::m_size, ibegin}; }
	constexpr const queue_iterator<T> begin() const { return {vector<T, A>::m_arr, vector<T, A>::m_size, ibegin}; }
	constexpr queue_iterator<T> end() { return {vector<T, A>::m_arr, vector<T, A>::m_size, iend}; }
	constexpr const queue_iterator<T> end() const { return {vector<T, A>::m_arr, vector<T, A>::m_size, iend}; }

	constexpr std::size_t size() const {
		if (capacity())
			return (ibegin - iend + capacity()) % capacity();
		else
			return 0;
	}
	constexpr bool empty() const { return !size(); }
	constexpr void reserve(std::size_t size) {
		std::size_t old_capacity = this->capacity();
		if (ibegin < iend) {
			std::size_t trailing_elems = this->capacity() - iend;
			((vector<T, A>*)this)->resize(size);
			for (std::size_t n = 0; n < trailing_elems; n++)
				(*this)[this->capacity() - n - 1] = std::move((*this)[old_capacity - n - 1]);
			iend = this->capacity() - trailing_elems;
		} else
			((vector<T, A>*)this)->resize(size);
	}
	constexpr void clear() {
		((vector<T, A>*)this)->clear();
		ibegin = 0;
		iend = 0;
	}

	template <typename TF>
	constexpr void push_front(TF&& elem) {
		(*this)[dec_begin()] = std::forward<TF>(elem);
	}
	template <typename... Args>
	constexpr void push_front(Args&&... args) {
		(*this)[dec_begin()] = T(std::forward<Args>(args)...);
	}
	template <typename TF>
	constexpr void push_back(TF&& elem) {
		(*this)[inc_end()] = std::forward<TF>(elem);
	}
	template <typename... Args>
	constexpr void push_back(Args&&... args) {
		(*this)[inc_end()] = T(std::forward<Args>(args)...);
	}
	constexpr T pop_front() { return std::move((*this)[inc_begin()]); }
	constexpr T pop_back() { return std::move((*this)[dec_end()]); }
	constexpr void erase(std::size_t index) { (*this)[index] = T(); }
};