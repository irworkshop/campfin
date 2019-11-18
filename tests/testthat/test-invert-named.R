library(testthat)
library(campfin)

test_that("names and values of a vector can be inverted", {
  x <- invert_named(c(name = "value"))
  expect_equal(names(x), "value")
  expect_equal(unname(x), "name")
  expect_error(invert_named(state.abb))
})
