test_that("multiplication works", {
  nm <- read_names(
    file = system.file("extdata", "vt_contribs.csv", package = "campfin")
  )
  expect_type(nm, "character")
  expect_length(nm, 9)
})
