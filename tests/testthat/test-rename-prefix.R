library(testthat)
library(campfin)

expect_different <- function(object, expected) {
  expect_false(identical(object, expected))
}

test_that("suffixes can be changed to prefixes", {
  a <- data.frame(x = letters[1:3], y = 1:3)
  b <- data.frame(x = letters[1:3], y = 4:6)
  df1 <- dplyr::left_join(a, b, by = "x", suffix = c(".a", ".b"))
  df2 <- rename_prefix(df1, suffix = c(".a", ".b"), punct = TRUE)
  expect_different(df1, df2)
})

test_that("suffixes can be changed to prefixes without moving punctuation", {
  a <- data.frame(x = letters[1:3], y = 1:3)
  b <- data.frame(x = letters[1:3], y = 4:6)
  df1 <- dplyr::left_join(a, b, by = "x", suffix = c(".a", ".b"))
  df2 <- rename_prefix(df1, suffix = c(".a", ".b"), punct = FALSE)
  expect_different(df1, df2)
})

test_that("suffixes cannot be renamed without sufficient values", {
  a <- data.frame(x = letters[1:3], y = 1:3)
  b <- data.frame(x = letters[1:3], y = 4:6)
  expect_error(rename_prefix(dplyr::left_join(a, b, by = "x"), suffix = c(".")))
})
