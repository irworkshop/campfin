#' Normalize a character string
#'
#' @description
#' The generic normalization that underpins functions like [normal_city()] and
#' [normal_address()]. This function simply chains together three
#' `stringr::str_*()` functions:
#'   1. Convert to uppercase.
#'   2. Replace punctuation with whitespaces.
#'   4. Trim and squish excess whitespace.
#'
#' @param x A character string to normalize.
#' @param case logical; whether [stringr::str_to_upper()] should be called.
#' @param punct character; A character string to replace most punctuation with.
#' @param quote logical; whether [stringr::str_replace_all()] should be called
#'   on double quotes.
#' @param squish logical; whether [stringr::str_squish()] should be called.
#' @return A normalized vector of the same length.
#' @examples
#' str_normal("   TestING 123   example_test.String   ")
#' @importFrom stringr str_to_upper str_replace_all str_squish
#' @family geographic normalization functions
#' @export
str_normal <- function(x, case = TRUE, punct = "", quote = TRUE, squish = TRUE) {
  if (case) {
    x <- stringr::str_to_upper(x)
  }
  if (is.character(punct)) {
    x <- stringr::str_replace_all(x, "[[[:punct:]]-[#/]]", punct)
  }
  if (quote) {
    x <- stringr::str_replace_all(x, "\"", "\'")
  }
  if (squish) {
    x <- stringr::str_squish(x)
  }
  return(x)
}

