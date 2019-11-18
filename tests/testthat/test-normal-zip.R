library(testthat)
library(campfin)

expect_detect <- function(object, pattern, negate = FALSE) {
  expect_true(all(str_detect(object, pattern, negate = negate)))
}

test_that("normal zip can convert and remove invalid", {
  x <- c(20015, "20015", "05661", NA, "00000", "XXXXX", "zip 20015")
  y <- normal_zip(x, na_rep = TRUE)
  expect_type(y, "character")
  expect_detect(na.omit(y), "[:alpha:]", negate = TRUE)
  expect_equal(count_na(y), 3)
})
