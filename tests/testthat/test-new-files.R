library(testthat)
library(campfin)
library(fs)

tmp_dir <- dir_create(file_temp())

test_that("empty directories warn and return false", {
  expect_false(expect_warning(all_files_new(tmp_dir)))
})

tmp_one <- path(tmp_dir, "one.txt")
unlink(tmp_one)
test_that("non-existant files warn and return false", {
  expect_false(expect_warning(this_file_new(tmp_one)))
})

file_create(tmp_one)
test_that("the age of all files in a directory can be checked", {
  expect_true(all_files_new(tmp_dir))
})

test_that("the age of a single file can be checked", {
  expect_true(this_file_new(tmp_one))
  rdme <- path(getwd(), "README.md")
  if (file_exists(rdme)) {
    expect_false(this_file_new(rdme))
  }
})

dir_delete(tmp_dir)
