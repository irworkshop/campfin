library(readr)
library(testthat)
library(campfin)

test_that("MDY dates can be parsed in readr::read_csv()", {
  raw <- "x\n11/09/2016"
  df <- read_csv(raw, col_types = cols(x = col_date_mdy()))
  expect_s3_class(df$x, "Date")
})

test_that("USA dates can be parsed in readr::read_csv()", {
  raw <- "x\n11/09/2016"
  expect_warning(read_csv(raw, col_types = cols(x = col_date_usa())))
})
