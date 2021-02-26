library(testthat)
library(campfin)

test_that("the %out% infix opperator works as an invert of %in%", {
  x <- c("VT", "DC")
  a <- x %out% state.abb
  b <- !(x %in% state.abb)
  expect_equal(a, b)
  expect_equal(sum(a), 1)
  expect_equal(sum(a), sum(b))
})

test_that("the prop_in counter wraps around mean(%in%)", {
  x <- c("VT", "DC", "MA", "FR", "NM", "TX", "QB")
  a <- prop_in(x, state.abb)
  b <- mean(x %in% state.abb)
  expect_equal(a, b)
})

test_that("the prop_out counter wraps around mean(%out%)", {
  x <- c("VT", "DC", "MA", "FR", "NM", "TX", "QB")
  a <- prop_out(x, state.abb)
  b <- mean(x %out% state.abb)
  expect_equal(a, b)
})

test_that("the count_in counter wraps around sum(%in%)", {
  x <- c("VT", "DC", "MA", "FR", "NM", "TX", "QB")
  a <- count_in(x, state.abb)
  b <- sum(x %in% state.abb)
  expect_equal(a, b)
})

test_that("the count_out counter wraps around sum(%out%)", {
  x <- c("VT", "DC", "MA", "FR", "NM", "TX", "QB")
  a <- count_out(x, state.abb)
  b <- sum(x %out% state.abb)
  expect_equal(a, b)
})

test_that("count_in and count_out can exclude NA", {
  x <- c("VT", "DC", "MA", "FR", "NM", "TX", "QB", NA)
  a <- count_out(x, state.abb, na.rm = FALSE)
  b <- sum(x %out% state.abb)
  expect_equal(a, b)
})

test_that("count_diff wraps around length(setdiff())", {
  x <- c("VT", "DC", "MA", "FR", "NM", "TX", "QB")
  a <- count_diff(x, state.abb)
  b <- length(setdiff(x, state.abb))
  expect_equal(a, b)
})

test_that("count_na wraps around sum(is.na())", {
  x <- c("VT", "DC", "MA", "FR", "NM", "TX", "QB", NA)
  a <- count_na(x)
  b <- sum(is.na(x))
  expect_equal(a, b)
})

test_that("prop_na wraps around mean(is.na())", {
  x <- c("VT", "DC", "MA", "FR", "NM", "TX", "QB", NA)
  a <- prop_na(x)
  b <- mean(is.na(x))
  expect_equal(a, b)
})

test_that("na_in can assign NA to values %in%", {
  x <- c("VT", "DC", "MA", "FR", "NM", "TX", "QB", NA)
  y <- c("VT", "DC")
  a <- na_in(x, y)
  expect_equal(sum(is.na(a)), 3)
})

test_that("na_out can assign NA to values %out%", {
  x <- c("VT", "DC", "MA", "FR", "NM", "TX", "QB", NA)
  y <- c("VT", "DC")
  a <- na_out(x, y)
  expect_equal(sum(is.na(a)), 6)
})

test_that("na_rep can assign NA to any single-digit repeating string", {
  x <- c("ABC", "AAA", "BBB")
  a <- na_rep(x)
  expect_equal(count_na(a), 2)
})

test_that("na_rep can ignore strings of only one character", {
  x <- c("A", "B", "C")
  a <- na_rep(x, n = 1)
  expect_equal(a, x)
})

test_that("comparisong counters can ignore case", {
  expect_equal(prop_in(letters, LETTERS, ignore.case = TRUE), 1)
  expect_equal(prop_out(letters, LETTERS, ignore.case = TRUE), 0)
  expect_equal(count_in(letters, LETTERS, ignore.case = TRUE), 26)
  expect_equal(count_out(letters, LETTERS, ignore.case = TRUE), 0)
  expect_equal(count_na(na_in(letters, LETTERS, ignore.case = TRUE)), 26)
  expect_equal(count_na(na_out(letters, LETTERS, ignore.case = TRUE)), 0)
})

test_that("what_in can ignore case", {
  x <- c("vt", "ma", NA)
  expect_length(what_in(x, state.abb, ignore.case = TRUE), 2)
})

test_that("what_out can ignore case", {
  x <- c("vt", "ma", NA)
  expect_length(what_out(x, state.abb, ignore.case = TRUE), 0)
})

test_that("what_out can ignore NA", {
  x <- c("VT", "DC", NA)
  expect_length(what_out(x, state.abb, na.rm = TRUE), 1)
})
