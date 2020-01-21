#' Normalize a character string
#'
#' @description
#' The generic normalization that underpins functions like [normal_city()] and
#' [normal_address()]. This function simply chains together three
#' `stringr::str_*()` functions:
#'   1. Convert to uppercase.
#'   2. Replace punctutations with whitespaces.
#'   4. Trim and squish excess whitespace.
#'
#' @param x A character string to normalize.
#' @param case logical; whether [stringr::str_to_upper()] should be called.
#' @param punct logical; whether [stringr::str_replace_all()] should be called on puctuation.
#' @param quote logical; whether [stringr::str_replace_all()] should be called on double quotes.
#' @param trim logical; whether [stringr::str_trim()] should be called.
#' @param squish logical; whether [stringr::str_squish()] should be called.
#' @return A normalized vector of the same length.
#' @examples
#' str_normal("   TestING 123   example_test.String   ")
#' @importFrom stringr str_to_upper str_replace_all str_trim str_squish
#' @family geographic normalization functions
#' @export
str_normal <- function(x, case = TRUE, punct = TRUE, quote = TRUE, trim = TRUE, squish = TRUE) {
  if (case) {
    x <- stringr::str_to_upper(x)
  }
  if (punct) {
    x <- stringr::str_replace_all(x, "[[:punct:]]", " ")
  }
  if (quote) {
    x <- stringr::str_replace_all(x, "\"", "\'")
  }
  if (trim) {
    x <- stringr::str_trim(x)
  }
  if (squish) {
    x <- stringr::str_squish(x)
  }
  return(x)
}

