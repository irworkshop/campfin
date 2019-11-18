library(stringr)
library(testthat)
library(campfin)

expect_detect <- function(object, pattern, negate = FALSE) {
  expect_true(str_detect(object, pattern, negate = negate))
}

test_that("abbreviation works with data frame", {
  string <- "Gold and Iron are both metals"
  df <- tibble(x = c("Gold", "Iron"), y = c("Fe", "Au"))
  abbrev <- abbrev_full(string, full = df)
  expect_detect(abbrev, "Gold", negate = TRUE)
  expect_detect(abbrev, "Iron", negate = TRUE)
  expect_detect(abbrev, "Fe")
  expect_detect(abbrev, "Au")
})

test_that("abbreviation works with named vector", {
  string <- "Gold and Iron are both metals"
  vec <- c(Gold = "Au", Iron = "Fe")
  abbrev <- abbrev_full(string, full = vec)
  expect_detect(abbrev, "Gold", negate = TRUE)
  expect_detect(abbrev, "Iron", negate = TRUE)
  expect_detect(abbrev, "Fe")
  expect_detect(abbrev, "Au")
})

test_that("abbreviation works with two vectors", {
  string <- "Gold and Iron are both metals"
  a <- c("Gold", "Iron")
  b <- c("Fe", "Au")
  abbrev <- abbrev_full(string, full = a, rep = b)
  expect_detect(abbrev, "Gold", negate = TRUE)
  expect_detect(abbrev, "Iron", negate = TRUE)
  expect_detect(abbrev, "Fe")
  expect_detect(abbrev, "Au")
})

test_that("abbreviation stops with insufficient arguments", {
  string <- "Gold and Iron are both metals"
  a <- c("Gold", "Iron")
  b <- c("Fe", "Au", "Pb")
  expect_error(abbrev_full(string, full = a))
  expect_error(abbrev_full(string, full = a, rep = b))
})

test_that("abbrev_state can wrap around abbrev_full for US states", {
  expect_equal(abbrev_state("Vermont"), "VT")
  expect_error(abbrev_state(state.x77))
})
