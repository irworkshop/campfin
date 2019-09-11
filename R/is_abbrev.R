#' @title Check if Abbreviation
#' @description To return a value of `TRUE`, (1) the first letter of `abb` must
#'   match the first letter of `full`, (2) _all_ letters of `abb` must exist in
#'   `full`, and (3) those letters of `abb` must be in the same order as they
#'   appear in `full`.
#' @param abb A suspected abbreviation
#' @param full A long form string to test against
#' @return logical; whether `abb` is potential abbreviation of `full`
#' @importFrom stringr str_split str_to_lower
#' @importFrom dplyr lead
#' @examples
#' is_abbrev(abb = "BRX", full = "BRONX")
#' is_abbrev(abb = state.abb, full = state.name)
#' is_abbrev(abb = "NOLA", full = "New Orleans")
#' @export
is_abbrev <- function(abb, full) {
  abb <- stringr::str_split(stringr::str_to_lower(abb), "")
  full <- stringr::str_split(stringr::str_to_lower(full), "")
  short  <- purrr::map2_lgl(abb, full, function(abb, full) length(full) - length(abb) > 2)
  first  <- purrr::map2_lgl(abb, full, function(abb, full) abb[[1]] == full[[1]])
  ordered_match <- function(abb, full) {
    j <- rep(NA, length(abb))
    for (i in seq_along(abb)) {
      j[i] <- match(abb[i], full, nomatch = 0)
      full[1:j[i]] <- ""
    }
    all(diff(j) >= 0)
  }
  order  <- purrr::map2_lgl(abb, full, ordered_match)
  short & first & order
}
