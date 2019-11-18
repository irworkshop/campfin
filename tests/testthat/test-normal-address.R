library(testthat)
library(campfin)

expect_detect <- function(object, pattern, negate = FALSE) {
  expect_true(all(str_detect(object, pattern, negate = negate)))
}

test_that("normal address can convert and remove invalid", {
  x <- c(
    "1600 Pennsylvania Ave NW",
    "101 Independence Avenue SE",
    "XXXXXXXXX",
    NA,
    "Not Given"
  )
  y <- normal_address(x, abbs = usps_street, na = invalid_city, na_rep = TRUE)
  expect_type(y, "character")
  expect_equal(count_na(y), 3)
  expect_detect(na.omit(y), "[:lower:]", negate = TRUE)
  expect_equal(length(x), length(y))
})
