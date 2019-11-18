library(testthat)
library(campfin)

test_that("abbreviations can be checked against another word", {
  expect_true(is_abbrev("VT", "Vermont"))
  expect_true(is_abbrev("NYC", "New York City"))
  expect_false(is_abbrev("NH", "Vermont"))
  expect_false(is_abbrev("DCA", "Washington, DC"))
  expect_false(is_abbrev("Vermont", "VT"))
})
