library(testthat)
library(campfin)

test_that("diary creation works", {
  setwd(tempdir())
  x <- use_diary("VT", "contribs", "Kiernan Nicholls")
  expect_true(file.exists(x))
  file.remove(x)
})
