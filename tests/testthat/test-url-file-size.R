library(testthat)
library(campfin)

test_that("the file size of the URL can be checked from HEAD", {
  url <- "https://raw.githubusercontent.com/irworkshop/campfin/master/README.md"
  expect_type(url_file_size(url), "double")
  expect_s3_class(url_file_size(url), "fs_bytes")
})
