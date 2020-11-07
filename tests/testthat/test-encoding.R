library(testthat)
library(campfin)
library(fs)

test_that("encoding for one file returns one row", {
  skip_on_os("solaris")
  tmp <- tempfile()
  writeLines(as.character(1:100), tmp)
  enc <- file_encoding(tmp)
  skip_if(is.null(enc))
  expect_equal(nrow(enc), 1)
})

test_that("encoding for multiple files returns multiple rows", {
  skip_on_os("solaris")
  st_tmp <- fs::file_temp(pattern = state.abb)
  unlink(st_tmp)
  for (i in seq_along(st_tmp)) {
    writeLines(state.abb[i], st_tmp[i])
  }
  enc <- file_encoding(st_tmp)
  skip_if(is.null(enc))
  expect_equal(nrow(enc), 50)
})

test_that("encoding for no file errors", {
  skip_on_os("solaris")
  tmp <- tempfile(fileext = "csv")
  unlink(tmp)
  expect_error(file_encoding(tmp))
})
