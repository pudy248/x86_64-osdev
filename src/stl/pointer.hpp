#pragma once
#include "stl/iterator/iterator_interface.hpp"
#include <bit>
#include <compare>
#include <concepts>
#include <cstddef>
#include <cstdint>
#include <iterator>
#include <kassert.hpp>
#include <stl/iterator.hpp>
#include <type_traits>
#include <utility>

namespace {
struct vis_tag {};
template <typename T, typename... Rs>
concept pack_contains = (std::derived_from<Rs, T> || ...);
}
void kfree(void* ptr);

//struct sized { // Has an associated data size
//	std::size_t size = 0;
//	constexpr sized() {}
//	constexpr sized(std::size_t sz)
//		: size(sz) {}
//};

struct safe {}; // Illegal to dereference if null
struct nonnull {}; // Illegal to assign null
struct owning {}; // Illegal to copy to another owning pointer or from a non-owning pointer, auto-moves when possible
struct autofree : owning {}; // Auto-frees on destruction
struct nofree : owning {}; // Illegal to destroy or free if not null
struct nocopy : owning {}; // Illegal to copy at all
struct shared {}; // Reference-counted, frees when all references lost
struct integer {}; // Can convert to and from uintptr_t
struct type_cast {}; // Can convert to other pointer types
struct reinterpret : integer, type_cast {};

template <typename T, typename... Traits>
struct [[clang::trivial_abi]] pointer : public contiguous_iterator_interface<pointer<T, Traits...>> {
	constexpr static bool is_safe = pack_contains<safe, Traits...>;
	constexpr static bool is_nonnull = pack_contains<nonnull, Traits...>;
	constexpr static bool is_owning = pack_contains<owning, Traits...>;
	constexpr static bool is_autofree = pack_contains<nofree, Traits...>;
	constexpr static bool is_nofree = pack_contains<nofree, Traits...>;
	constexpr static bool is_nocopy = pack_contains<nocopy, Traits...>;
	constexpr static bool is_shared = pack_contains<shared, Traits...>;
	constexpr static bool is_integer = pack_contains<integer, Traits...>;
	constexpr static bool is_type_cast = pack_contains<type_cast, Traits...>;
	constexpr static bool is_reinterpret = pack_contains<reinterpret, Traits...>;
	//constexpr static bool is_sized = pack_contains<sized, Traits...>;

	using type = T;

	//static_assert(!(is_sized && is_integer), "Integer-convertible pointers cannot be sized.");

	T* ptr = nullptr;
	constexpr pointer()
		requires(!is_nonnull)
	{}
	constexpr pointer(T*& p)
		requires(!is_nocopy) // && !is_sized
		: pointer(p, vis_tag{}) {
		if constexpr (is_owning)
			p = nullptr;
	}
	constexpr pointer(T* const& p)
		requires(!is_nocopy) // && !is_sized
		: pointer(p, vis_tag{}) {}
	constexpr pointer(T* const& p, vis_tag) : ptr(p) {
		if constexpr (is_nonnull)
			kassert(ALWAYS_ACTIVE, ERROR, ptr, "Constructed non-null pointer with nullptr.");
	}
	static constexpr pointer make_nocopy(T* p)
		requires(is_nocopy) // && !is_sized
	{
		return pointer(p, vis_tag{});
	}
	template <typename R>
	static constexpr pointer make_nocopy(R* p)
		requires(is_nocopy && is_type_cast) // && !is_sized
	{
		return pointer((T*)p, vis_tag{});
	}
	//constexpr pointer(T*& p, std::size_t sz)
	//	requires(!is_unique) // && is_sized
	//	: pointer(p, sz, vis_tag{}) {
	//	if constexpr (is_owning) { p = nullptr; }
	//}
	//constexpr pointer(T* const& p, std::size_t sz)
	//	requires(!is_unique) // && is_sized
	//	: pointer(p, sz, vis_tag{}) {}
	//constexpr pointer(T* const& p, std::size_t sz, vis_tag)
	//	: sized(sz)
	//	, ptr(p) {
	//	if constexpr (is_nonnull) kassert(ALWAYS_ACTIVE, ERROR, ptr, "Constructed non-null pointer with nullptr.");
	//}
	//static constexpr pointer make_unique(T* p, std::size_t sz)
	//	requires(is_unique) // && is_sized
	//{
	//	pointer result(p, sz, vis_tag{});
	//	return result;
	//}

	constexpr pointer(const pointer& other)
		requires(!is_owning)
	{
		// Redundant?
		//if constexpr (is_nonnull)
		//	kassert(ALWAYS_ACTIVE, ERROR, other.ptr, "Constructed non-null pointer with nullptr.");
		this->ptr = other.ptr;
		//if constexpr (is_sized) this->size = other->size;
	}
	constexpr pointer(pointer&& other) {
		//if constexpr (is_nonnull)
		//	kassert(ALWAYS_ACTIVE, ERROR, other.ptr, "Constructed non-null pointer with nullptr.");
		this->ptr = other.ptr;
		//if constexpr (is_sized) this->size = other.size;
		if constexpr (is_owning) {
			other.ptr = 0;
			//if constexpr (is_sized) other.size = 0;
		}
	}
	constexpr pointer& operator=(const pointer& other)
		requires(!is_owning)
	{
		this->~pointer();
		new (this) pointer(other);
		return *this;
	}
	constexpr pointer& operator=(pointer&& other) {
		this->~pointer();
		new (this) pointer(std::forward<pointer>(other));
		return *this;
	}

	template <typename... OtherTraits>
	constexpr pointer(const pointer<T, OtherTraits...>& other)
		requires(!is_owning &&
				 !pointer<T, OtherTraits...>::is_nocopy) // && (is_sized == pointer<T, OtherTraits...>::is_sized)
	{
		if constexpr (is_nonnull)
			kassert(ALWAYS_ACTIVE, ERROR, other.ptr, "Constructed non-null pointer with nullptr.");
		this->ptr = other.ptr;
		//if constexpr (is_sized) this->size = other->size;
	}
	template <typename... OtherTraits>
	constexpr pointer(pointer<T, OtherTraits...>&& other)
		requires(!(!is_owning &&
				   pointer<T, OtherTraits...>::is_owning)) // && (is_sized == pointer<T, OtherTraits...>::is_sized)
	{
		if constexpr (is_nonnull)
			kassert(ALWAYS_ACTIVE, ERROR, other.ptr, "Constructed non-null pointer with nullptr.");
		this->ptr = other.ptr;
		//if constexpr (is_sized) this->size = other.size;
		if constexpr ((is_owning && pointer<T, OtherTraits...>::is_owning) ||
					  (is_nocopy || pointer<T, OtherTraits...>::is_nocopy)) {
			other.ptr = 0;
			//if constexpr (pointer<T, OtherTraits...>::is_sized) other.size = 0;
		}
	}
	template <typename... OtherTraits>
	constexpr pointer& operator=(const pointer<T, OtherTraits...>& other)
		requires(!is_owning &&
				 !pointer<T, OtherTraits...>::is_nocopy) // && (is_sized == pointer<T, OtherTraits...>::is_sized)
	{
		this->~pointer();
		new (this) pointer(other);
		return *this;
	}
	template <typename... OtherTraits>
	constexpr pointer& operator=(pointer<T, OtherTraits...>&& other)
		requires(!(!is_owning &&
				   pointer<T, OtherTraits...>::is_owning)) // && (is_sized == pointer<T, OtherTraits...>::is_sized)
	{
		this->~pointer();
		new (this) pointer(std::forward<pointer<T, OtherTraits...>>(other));
		return *this;
	}

	template <typename R>
	constexpr pointer(R*& p)
		requires(!is_nocopy && is_type_cast)
		: pointer((T*)(p), vis_tag{}) {
		if constexpr (is_owning)
			p = nullptr;
	}
	template <typename R>
	constexpr pointer(R* const& p)
		requires(!is_nocopy && is_type_cast)
		: pointer((T*)(p), vis_tag{}) {}

	template <typename R, typename... OtherTraits>
	constexpr pointer(const pointer<R, OtherTraits...>& other)
		requires(!is_owning &&
				 !pointer<R, OtherTraits...>::is_nocopy && // (is_sized == pointer<R, OtherTraits...>::is_sized) &&
				 (is_type_cast || pointer<R, OtherTraits...>::is_type_cast))
	{
		if constexpr (is_nonnull)
			kassert(ALWAYS_ACTIVE, ERROR, other.ptr, "Constructed non-null pointer with nullptr.");
		this->ptr = reinterpret_cast<T*>(other.ptr);
		// if constexpr (is_sized) this->size = other.size;
	}
	template <typename R, typename... OtherTraits>
	constexpr pointer(pointer<R, OtherTraits...>&& other)
		requires(!(!is_owning &&
					 pointer<R, OtherTraits...>::is_owning) && // (is_sized == pointer<R, OtherTraits...>::is_sized) &&
				 (is_type_cast || pointer<R, OtherTraits...>::is_type_cast))
	{
		if constexpr (is_nonnull)
			kassert(ALWAYS_ACTIVE, ERROR, other.ptr, "Constructed non-null pointer with nullptr.");
		this->ptr = reinterpret_cast<T*>(other.ptr);
		//if constexpr (is_sized) this->size = other.size;
		if constexpr (is_owning) {
			other.ptr = 0;
			//if constexpr (is_sized) other.size = 0;
		}
	}

	constexpr pointer(const uintptr_t& other)
		requires(!is_nocopy && is_integer)
	{
		if constexpr (is_nonnull)
			kassert(ALWAYS_ACTIVE, ERROR, other, "Constructed non-null pointer with nullptr.");
		this->ptr = std::bit_cast<T*>(other);
	}
	constexpr explicit operator uintptr_t() const
		requires(!is_nocopy && is_integer)
	{
		return std::bit_cast<uintptr_t>(ptr);
	}

	constexpr T* release()
		requires(is_nocopy)
	{
		T* tmp = ptr;
		ptr = nullptr;
		return tmp;
	}

	constexpr ~pointer() {
		if constexpr (is_nofree)
			kassert(ALWAYS_ACTIVE, ERROR, !ptr, "Destroyed a no-free pointer.");
		if constexpr (is_owning) {
			kfree(ptr);
			ptr = 0;
		}
		ptr = 0;
	}

	constexpr T* operator()() const {
		if constexpr (is_safe)
			kassert(ALWAYS_ACTIVE, ERROR, ptr, "Attempted to dereference safe pointer.");
		return ptr;
	}
	template <typename R>
		requires(is_type_cast)
	constexpr operator R*() const {
		return (R*)(*this)();
	}
	constexpr operator T*() const { return (*this)(); }
	constexpr T* operator->() const { return (*this)(); }
	template <typename R = T>
		requires(!std::is_void_v<R>)
	constexpr R& operator*() const {
		return *(*this)();
	}
	constexpr pointer& operator+=(const int64_t& other) {
		ptr += other;
		return *this;
	}
	constexpr bool operator==(const pointer& other) const { return ptr == other.ptr; }
	constexpr std::strong_ordering operator<=>(const pointer& other) const { return ptr <=> other.ptr; }
	template <typename R, typename... OtherTraits>
	constexpr std::strong_ordering operator<=>(const pointer<R, OtherTraits...>& other) const {
		return ptr <=> other.ptr;
	}
};

template <typename T, typename... Traits>
struct std::iterator_traits<pointer<T, Traits...>> {
	using value_type = T;
	using difference_type = std::ptrdiff_t;
	using iterator_category = std::contiguous_iterator_tag;
	using pointer = T*;
	using reference = void;
};
template <typename T, typename... Traits>
	requires(!std::is_void_v<T>)
struct std::iterator_traits<pointer<T, Traits...>> {
	using value_type = T;
	using difference_type = std::ptrdiff_t;
	using iterator_category = std::contiguous_iterator_tag;
	using pointer = T*;
	using reference = T&;
};