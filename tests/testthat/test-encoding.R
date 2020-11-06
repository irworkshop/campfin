library(testthat)
library(campfin)
library(fs)

test_that("encoding for one file returns one row", {
  tmp <- tempfile()
  writeLines(as.character(1:100), tmp)
  expect_equal(nrow(file_encoding(tmp)), 1)
})

test_that("encoding for multiple files returns multiple rows", {
  st_tmp <- fs::file_temp(pattern = state.abb)
  unlink(st_tmp)
  for (i in seq_along(st_tmp)) {
    writeLines(state.abb[i], st_tmp[i])
  }
  expect_equal(nrow(file_encoding(st_tmp)), 50)
})

test_that("encoding for no file errors", {
  tmp <- tempfile(fileext = "csv")
  unlink(tmp)
  expect_error(file_encoding(tmp))
})
