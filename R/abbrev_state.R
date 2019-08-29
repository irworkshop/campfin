#' Abbreviate US State Names
#'
#' @description This function is used to first normalize a `full` state name and then return any
#' matching abbreviation. It relies on [datasets::state.name] and [datasets::state.abb]
#' (supplement with "District of Columbia" and "DC" respectively). Other US territories besides
#' these 51 are not yet included, although their abbreviations are in the [geo] and [valid_state]
#' objects.
#' @aliases abbreviate_state
#' @param full A full US state name character vector (e.g., "Vermont").
#' @param na_bad logical; Whether to return `NA` for invalid `full` names (default `FALSE`).
#' @param rm_nums Whether to remove numbers from `full` (e.g., 1st) before abbreviating.
#' Particularly useful with US Congressional districts. Only numbers 1 through 20 are supported at
#' this time (default `FALSE`).
#' @return A vector of 2 letter state abbreviations.
#' @importFrom stringr str_to_upper str_trim str_squish str_replace_all str_remove_all
#' @examples
#' abbrev_state(full = state.name)
#' abbrev_state(full = c("Vermont", "District of Columbia", "France"), na_bad = TRUE)
#' @family geographic normalization functions
#' @seealso abbrev_state is_abbrev normal_state normal_zip normal_city
#' @export
abbrev_state <- function(full, na_bad = FALSE, rm_nums = FALSE) {
  valid_abb   <- c(datasets::state.abb, "DC")
  valid_name  <- stringr::str_to_upper(c(datasets::state.name, "District of Columbia"))

  full <- stringr::str_to_upper(full)
  full <- stringr::str_trim(full)
  full <- stringr::str_squish(full)

  if (rm_nums) {
    for (pattern in c("1ST", "2ND", "3RD", stringr::str_c(1:19, "TH"))) {
      full <- stringr::str_remove(full, pattern)
    }
    full <- stringr::str_remove_all(full, "\\d+")
  }

  if (na_bad) {
    full[which(full %out% valid_name & full %out% valid_abb)] <- NA
  }

  abb_match <- match(full[which(full %in% valid_name)], valid_name)
  full[which(full %in% valid_name)] <- valid_abb[abb_match]
  return(full)
}
