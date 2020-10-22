library(ggplot2)
library(testthat)
library(campfin)

test_that("exploration plots are ggplot objects", {
  plot <- explore_plot(diamonds, cut)
  expect_s3_class(plot, "ggplot")
})
