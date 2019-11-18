library(dplyr)
library(ggplot2)
library(testthat)
library(campfin)

test_that("column statistics can be found from a data frame", {
  stats <- col_stats(diamonds, n_distinct, print = FALSE)
  expect_length(stats, 4)
  expect_equal(nrow(stats), length(diamonds))
  expect_equal(n_distinct(diamonds[, 1]), stats[[1, 3]])
  expect_type(stats$n, "integer")
  expect_type(stats$p, "double")
  expect_true(all(stats$p <= 1))
  expect_equal(stats$col, names(diamonds))
})

test_that("column statistics are warned when needed", {
  expect_error(col_stats(state.abb, n_distinct))
  expect_error(col_stats(diamonds, state.abb))
  expect_error(col_stats(diamonds, class))
})

test_that("column statistics are printed by default", {
  expect_output(col_stats(diamonds, n_distinct), NULL)
})

test_that("column statistics can be saved without printing", {
  expect_output(col_stats(diamonds, n_distinct, print = FALSE), NA)
})

test_that("glimpse_fun produces a depracted warning", {
  expect_warning(stats <- glimpse_fun(diamonds, n_distinct, print = FALSE))
  expect_output(suppressWarnings(glimpse_fun(diamonds, n_distinct)), NULL)
})
