library(campfin)
library(testthat)

test_that("printing all tibble rows works", {
  data <- tibble::tibble(a = LETTERS, b = 1:26)
  expect_output(print_all(data))
})

test_that("printing all non-tibbles stops", {
  expect_warning(print_all(state.name))
})
