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
  abb  <- stringr::str_split(stringr::str_to_lower(abb),  "")[[1]]
  full <- stringr::str_split(stringr::str_to_lower(full), "")[[1]]
  if (length(abb) >= length(full)) {
    return(FALSE)
  } else {
    if (abb[[1]] != full[[1]]) {
      return(FALSE)
    } else {
      inside <- all(abb %in% full)
      order <- match(abb, full)
      ordered <- all(order < dplyr::lead(order), na.rm = TRUE)
      return(all(inside, ordered))
    }
  }
}
