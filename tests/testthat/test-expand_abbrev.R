context("Expand abbreviations")
library(campfin)

test_that("expand_abbrev works with data frame", {
  expect_equal(expand_abbrev("BLVD", usps_street), "BOULEVARD")
  expect_equal(expand_abbrev("ST", usps_city), "SAINT")
  expect_equal(expand_abbrev("VT", as.data.frame(usps_state)), "VERMONT")
})

test_that("expand_abbrev works with named vector", {
  expect_equal(expand_abbrev("VT", c("VT" = "Vermont")), "Vermont")
  expect_setequal(expand_abbrev(valid_state, deframe(usps_state)), valid_name)
})

test_that("expand_abbrev works with abbreviation and replacement", {
  expect_equal(expand_abbrev("VT", state.abb, state.name), "Vermont")
  expect_equal(expand_abbrev("PR", valid_state, valid_name), "PUERTO RICO")
})
