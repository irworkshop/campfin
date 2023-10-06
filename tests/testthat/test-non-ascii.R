tmp <- tempfile(fileext = ".txt")
writeLines("R’s interpreter", tmp)

test_that("non-ASCII characters listed as tibble", {
  skip_on_os("mac")
  skip_on_os("windows")
  dat <- non_ascii(path = tmp)
  if (!is.data.frame(dat)) {
    skip("dat was not converted to a data frame")
  }
  expect_s3_class(dat, "data.frame")
  expect_equal(nrow(dat), 1)
})

hl <- function(string) {
  paste0("<span>", string, "</span>")
}

test_that("non-ASCII characters can be highlighted", {
  skip_on_os("mac")
  skip_on_os("windows")
  dat <- non_ascii(path = tmp, highlight = hl)
  if (!is.data.frame(dat)) {
    skip("dat was not converted to a data frame")
  }
  expect_true(grepl("span", dat$line[1]))
  expect_s3_class(dat, "data.frame")
  expect_equal(nrow(dat), 1)
})

tmp2 <- tempfile(fileext = ".txt")
writeLines("R's interpreter", tmp2)

test_that("Lack of non-ASCII characters return FALSE", {
  skip_on_os("mac")
  skip_on_os("windows")
  dat <- non_ascii(path = tmp2)
  expect_false(dat)
})
