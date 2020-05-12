library(testthat)
library(campfin)
library(fs)

test_that("encoding for one file returns one row", {
  tmp <- tempfile()
  write_lines(1:100, tmp)
  expect_equal(nrow(file_encoding(tmp)), 1)
})

test_that("encoding for multiple files returns multiple rows", {
  tmps <- fs::file_temp(pattern = state.abb)
  for (i in seq_along(tmps)) {
    write_lines(state.abb[i], tmps[i])
  }
  expect_equal(nrow(file_encoding(tmps)), 50)
})

test_that("encoding for no file errors", {
  expect_error(file_encoding(tempfile()))
})
