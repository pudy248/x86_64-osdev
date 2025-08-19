#pragma once
#include <iterator>
#include <type_traits>

namespace impl {
template <typename I>
using fully_decayed = std::decay_t<std::remove_reference_t<I>>;
template <typename T>
concept not_array = !std::is_array_v<T>;
template <typename I, typename S>
concept bounded = std::sentinel_for<fully_decayed<S>, fully_decayed<I>>;
template <typename O, typename T>
concept output = not_array<O> && std::output_iterator<fully_decayed<O>, T>;
template <typename O, typename I>
concept output_for = output<O, std::iter_value_t<fully_decayed<I>>>;
template <typename I>
concept input = not_array<I> && std::input_iterator<fully_decayed<I>>;
template <typename I>
concept forward = not_array<I> && std::forward_iterator<fully_decayed<I>>;
template <typename I>
concept bidirectional = std::bidirectional_iterator<fully_decayed<I>>;
template <typename I, typename S>
concept bounded_input = input<I> && bounded<I, S>;
template <typename I, typename S>
concept bounded_forward = forward<I> && bounded<I, S>;
template <typename O, typename I>
concept output_with_input = input<I> && output_for<O, I>;
template <typename O, typename I>
concept output_with_forward = forward<I> && output_for<O, I>;
template <typename O, typename S, typename I>
concept bounded_output_with_input = output_with_input<O, I> && bounded<O, S>;
template <typename O, typename S, typename I>
concept bounded_output_with_forward = output_with_forward<O, I> && bounded<O, S>;
template <typename O, typename I, typename S>
concept output_with_bounded_input = output_with_input<O, I> && bounded<I, S>;
template <typename O, typename I, typename S>
concept output_with_bounded_forward = output_with_forward<O, I> && bounded<I, S>;
template <typename O, typename OS, typename I, typename IS>
concept bounded_output_with_bounded_input = output_with_bounded_input<O, I, IS> && bounded<O, OS>;
template <typename O, typename OS, typename I, typename IS>
concept bounded_output_with_bounded_forward = output_with_bounded_forward<O, I, IS> && bounded<O, OS>;

template <typename Op, typename T>
using unary_op_result_t = decltype(std::declval<Op&>()(std::declval<T>()));
template <typename Op, typename LHS, typename RHS = LHS>
using binary_op_result_t = decltype(std::declval<Op&>()(std::declval<LHS>(), std::declval<RHS>()));

template <typename O, typename UnaryOp, typename T>
concept output_unary_result = output<O, unary_op_result_t<UnaryOp, T>>;
template <typename O, typename OS, typename UnaryOp, typename T>
concept bounded_output_unary_result = output_unary_result<O, UnaryOp, T> && bounded<O, OS>;
template <typename O, typename UnaryOp, typename I>
concept output_unary_from = output_unary_result<O, UnaryOp, std::iter_value_t<fully_decayed<I>>>;
template <typename O, typename OS, typename UnaryOp, typename I>
concept bounded_output_unary_from = output_unary_from<O, UnaryOp, I> && bounded<O, OS>;

template <typename O, typename BinaryOp, typename T1, typename T2>
concept output_binary_result = output<O, binary_op_result_t<BinaryOp, T1, T2>>;
template <typename O, typename OS, typename BinaryOp, typename T1, typename T2>
concept bounded_output_binary_result = output_binary_result<O, BinaryOp, T1, T2> && bounded<O, OS>;
template <typename O, typename BinaryOp, typename T1, typename I2>
concept output_binary_from1 = output_binary_result<O, BinaryOp, T1, std::iter_value_t<fully_decayed<I2>>>;
template <typename O, typename OS, typename BinaryOp, typename T1, typename I2>
concept bounded_output_binary_from1 = output_binary_from1<O, BinaryOp, T1, I2> && bounded<O, OS>;
template <typename O, typename BinaryOp, typename I1, typename I2>
concept output_binary_from2 = output_binary_from1<O, BinaryOp, std::iter_value_t<fully_decayed<I1>>, I2>;
template <typename O, typename OS, typename BinaryOp, typename I1, typename I2>
concept bounded_output_binary_from2 = output_binary_from2<O, BinaryOp, I1, I2> && bounded<O, OS>;
}