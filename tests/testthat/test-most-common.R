library(testthat)
library(campfin)

test_that("most common values of a vector can be found", {
  x <- c("A", "A", "A", "B", "B", "C")
  expect_equal(most_common(x, 2), c("A", "B"))
  expect_length(most_common(x, 2), 2)
  expect_type(most_common(x, 2), "character")
})
