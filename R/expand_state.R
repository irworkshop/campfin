#' Expand US State Abbreviations
#'
#' @description This function is used to first normalize a `abb` state abbreviation and then return
#' any matching name It relies on [datasets::state.abb] and [datasets::state.name]
#' (supplement with "DC" and "District of Columbia" respectively). Other US territories besides
#' these 51 are not yet included, although their abbreviations are in the [geo] and [valid_state]
#' objects.
#' @aliases expand_abb expand_abbreviation
#' @param abb A 2 digit US state abbreviation character vector (e.g., "VT").
#' @param na_bad logical; Whether to return `NA` for invalid `abb` (default `FALSE`).
#' @param rm_nums Whether to remove numbers from `abb` (e.g., 1st) before abbreviating.
#' Particularly useful with US Congressional districts. Only numbers 1 through 20 are supported at
#' this time (default `FALSE`).
#' @return A vector of full state names.
#' @importFrom stringr str_to_upper str_trim str_squish str_replace_all str_remove_all
#' @examples
#' expand_state(abb = state.abb)
#' expand_state(abb = c("VT", "DC", "FR"), na_bad = TRUE)
#' @family geographic normalization functions
#' @seealso abbrev_state is_abbrev normal_state normal_zip normal_city
#' @export
expand_state <- function(abb, na_bad = FALSE, rm_nums = FALSE) {
  valid_abb   <- c(datasets::state.abb, "DC")
  valid_name  <- stringr::str_to_upper(c(datasets::state.name, "District of Columbia"))

  abb <- stringr::str_to_upper(abb)
  abb <- stringr::str_trim(abb)
  abb <- stringr::str_squish(abb)

  if (rm_nums) {
    for (pattern in c("1ST", "2ND", "3RD", stringr::str_c(1:19, "TH"))) {
      abb <- stringr::str_remove(abb, pattern)
    }
    abb <- stringr::str_remove_all(abb, "\\d+")
  }

  if (na_bad) {
    abb[which(abb %out% valid_abb & abb %out% valid_name)] <- NA
  }

  full_match <- match(abb[which(abb %in% valid_abb)], valid_abb)
  abb[which(abb %in% valid_abb)] <- valid_name[full_match]
  return(abb)
}
