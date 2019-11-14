library(testthat)
library(campfin)

test_that("numbers can be checked for even or odd", {
  expect_true(is_even(2))
  expect_false(is_even(3))
  expect_equal(sum(is_even(1:10)), 5)
})

test_that("vectors can be checked for binary nature", {
  x <- sample(x = c("a", "b", NA), size = 100, replace = TRUE)
  expect_true(is_binary(x))
  y <- sample(x = state.abb, size = 100, replace = TRUE)
  expect_false(is_binary(y))
})
