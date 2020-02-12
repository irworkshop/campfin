library(testthat)
library(campfin)
library(tibble)
library(dplyr)

test_that("a new logical dupe_flag variable can be added", {
  df <- tibble(x = c("a", "b", "c", "c"), y = c("1", "2", "3", "3"))
  df <- flag_dupes(df, everything())
  expect_type(df$dupe_flag, "logical")
  expect_equal(sum(df$dupe_flag), 2)
})

test_that("columns can be ignored when flagging dupes", {
  df <- tibble(
    id = 1:4,
    x = c("a", "b", "c", "c"),
    y = c("1", "2", "3", "3")
  )
  df <- flag_dupes(df, -id)
  expect_equal(n_distinct(df$id), 4)
  expect_type(df$dupe_flag, "logical")
  expect_equal(sum(df$dupe_flag), 2)
})

test_that("useless dupe column can be removed automatically", {
  expect_warning(
    expect_equal(
      object = ncol(flag_dupes(mtcars, everything(), .check = TRUE)),
      expected = ncol(mtcars)
    )
  )
})
