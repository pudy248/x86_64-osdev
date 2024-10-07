#pragma once
#include <cstddef>
#include <kassert.hpp>
#include <kstddef.hpp>
#include <stl/allocator.hpp>
#include <stl/vector.hpp>
#include <type_traits>
#include <utility>

template <typename T, allocator A = default_allocator_t<T>> class queue : protected vector<T, A> {
protected:
	static constexpr std::size_t resize_ratio = 2;
	std::size_t head = 0;
	std::size_t tail = 0;

	constexpr std::size_t inc_head() {
		if (size() + 1 >= capacity()) reserve(max(1u, capacity()) * resize_ratio);
		std::size_t h = head;
		head = (head + 1) % this->capacity();
		return h;
	}
	constexpr std::size_t inc_tail() {
		kassert(DEBUG_ONLY, WARNING, head != tail, "OOB access in queue.");
		std::size_t t = tail;
		tail = (tail + 1) % this->capacity();
		return t;
	}

public:
	friend class vector<T, A>;

	using vector<T, A>::vector;
	using vector<T, A>::capacity;

	constexpr std::size_t size() const {
		if (capacity())
			return (head - tail + capacity()) % capacity();
		else
			return 0;
	}
	constexpr bool empty() const { return !size(); }
	constexpr void reserve(std::size_t size) {
		std::size_t old_capacity = this->capacity();
		if (head < tail) {
			std::size_t trailing_elems = this->capacity() - tail;
			((vector<T, A>*)this)->resize(size);
			for (std::size_t n = 0; n < trailing_elems; n++)
				(*this)[this->capacity() - n - 1] = std::move((*this)[old_capacity - n - 1]);
			tail = this->capacity() - trailing_elems;
		} else
			((vector<T, A>*)this)->resize(size);
	}
	constexpr void clear() {
		((vector<T, A>*)this)->clear();
		head = 0;
		tail = 0;
	}

	constexpr void enqueue(T&& elem) { (*this)[inc_head()] = elem; }
	template <std::same_as<std::remove_reference_t<T>> TF> constexpr void enqueue(TF&& elem) {
		(*this)[inc_head()] = std::forward<TF>(elem);
	}
	template <typename... Args> constexpr void enqueue(Args&&... args) {
		(*this)[inc_head()] = T(std::forward<Args>(args)...);
	}
	constexpr T&& dequeue() { return std::move((*this)[inc_tail()]); }
	constexpr T& peek() {
		kassert(DEBUG_ONLY, WARNING, head != tail, "OOB access in queue.");
		return (*this)[tail];
	}
};