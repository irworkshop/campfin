#' Normalize city names
#'
#' Return consistent version of a city names using `stringr::str_*()` functions.
#' Letters are capitalized, hyphens and underscores are replaced with
#' whitespace, other punctuation is removed, numbers are removed, and excess
#' whitespace is trimed and squished. Optionally, geographic abbreviations
#' ("MT") can be replaced with their long form ("MOUNT"). Invalid addresses from
#' a vector can be removed (possibly using [invalid_city]) as well as single
#' (repeating) character strings ("XXXXXX").
#'
#' @param city A vector of city names.
#' @param abbs A named vector or data frame of abbreviations passed to
#'   [expand_abbrev]; see [expand_abbrev] for format of `abb` argument or use
#'   the [usps_city] tibble.
#' @param na A vector of values to make `NA` (useful with the [invalid_city]
#'   vector).
#' @param na_rep logical; If `TRUE`, replace all single digit (repeating)
#'   strings with `NA`.
#' @return A vector of normalized city names.
#' @examples
#' normal_city(
#'   city = c("Stowe, VT", "N/A", "Burlington", "ST JOHNSBURY", "XXXXXXXXX"),
#'   geo_abbs = c("ST" = "SAINT"),
#'   st_abbs = c("VT"),
#'   na = c("", "NA", "UNKNOWN"),
#'   na_rep = TRUE
#' )
#' @importFrom stringr str_to_upper str_replace_all str_remove_all str_trim
#'   str_squish str_c str_replace str_remove str_which
#' @importFrom dplyr na_if
#' @importFrom tibble tibble
#' @family geographic normalization functions
#' @export
normal_city <- function(city, abbs = NULL, na = c("", "NA"), na_rep = FALSE) {
  city2 <- city %>%
    str_normal() %>%
    stringr::str_remove_all("\\d+")
  if (!is.null(abbs)) {
    city2 <- expand_abbrev(x = city2, abb = abbs)
  }
  if (na_rep) {
    city2 <- na_rep(city2)
  }
  if (!rlang::is_empty(na)) {
    city2 <- na_in(city2, na)
  }
  city2
}


