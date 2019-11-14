library(testthat)
library(campfin)
library(fs)

dir_create("dir")
file_create("dir/temp.txt")

test_that("the age of all files in a directory can be checked", {
  expect_true(all_files_new("dir"))
})

test_that("the age of files in an old directory returns false", {
  skip("directory path trouble running test suite")
  expect_false(all_files_new("../../data/"))
})

test_that("the age of a single file can be checked", {
  expect_true(this_file_new("dir/temp.txt"))
  expect_false(this_file_new("../../README.md"))
})

dir_delete("dir")
