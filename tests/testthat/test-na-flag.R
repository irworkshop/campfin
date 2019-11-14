library(testthat)
library(campfin)
library(tibble)
library(dplyr)

test_that("a new logical na_flag variable can be added", {
  df <- tibble(x = c("a", "b", "c", NA), y = c("1", "2", "3", "3"))
  df <- flag_na(df, everything())
  expect_type(df$na_flag, "logical")
  expect_equal(sum(df$na_flag), 1)
})

test_that("columns can be ignored when flagging dupes", {
  df <- tibble(
    id = 1:4,
    x = c("a", "b", NA, "c"),
    y = c("1", "2", "3", NA)
  )
  df <- flag_na(df, -id)
  expect_equal(n_distinct(df$id), 4)
  expect_type(df$na_flag, "logical")
  expect_equal(sum(df$na_flag), 2)
})
