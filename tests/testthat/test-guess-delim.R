test_that("delim of csv can be guessed", {
  delim <- guess_delim(
    file = system.file("extdata", "vt_contribs.csv", package = "campfin")
  )
  expect_identical(delim, ",")
})
