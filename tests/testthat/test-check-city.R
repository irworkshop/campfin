library(testthat)
library(campfin)

test_that("checking city without guessing returns a logical vector", {
  skip_if_not(nchar(Sys.getenv("GEOCODE_KEY")) > 0)
  check1 <- check_city("WYOMISSING", "PA")
  check2 <- check_city("Tokyo", "VT")
  expect_type(check1, "logical")
  expect_true(check1)
  expect_false(check2)
})

test_that("checking city returns data frame when guessing", {
  skip_if_not(nchar(Sys.getenv("GEOCODE_KEY")) > 0)
  check3 <- check_city("Waggaman", "LA", guess = TRUE)
  expect_s3_class(check3, "tbl")
  expect_equal(ncol(check3), 6)
  expect_equal(nrow(check3), 1)
})

test_that("fetching city returns an entire address string", {
  skip_if_not(nchar(Sys.getenv("GEOCODE_KEY")) > 0)
  fetch <- fetch_city("4529 Wisconsin Ave NW, Tenelytown, DC 20016")
  expect_type(fetch, "character")
})

test_that("fetching addresses returns warnings and errors", {
  skip_if_not(nchar(Sys.getenv("GEOCODE_KEY")) > 0)
  expect_error(fetch_city())
  expect_error(fetch_city(""))
  expect_error(fetch_city(NA))
  expect_warning(fetch_city("test", key = ""))
  expect_warning(fetch_city("hwiouehf;ehrg"))
  expect_warning(expect_true(is.na(fetch_city("hwiouehf;ehrg"))))
})

test_that("checking cities returns warnings and errors", {
  skip_if_not(nchar(Sys.getenv("GEOCODE_KEY")) > 0)
  expect_error(check_city())
  expect_error(check_city(""))
  expect_error(check_city(NA))
  expect_warning(check_city("test", key = ""))
  expect_warning(check_city("hwiouehf;ehrg", guess = TRUE))
  expect_s3_class(suppressWarnings(check_city("hwiouehf;ehrg", guess = TRUE)), "tbl")
})
