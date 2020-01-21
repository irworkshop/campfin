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
#' @return A normalized vector of the same length.
#' @examples
#' str_normal("   TestING 123   example_test.String   ")
#' @importFrom stringr str_to_upper str_replace_all str_trim str_squish
#' @family geographic normalization functions
#' @export
str_normal <- function(x) {
  x %>%
    stringr::str_to_upper() %>%
    stringr::str_replace_all("[[:punct:]]", " ") %>%
    stringr::str_replace_all("\"", "\'") %>%
    stringr::str_trim() %>%
    stringr::str_squish()
}
