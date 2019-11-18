#' Check if abbreviation
#'
#' To return a value of `TRUE`, (1) the first letter of `abb` must match the
#' first letter of `full`, (2) _all_ letters of `abb` must exist in `full`, and
#' (3) those letters of `abb` must be in the same order as they appear in
#' `full`.
#'
#' @param abb A suspected abbreviation
#' @param full A long form string to test against
#' @return logical; whether `abb` is potential abbreviation of `full`
#' @importFrom stringr str_split str_to_lower
#' @importFrom dplyr lead na_if
#' @examples
#' is_abbrev(abb = "BRX", full = "BRONX")
#' is_abbrev(abb = state.abb, full = state.name)
#' is_abbrev(abb = "NOLA", full = "New Orleans")
#' is_abbrev(abb = "FE", full = "Iron")
#' @export
is_abbrev <- function(abb, full) {
  abb <- dplyr::na_if(abb, "")
  full <- dplyr::na_if(full, "")
  abb <- stringr::str_split(stringr::str_to_lower(abb), "")
  full <- stringr::str_split(stringr::str_to_lower(full), "")
  length_check <- function(abb, full) {
    if (length(full) <= 4) {
      length(full) - length(abb) >= 1
    } else {
      length(full) - length(abb) >= 2
    }
  }
  short  <- purrr::map2_lgl(abb, full, length_check)
  first  <- purrr::map2_lgl(abb, full, function(x, y) x[[1]] == y[[1]])
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


