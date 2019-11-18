library(testthat)
library(campfin)
library(fs)

test_that("file paths can be created from url basenames", {
  url <- "https://raw.githubusercontent.com/irworkshop/campfin/master/README.md"
  dir_create("dir")
  path <- url2path(url, "dir")
  download.file(url, path)
  expect_true(file_exists("dir/README.md"))
  dir_delete("dir")
})
