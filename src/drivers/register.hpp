#pragma once
#include <concepts>
#include <cstdint>
#include <stl/array.hpp>

template <std::integral Val>
struct base_reg {
	using type = Val;
	struct bitflag {
		uint16_t shift;
		consteval bitflag(uint16_t shift) : shift(shift) {}
		constexpr Val operator()(Val value) const { return (value & Val(1)) << shift; }
		constexpr Val extract(Val value) const { return (value >> shift) & Val(1); }
		constexpr operator Val() const { return Val(1) << shift; }
	};
	struct bitmask {
		Val mask;
		uint16_t shift;
		consteval bitmask(uint16_t start, uint16_t width) : mask(((Val(1) << width) - Val(1)) << start), shift(start) {}
		constexpr Val operator()(Val value) const { return (value << shift) & mask; }
		constexpr Val extract(Val value) const { return (value & mask) >> shift; }
		constexpr operator Val() const { return mask; }
	};
	struct bitmask_proj {
		Val mask;
		uint16_t shift;
		int16_t sub;
		uint16_t div;
		consteval bitmask_proj(uint16_t start, uint16_t width, int16_t sub, uint16_t div)
			: mask(((Val(1) << width) - Val(1)) << start), shift(start), sub(sub), div(div) {}
		constexpr Val operator()(Val value) const { return ((value / div - sub) << shift) & mask; }
		constexpr Val extract(Val value) const { return ((value & mask) >> shift) * div + sub; }
		constexpr operator Val() const { return mask; }
	};
};

template <typename T, typename Val>
concept is_bitmask_flag = std::same_as<T, typename base_reg<Val>::bitflag> ||
						  std::same_as<T, typename base_reg<Val>::bitmask> ||
						  std::same_as<T, typename base_reg<Val>::bitmask_proj>;
template <typename T, typename Val>
concept is_bitmask =
	std::same_as<T, typename base_reg<Val>::bitmask> || std::same_as<T, typename base_reg<Val>::bitmask_proj>;

template <std::integral Val, typename Addr, Val (*backing_read)(Addr), void (*backing_write)(Addr, Val), typename CRTP>
struct mmio_reg_d : base_reg<Val> {
	using this_type = CRTP;
	using addr_t = Addr;
	static constexpr auto reg_read = backing_read;
	static constexpr auto reg_write = backing_write;

	Addr addr;
	Val value;

	constexpr mmio_reg_d(Addr addr) : addr(addr), value(reg_read(addr)) {}

	template <auto Mask>
		requires is_bitmask_flag<decltype(Mask), Val>
	struct bitmask_value {
		mmio_reg_d& reg;
		constexpr bitmask_value(mmio_reg_d& r) : reg(r) {}
		constexpr operator decltype(Mask)() const { return Mask; }
		constexpr operator Val() const { return Mask.extract(reg.value); }
		constexpr void operator=(Val val) {
			if constexpr (std::is_same_v<decltype(Mask), typename base_reg<Val>::bitflag>)
				reg.value = (reg.value & ~Val(Mask)) | ((val & 1) << Mask.shift);
			else if constexpr (std::is_same_v<decltype(Mask), typename base_reg<Val>::bitmask>)
				reg.value = (reg.value & ~Val(Mask)) | ((val << Mask.shift) & Val(Mask));
			else if constexpr (std::is_same_v<decltype(Mask), typename base_reg<Val>::bitmask_proj>)
				reg.value = (reg.value & ~Val(Mask)) | (((val / Mask.div - Mask.sub) << Mask.shift) & Val(Mask));
			reg_write(reg.addr, reg.value);
		}
	};

	constexpr operator Val() const { return value; }
	constexpr void operator=(Val val) {
		value = val;
		reg_write(addr, value);
	}
	constexpr void write(is_bitmask<Val> auto mask, Val val) {
		if constexpr (std::is_same_v<decltype(mask), typename base_reg<Val>::bitmask>)
			value = (value & ~Val(mask)) | ((val << mask.shift) & Val(mask));
		else if constexpr (std::is_same_v<decltype(mask), typename base_reg<Val>::bitmask_proj>)
			value = (value & ~Val(mask)) | (((val / mask.div - mask.sub) << mask.shift) & Val(mask));
		reg_write(addr, value);
	}
	constexpr void set(base_reg<Val>::bitflag mask) {
		value |= Val(mask);
		reg_write(addr, value);
	}
	constexpr void clear(base_reg<Val>::bitflag mask) {
		value &= ~Val(mask);
		reg_write(addr, value);
	}
};

template <std::integral Val, typename Addr, Val (*backing_read)(Addr), void (*backing_write)(Addr, Val), typename CRTP>
struct mmio_reg_s : base_reg<Val> {
	using this_type = CRTP;
	using addr_t = Addr;
	static constexpr auto reg_read = backing_read;
	static constexpr auto reg_write = backing_write;

	Val value;

	constexpr mmio_reg_s() : value(reg_read(CRTP::offset)) {}

	template <auto Mask>
		requires is_bitmask_flag<decltype(Mask), Val>
	struct bitmask_value {
		mmio_reg_s& reg;
		constexpr bitmask_value(mmio_reg_s& r) : reg(r) {}
		constexpr operator decltype(Mask)() const { return Mask; }
		constexpr operator Val() const { return Mask.extract(reg.value); }
		constexpr void operator=(Val val) {
			if constexpr (std::is_same_v<decltype(Mask), typename base_reg<Val>::bitflag>)
				reg.value = (reg.value & ~Val(Mask)) | ((val & 1) << Mask.shift);
			else if constexpr (std::is_same_v<decltype(Mask), typename base_reg<Val>::bitmask>)
				reg.value = (reg.value & ~Val(Mask)) | ((val << Mask.shift) & Val(Mask));
			else if constexpr (std::is_same_v<decltype(Mask), typename base_reg<Val>::bitmask_proj>)
				reg.value = (reg.value & ~Val(Mask)) | (((val / Mask.div - Mask.sub) << Mask.shift) & Val(Mask));
			reg_write(CRTP::offset, reg.value);
		}
	};

	constexpr operator Val() const { return value; }
	constexpr void operator=(Val val) {
		value = val;
		reg_write(CRTP::offset, value);
	}
	constexpr void write(is_bitmask<Val> auto mask, Val val) {
		if constexpr (std::is_same_v<decltype(mask), typename base_reg<Val>::bitmask>)
			value = (value & ~Val(mask)) | ((val << mask.shift) & Val(mask));
		else if constexpr (std::is_same_v<decltype(mask), typename base_reg<Val>::bitmask_proj>)
			value = (value & ~Val(mask)) | (((val / mask.div - mask.sub) << mask.shift) & Val(mask));
		reg_write(CRTP::offset, value);
	}
	constexpr void set(base_reg<Val>::bitflag mask) {
		value |= Val(mask);
		reg_write(CRTP::offset, value);
	}
	constexpr void clear(base_reg<Val>::bitflag mask) {
		value &= ~Val(mask);
		reg_write(CRTP::offset, value);
	}
};

template <std::integral Val, std::integral Backing = Val>
struct data_reg : base_reg<Val> {
	using this_type = data_reg<Val, Backing>;
	using type = Val;

	Backing& value;
	data_reg(Backing& v) : value(v) {}

	template <auto Mask>
		requires is_bitmask_flag<decltype(Mask), Val>
	struct bitmask_value {
		data_reg& reg;
		constexpr bitmask_value(data_reg& r) : reg(r) {}
		constexpr operator decltype(Mask)() const { return Mask; }
		constexpr operator Val() const { return Mask.extract(reg.value); }
		constexpr void operator=(Val val) {
			if constexpr (std::is_same_v<decltype(Mask), typename base_reg<Val>::bitflag>)
				reg.value = (reg.value & ~Val(Mask)) | ((val & 1) << Mask.shift);
			else if constexpr (std::is_same_v<decltype(Mask), typename base_reg<Val>::bitmask>)
				reg.value = (reg.value & ~Val(Mask)) | ((val << Mask.shift) & Val(Mask));
			else if constexpr (std::is_same_v<decltype(Mask), typename base_reg<Val>::bitmask_proj>)
				reg.value = (reg.value & ~Val(Mask)) | (((val / Mask.div - Mask.sub) << Mask.shift) & Val(Mask));
		}
	};

	constexpr operator Val() const { return value; }
	constexpr void operator=(Val val) { value = val; }
	constexpr void write(is_bitmask<Val> auto mask, Val val) {
		if constexpr (std::is_same_v<decltype(mask), typename base_reg<Val>::bitmask>)
			value = (value & ~Val(mask)) | ((val << mask.shift) & Val(mask));
		else if constexpr (std::is_same_v<decltype(mask), typename base_reg<Val>::bitmask_proj>)
			value = (value & ~Val(mask)) | (((val / mask.div - mask.sub) << mask.shift) & Val(mask));
	}
	constexpr void set(base_reg<Val>::bitflag mask) { value |= Val(mask); }
	constexpr void clear(base_reg<Val>::bitflag mask) { value &= ~Val(mask); }
};

template <typename Reg>
struct mmio_transaction {
	Reg reg;
	Reg::type value;
	constexpr mmio_transaction(Reg r) : reg(r), value(r.value) {}
	constexpr void write(is_bitmask<typename Reg::type> auto mask, Reg::type val) {
		if constexpr (std::is_same_v<decltype(mask), typename base_reg<typename Reg::type>::bitmask>)
			value = (value & ~typename Reg::type(mask)) | ((val << mask.shift) & typename Reg::type(mask));
		else if constexpr (std::is_same_v<decltype(mask), typename base_reg<typename Reg::type>::bitmask_proj>)
			value = (value & ~typename Reg::type(mask)) |
					(((val / mask.div - mask.sub) << mask.shift) & typename Reg::type(mask));
	}
	constexpr void set(base_reg<typename Reg::type>::bitflag mask) { value |= typename Reg::type(mask); }
	constexpr void clear(base_reg<typename Reg::type>::bitflag mask) { value &= ~typename Reg::type(mask); }

	constexpr void commit() { reg = value; }
};

#define flag_bitmask(name, start)                       \
	constexpr static this_type::bitflag name = {start}; \
	this_type::template bitmask_value<name> name##_v = {*this};
#define int_bitmask(name, start, width)                        \
	constexpr static this_type::bitmask name = {start, width}; \
	this_type::template bitmask_value<name> name##_v = {*this};
#define int_bitmask_proj(name, start, width, sub, div)                        \
	constexpr static this_type::bitmask_proj name = {start, width, sub, div}; \
	this_type::template bitmask_value<name> name##_v = {*this};
#define enum_bitmask(name, start, width, ...) \
	int_bitmask(name, start, width);          \
	enum name##_vals { __VA_ARGS__ }
