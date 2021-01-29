test_that("File path can be abbreviated from given dir", {
  abb <- path.abbrev(
    path = system.file("extdata", "vt_contribs.csv", package = "campfin"),
    dir = system.file(package = "campfin")
  )
  expect_equal(abb, "~/extdata/vt_contribs.csv")
})
