#pragma once
#include <kassert.hpp>
#include <stl/allocator.hpp>
#include <stl/vector.hpp>
#include <utility>

template <typename T, allocator A = default_allocator>
class queue : protected vector<T, A> {
    protected:
    // std::size_t head = m_size
    std::size_t tail = 0;

    constexpr std::size_t inc_head() {
        if (size() == capacity() - 1) reserve(capacity() * this->resize_ratio);
        std::size_t h = this->m_size;
        this->m_size = (this->m_size + 1) % this->capacity();
        return h;
    }
    constexpr std::size_t inc_tail() {
        kassert(DEBUG_ONLY, WARNING, this->m_size != tail, "OOB access in queue.");
        std::size_t t = tail;
        tail = (tail + 1) % this->capacity();
        return t;
    }
public:
    using vector<T, A>::vector;
    using vector<T, A>::capacity;
    using vector<T, A>::clear;

    constexpr std::size_t size() const volatile {
        return (this->m_size - tail + capacity()) % capacity();
    }
    constexpr void reserve(std::size_t size) {
        std::size_t old_capacity = this->capacity();
        std::size_t trailing_elems = this->capacity() - tail;
        static_cast<vector<T, A>>(*this).reserve(size);
        for (std::size_t n = 0; n < trailing_elems; n++)
            this->m_at(this->capacity() - n - 1) = std::move(this->m_at(old_capacity - n - 1));
        tail = this->capacity() - trailing_elems;
    }

    constexpr void enqueue(T& elem) { this->m_at(inc_head()) = std::forward<T>(elem); }
    constexpr void enqueue(T&& elem) { this->m_at(inc_head()) = std::forward<T>(elem); }
    constexpr T&& dequeue() {
        T&& tmp = std::move(this->m_at(inc_tail()));
        return tmp;
    }
    constexpr T& peek() {
        kassert(DEBUG_ONLY, WARNING, this->m_size != tail, "OOB access in queue.");
        return this->m_at(this->tail);
    }
};