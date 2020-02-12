library(testthat)
library(campfin)
library(fs)

test_that("diary creation works", {
  # skip("Non-standard things in the check directory")
  tmp <- tempdir()
  x <- use_diary("VT", "expends", "Kiernan Nicholls", tmp)
  expect_true(file_exists(x))
  expect_length(readLines(x), 522)
  on.exit(unlink(x))
  on.exit(dir_delete(tmp))
})
