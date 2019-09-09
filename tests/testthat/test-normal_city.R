context("City normalization")
library(campfin)
library(stringr)

test_that("normal_city converts to upper", {
  expect_true(str_detect(normal_city("Stowe"), "[:upper:]"))
  expect_true(str_detect(normal_city("Morrisville"), "[:upper:]"))
})

test_that("normal_city removes non-alphabetic characters", {
  expect_false(str_detect(normal_city("new_york"), "[^A-Z\\s]"))
  expect_false(str_detect(normal_city("Burlington"), "[^A-Z\\s]"))
  expect_false(str_detect(normal_city("los-angeles"), "[^A-Z\\s]"))
  expect_false(str_detect(normal_city("el.paso"), "[^A-Z\\s]"))
  expect_false(str_detect(normal_city("Elmore1"), "[^A-Z\\s]"))
})

test_that("normal_city expands geographics abbreviations", {
  expect_equal(normal_city("Test Bch", geo_abbs = usps_city), "TEST BEACH")
  expect_equal(normal_city("Test Vly", geo_abbs = usps_city), "TEST VALLEY")
  expect_equal(normal_city("Mt Test",  geo_abbs = usps_city), "MOUNT TEST")
  expect_equal(normal_city("Prt Test", geo_abbs = usps_city), "PORT TEST")
})

test_that("normal_city removes NA", {
  expect_true(is.na(normal_city("NA")))
  expect_true(is.na(normal_city("")))
  expect_true(is.na(normal_city("Missing", na = invalid_city)))
  expect_true(is.na(normal_city("Online", na = invalid_city)))
  expect_true(is.na(normal_city("Not Applicable", na = invalid_city)))
})

test_that("normal_city removes repeating", {
  expect_true(is.na(normal_city("XXXXXXXX", na_rep = TRUE)))
})

test_that("normal_city removes state abbreviation suffix", {
  expect_true(normal_city("Morrisville, VT", st_abbs = "VT") %in% valid_city)
  expect_equal(normal_city("Stowe VT", st_abbs = state.abb), "STOWE")
  expect_true(normal_city("Washington DC", st_abbs = "DC") %in% valid_city)
})
