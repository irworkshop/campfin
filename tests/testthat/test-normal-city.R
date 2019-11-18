library(testthat)
library(campfin)

expect_detect <- function(object, pattern, negate = FALSE) {
  expect_true(all(str_detect(object, pattern, negate = negate)))
}

test_that("normal city can convert and remove invalid", {
  x <- c("Washington", "Unknown", "XXXXXX", "DC", "Washington, DC")
  y <- normal_city(x, abbs = c(DC = "Washington"), states = "DC", na = invalid_city, na_rep = TRUE)
  expect_type(y, "character")
  expect_detect(na.omit(y), "\\d", negate = TRUE)
  expect_detect(na.omit(y), "DC", negate = TRUE)
  expect_detect(na.omit(y), "[:lower:]", negate = TRUE)
  expect_equal(count_na(y), 2)
})
