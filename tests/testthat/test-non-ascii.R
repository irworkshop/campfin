tmp <- tempfile(fileext = ".txt")
writeLines("R’s interpreter", tmp)

test_that("non-ASCII characters listed as tibble", {
  dat <- non_ascii(path = tmp)
  expect_s3_class(dat, "data.frame")
  expect_equal(nrow(dat), 1)
})

test_that("non-ASCII characters can be highlighted", {
  dat <- non_ascii(
    path = tmp,
    highlight = function(string) {
      paste0("<span>", string, "</span>")
    }
  )
  expect_true(grepl("span", dat$line[1]))
  expect_s3_class(dat, "data.frame")
  expect_equal(nrow(dat), 1)
})

tmp <- tempfile(fileext = ".txt")
writeLines("R's interpreter", tmp)

test_that("Lack of ASCII characters return FALSE", {
  dat <- non_ascii(path = tmp)
  expect_false(dat)
})
