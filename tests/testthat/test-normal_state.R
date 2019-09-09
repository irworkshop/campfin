context("State normalization")
library(campfin)
library(stringr)

test_that("normal_state converts to upper", {
  str_detect(normal_state("vt"), "[:upper:]")
  str_detect(normal_state("dc"), "[:upper:]")
})

test_that("normal_state removes non-alphabetic characters", {
  expect_true(normal_state("ME02") %in% state.abb)
  expect_true(normal_state("Maine 2") %in% state.abb)
  expect_true(normal_state(" VT ") %in% state.abb)
  expect_true(normal_state(".VT.") %in% state.abb)
})

test_that("normal_state abbreviates state names", {
  expect_equal(normal_state("Vermont", abbreviate = TRUE), "VT")
  expect_true(all(nchar(normal_state(state.name)) == 2))
  expect_setequal(normal_state(state.name), state.abb)
})

test_that("normal_state removes NA", {
  expect_true(is.na(normal_state("NA")))
  expect_true(is.na(normal_state("")))
  expect_true(is.na(normal_state("test", na = "test")))
})

test_that("normal_state removes repeating", {
  expect_true(is.na(normal_state("XX", na_rep = TRUE)))
  expect_true(is.na(normal_state("AA", na_rep = TRUE)))
})

test_that("normal_state doesn't remove valid abbs", {
  expect_false(any(is.na(normal_state(state.abb, valid = state.abb))))
  expect_false(any(is.na(normal_state(state.name, valid = state.abb))))
  expect_false(any(is.na(normal_state(valid_state, valid = valid_state))))
  expect_false(any(is.na(normal_state(valid_name, valid = valid_state))))
  expect_false(any(is.na(normal_state("DC", valid = valid_state))))
})

test_that("normal_state removed invalid", {
  expect_true(all(is.na(normal_state("FR", valid = state.abb))))
  expect_true(all(is.na(normal_state("France", valid = state.abb))))
  expect_true(all(is.na(normal_state("DC", valid = state.abb))))
})
