library(testthat)
library(campfin)

test_that("normal state can abbreviate and remove invalid", {
  x <- c("VT", "Vermont", "vermont", "vt", NA, "NA", "XX", "FR", "AA")
  y <- normal_state(x, abbreviate = TRUE, na_rep = TRUE, valid = valid_abb)
  expect_length(which(y == "VT"), 4)
  expect_equal(prop_in(y, valid_abb), 1)
  expect_equal(count_na(y), 4)
})
