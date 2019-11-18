library(testthat)
library(campfin)
library(fs)

dir_create("dir")

test_that("empty directories warn and return false", {
  expect_false(expect_warning(all_files_new("dir")))
})

test_that("non-existant files warn and return false", {
  expect_false(expect_warning(this_file_new("dir/temp.txt")))
})

file_create("dir/temp.txt")

test_that("the age of all files in a directory can be checked", {
  expect_true(all_files_new("dir"))
})

test_that("the age of a single file can be checked", {
  expect_true(this_file_new("dir/temp.txt"))
  expect_false(this_file_new("../../README.md"))
})

dir_delete("dir")
