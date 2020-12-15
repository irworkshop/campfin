library(testthat)
library(campfin)

test_that("diary creation works", {
  x <- use_diary("VT", "expends", "Kiernan Nicholls", FALSE)
  expect_length(x, 623)
})
