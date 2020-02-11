#' Normalize city names
#'
#' Return consistent version of a city names using `stringr::str_*()` functions.
#' Letters are capitalized, hyphens and underscores are replaced with
#' whitespace, other punctuation is removed, numbers are removed, and excess
#' whitespace is trimmed and squished. Optionally, geographic abbreviations
#' ("MT") can be replaced with their long form ("MOUNT"). Invalid addresses from
#' a vector can be removed (possibly using [invalid_city]) as well as single
#' (repeating) character strings ("XXXXXX").
#'
#' @param city A vector of city names.
#' @param abbs A named vector or data frame of abbreviations passed to
#'   [expand_abbrev]; see [expand_abbrev] for format of `abb` argument or use
#'   the [usps_city] tibble.
#' @param states A vector of state abbreviations ("VT") to remove from the
#'   _end_ (and only end) of city names ("STOWE VT").
#' @param na A vector of values to make `NA` (useful with the [invalid_city]
#'   vector).
#' @param na_rep logical; If `TRUE`, replace all single digit (repeating)
#'   strings with `NA`.
#' @return A vector of normalized city names.
#' @examples
#' normal_city(
#'   city = c("Stowe, VT", "UNKNOWN CITY", "Burlington", "ST JOHNSBURY", "XXX"),
#'   abbs = c("ST" = "SAINT"),
#'   states = "VT",
#'   na = invalid_city,
#'   na_rep = TRUE
#' )
#' @importFrom stringr str_remove_all str_remove
#' @importFrom dplyr na_if
#' @family geographic normalization functions
#' @export
normal_city <- function(city, abbs = NULL, states = NULL, na = c("", "NA"), na_rep = FALSE) {
  city2 <- stringr::str_remove_all(str_normal(city), "\\d+")
  if (!is.null(states)) {
    for (i in seq_along(states)) {
      city2 <- stringr::str_remove(city2, glue::glue("\\s{states[i]}$"))
    }
  }
  if (na_rep) {
    city2 <- na_rep(city2)
  }
  if (!rlang::is_empty(na)) {
    city2 <- na_in(city2, na)
  }
  if (!is.null(abbs)) {
    city2 <- str_normal(expand_abbrev(x = city2, abb = abbs))
  }
  city2
}


