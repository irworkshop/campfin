library(stringr)
library(testthat)
library(campfin)

expect_detect <- function(object, pattern, negate = FALSE) {
  expect_true(all(str_detect(object, pattern, negate = negate)))
}

test_that("keypad conversion works for numbers to letters", {
  nums <- keypad_convert("1-800-TST-THAT")
  expect_detect(nums, "[:alpha:]", negate = TRUE)
})

test_that("keypad conversion can ignore extensisons", {
  nums <- keypad_convert("1-800-CASH-NOW ext123", ext = FALSE)
  expect_detect(nums, "ext")
  nums <- keypad_convert("1-800-CASH-NOW ext123", ext = TRUE)
  expect_detect(nums, "ext", negate = TRUE)
})

test_that("keypad conversion is vectorized", {
  x <- c("abc", "123")
  y <- keypad_convert(x)
  expect_detect(y, "[:alpha:]", negate = TRUE)
  expect_length(y, 2)
})
