library(dplyr)

test_that("Character vectors can be counted with dplyr", {
  x <- sample(LETTERS)[rpois(1000, 10)]
  c <- count(x)
  expect_s3_class(c, "data.frame")
  expect_type(c$x, "character")
  expect_type(c$n, "integer")
})

test_that("Character counts can be sorted and fractioned", {
  x <- sample(LETTERS)[rpois(1000, 10)]
  c <- count(x, sort = TRUE, prop = TRUE)
  expect_true("p" %in% names(c))
  expect_true(all(diff(c$n) <= 0))
})


