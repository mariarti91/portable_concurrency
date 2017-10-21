#pragma once

#include <type_traits>

#include "fwd.h"

namespace portable_concurrency {
inline namespace cxx14_v1 {
namespace detail {

template<typename F>
struct is_unique_future: std::false_type {};

template<typename T>
struct is_unique_future<future<T>>: std::true_type {};

template<typename F>
struct is_shared_future: std::false_type {};

template<typename T>
struct is_shared_future<shared_future<T>>: std::true_type {};

template<typename F>
using is_future = std::integral_constant<bool, is_unique_future<F>::value || is_shared_future<F>::value>;

template<typename... F>
struct are_futures;

template<>
struct are_futures<>: std::true_type {};

template<typename F0, typename... F>
struct are_futures<F0, F...>: std::integral_constant<
  bool,
  is_future<F0>::value && are_futures<F...>::value
> {};

template<typename T>
struct remove_future {using type = T;};

template<typename T>
struct remove_future<future<T>> {using type = T;};

template<typename T>
using remove_future_t = typename remove_future<T>::type;

template<template<typename> class Future, typename Func, typename T>
using then_result_t = std::result_of_t<Func(Future<T>)>;

} // namespace detail
} // inline namespace cxx14_v1

// Intended to be specialized for user provided executor classes
template<typename T>
struct is_executor: std::false_type {};

} // namespace portable_concurrency
