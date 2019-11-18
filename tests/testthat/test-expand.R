library(stringr)
library(testthat)
library(campfin)

expect_detect <- function(object, pattern, negate = FALSE) {
  expect_true(str_detect(object, pattern, negate = negate))
}

test_that("expansion works with data frame", {
  string <- "Au and Fe are both metals"
  df <- tibble(x = c("Au", "Fe"), y = c("Iron", "Gold"))
  expand <- expand_abbrev(string, abb = df)
  expect_detect(expand, "Au", negate = TRUE)
  expect_detect(expand, "Fe", negate = TRUE)
  expect_detect(expand, "Iron")
  expect_detect(expand, "Gold")
})

test_that("expansion works with named vector", {
  string <- "Au and Fe are both metals"
  vec <- c(Au = "Gold", Fe = "Iron")
  expand <- expand_abbrev(string, abb = vec)
  expect_detect(expand, "Au", negate = TRUE)
  expect_detect(expand, "Fe", negate = TRUE)
  expect_detect(expand, "Iron")
  expect_detect(expand, "Gold")
})

test_that("expansion works with two vectors", {
  string <- "Au and Fe are both metals"
  a <- c("Au", "Fe")
  b <- c("Iron", "Gold")
  expand <- expand_abbrev(string, abb = a, rep = b)
  expect_detect(expand, "Au", negate = TRUE)
  expect_detect(expand, "Fe", negate = TRUE)
  expect_detect(expand, "Iron")
  expect_detect(expand, "Gold")
})

test_that("expansion stops with insufficient arguments", {
  string <- "Au and Fe are both metals"
  a <- c("Au", "Fe")
  b <- c("Iron", "Gold", "Pb")
  expect_error(expand_abbrev(string, abb = a))
  expect_error(expand_abbrev(string, abb = a, rep = b))
})

test_that("expand_state can wrap around expand_abbrev for US states", {
  expect_equal(expand_state("VT"), "VERMONT")
  expect_error(expand_state(state.x77))
})
