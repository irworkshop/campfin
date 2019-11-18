library(testthat)
library(campfin)

test_that("checking city without guessing returns a logical vector", {
  check1 <- check_city("WYOMISSING", "PA")
  check2 <- check_city("Tokyo", "VT")
  expect_type(check1, "logical")
  expect_true(check1)
  expect_false(check2)
})

test_that("checking city returns data frame when guessing", {
  check3 <- check_city("Waggaman", "LA", guess = TRUE)
  expect_s3_class(check3, "tbl")
  expect_equal(ncol(check3), 6)
  expect_equal(nrow(check3), 1)
})

test_that("fetching city returns an entire address string", {
  fetch <- fetch_city("4529 Wisconsin Ave NW, Tenelytown, DC 20016")
  expect_type(fetch, "character")
})
