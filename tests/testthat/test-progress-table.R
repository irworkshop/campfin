library(testthat)
library(campfin)

x <- c("VT", "Vermont", NA, "vt", "")
y <- normal_state(x)

test_that("progress tables create data frames", {
  p <- progress_table(x, y, compare = state.abb)
  expect_s3_class(p, "tbl")
  expect_type(p$stage, "character")
  expect_type(p$n_distinct, "double")
  expect_length(p, 6)
  expect_equal(nrow(p), 2)
  expect_equal(p$prop_in[1], prop_in(x, state.abb))
})
