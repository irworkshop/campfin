library(testthat)
library(campfin)

test_that("regex word breaks can be prevent intra-word replacement", {
  x <- "this is a testing string"
  y <- str_replace(x, rx_break("sting"), "TEST")
  expect_equal(x, y)
  x <- "testing one two three"
  y <- str_replace(x, rx_break("test"), "abdc")
  expect_equal(x, y)
})
