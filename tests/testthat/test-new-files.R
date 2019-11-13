library(tidyverse)
library(testthat)
library(campfin)
library(here)
library(fs)

dir_create(here("dir"))
file_create(here("dir", "temp.txt"))

test_that("the age of all files in a directory can be checked", {
  expect_true(all_files_new(here("dir")))
  expect_false(all_files_new(here("data")))
})

test_that("the age of a single file can be checked", {
  expect_true(this_file_new(here("dir", "temp.txt")))
  expect_false(this_file_new(here("README.md")))
})

dir_delete(here("dir"))
