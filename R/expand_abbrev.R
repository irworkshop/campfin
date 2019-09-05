#' @title Expand Abbreviations
#' @description Create or use a named vector (`c(abb = rep)`) and pass it to
#' [stringr::str_replace_all()]
#' @param city A vector of city names.
#' @param geo_abbs A two-column data frame like [usps_city], with a full
#'   geographic feature ("LAKE") in the first column and abbreviations ("LK")
#'   in the second. Replace all abbreviations with their full version.
#' @param st_abbs A vector of state abbreviations ("VT") to remove from the
#'   _end_ (and only end) of city names ("STOWE VT").
#' @param na A vector of values to make `NA` (useful with the [invalid_city]
#'   vector).
#' @param na_rep logical; If `TRUE`, replace all single digit (repeating)
#'   strings with `NA`.
#' @return A vector of normalized city names.
#' @examples
#' expand_abbrev(x = "MT VERNON", abb = c("MT" = "MOUNT"))
#' @importFrom stringr str_to_upper str_replace_all str_remove_all str_trim
#'   str_squish str_c str_replace str_remove str_which
#' @importFrom dplyr na_if
#' @importFrom tibble tibble
#' @export
expand_abbrev <- function(x, abb = NULL, rep = NULL) {
  if (is.data.frame(abb)) {
    abb <- tibble::deframe(abb)
  } else {
    if (is.null(names(abb))) {
      if (is.null(rep)) {
        stop("if abbs are not named, need rep")
      } else {
        names(abb) <- rep
      }
    }
  }
  names(abb) <- sprintf("\\b%s\\b", names(abb))
  str_replace_all(x, abb)
}
