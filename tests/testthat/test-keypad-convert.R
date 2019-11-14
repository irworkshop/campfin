library(stringr)
library(testthat)
library(campfin)

expect_detect <- function(object, pattern, negate = FALSE) {
  expect_true(str_detect(object, pattern, negate = negate))
}

test_that("keypad conversion works for numbers to letters", {
  nums <- keypad_convert("1-800-TST-THAT")
  expect_detect(nums, "[:alpha:]", negate = TRUE)
})
