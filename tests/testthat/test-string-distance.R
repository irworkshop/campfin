library(testthat)
library(campfin)

test_that("string distance can be found", {
  expect_equal(str_dist("abc", "abe"), 1)
  expect_equal(str_dist("testing", "besting", method = "lv"), 1)
  expect_equal(str_dist("test", "test"), 0)
})
