library(testthat)
library(campfin)

expect_detect <- function(object, pattern, negate = FALSE) {
  expect_true(all(str_detect(object, pattern, negate = negate)))
}

x <- c(
  "(202) 456-1111",
  "(202) HKN-1111",
  "(202) 456-1111 ext100",
  "(202) 456-1111x100",
  2024561111,
  "202.456.1111",
  "202-456-1111",
  "202 456 1111",
  "Phone",
  "123456",
  NA
)

test_that("normal phone creates a single format", {
  y <- normal_phone(
    number = x,
    format = "(%a) %e-%l",
    na_bad = TRUE,
    convert = TRUE,
    rm_ext = TRUE
  )
  expect_length(unique(na.omit(y)), 1)
})

test_that("normal phone can keep extensions and other invalids", {
  y <- normal_phone(
    number = x,
    format = "(%a) %e-%l",
    na_bad = FALSE,
    convert = FALSE,
    rm_ext = FALSE
  )
  expect_length(unique(na.omit(y)), 4)
})

test_that("normal phone stops on bad input", {
  expect_error(normal_phone(mtcars))
})
