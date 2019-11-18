library(ggplot2)
library(testthat)
library(campfin)

test_that("exploration plots are ggplot objects", {
  plot <- explore_plot(diamonds, cut)
  expect_s3_class(plot, "ggplot")
})

test_that("exploration plots can be flipped with an argument", {
  plot <- explore_plot(diamonds, cut, flip = TRUE)
  expect_s3_class(plot$coordinates, "CoordFlip")
  plot <- explore_plot(diamonds, cut, flip = FALSE)
  expect_true("CoordFlip" %out% class(plot$coordinates))
})
