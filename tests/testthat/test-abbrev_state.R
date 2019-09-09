context("Expand and abbreviate states")
library(campfin)

test_that("abbrev_state creates valid state abbreviations", {
  expect_equal(abbrev_state("Vermont"), "VT")
  expect_equal(abbrev_state("VERMONT"), "VT")
  expect_equal(abbrev_state("District of Columbia"), "DC")
  expect_setequal(abbrev_state(state.name), state.abb)
  expect_true(all(abbrev_state(sample(state.name, 10)) %in% state.abb))
})

test_that("expand_state creates valid state names", {
  expect_equal(expand_state("vt"), "VERMONT")
  expect_equal(expand_state("VT"), "VERMONT")
  expect_equal(expand_state("DC"), "DISTRICT OF COLUMBIA")
  expect_setequal(expand_state(state.abb), toupper(state.name))
  expect_true(all(expand_state(sample(state.abb, 10)) %in% toupper(state.name)))
})

