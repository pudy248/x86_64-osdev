#pragma once
#include <stl/allocator.hpp>
#include <stl/vector.hpp>
#include <utility>

template <typename T, allocator A = default_allocator_t<T>> class stack : protected vector<T, A> {
public:
	using vector<T, A>::vector;
	using vector<T, A>::size;
	using vector<T, A>::empty;
	using vector<T, A>::capacity;
	using vector<T, A>::clear;
	using vector<T, A>::reserve;

	constexpr void push(T&& elem) { this->append(elem); }
	template <std::same_as<std::remove_reference_t<T>> TF> constexpr void push(TF&& elem) {
		this->append(std::forward<TF>(elem));
	}
	template <typename... Args> constexpr void enqueue(Args&&... args) {
		this->append(std::forward<Args>(args)...);
	}
	constexpr T&& pop() {
		kassert(DEBUG_ONLY, WARNING, this->size(), "OOB access in stack.");
		T&& tmp = std::move(this->at(this->size() - 1));
		this->erase(this->size() - 1);
		return tmp;
	}
	constexpr T& peek() const {
		kassert(DEBUG_ONLY, WARNING, this->size(), "OOB access in stack.");
		return this->at(this->size() - 1);
	}
};