context("City normalization")
library(campfin)
library(stringr)

test_that("normal_zip converts to character", {
  expect_true(is.character(normal_zip(05661)))
})

test_that("normal_zip pads with leading zero", {
  expect_true(normal_zip(5661) %in% valid_zip)
})

test_that("normal_zip removes plus four code", {
  expect_true(normal_zip("20500-0001") %in% valid_zip)
})

test_that("normal_zip removes NA", {
  expect_true(is.na(normal_zip("NA")))
  expect_true(is.na(normal_zip("")))
  expect_true(is.na(normal_zip("nozip", na = "nozip")))
})

test_that("normal_zip removes invalid repeating", {
  expect_true(is.na(normal_zip("00000", na_rep = TRUE)))
  expect_true(is.na(normal_zip("11111", na_rep = TRUE)))
})

test_that("normal_zip does not remove valid repeating", {
  expect_false(is.na(normal_zip("22222", na_rep = TRUE)))
  expect_false(is.na(normal_zip("55555", na_rep = TRUE)))
})
