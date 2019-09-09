context("Check for abbreviation")
library(campfin)

test_that("is_abbrev works on (state) vectors", {
  expect_true(all(is_abbrev(state.abb, state.name)))
})

test_that("is_abbrev works for simple initialism", {
  expect_true(is_abbrev("NYC", "New York City"))
})

test_that("is_abbrev works for complex abbreviation", {
  expect_true(is_abbrev("BRNX", "Bronx"))
})
