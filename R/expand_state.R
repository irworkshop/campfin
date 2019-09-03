#' @title Abbreviate US State Names
#' @description This function is used to first normalize a `abb` state name and
#'   then return any matching abbreviation. This package works for all state
#'   names in `state.name` plus 12 additional territories (e.g., "Puerto Rico").
#' @param abb A full US state name character vector (e.g., "Vermont").
#' @param na_bad logical; Whether to return `NA` for invalid `abb` names
#'   (default `FALSE`).
#' @param rm_nums logical; Whether to remove numbers from `abb` (e.g., 1st)
#'   before abbreviating. Particularly useful with US Congressional districts.
#'   Only numbers 1 through 20 are supported at this time (default `FALSE`).
#' @return A vector of 2 letter state abbreviations.
#' @importFrom stringr str_to_upper str_trim str_squish str_replace_all str_remove_all
#' @examples
#' expand_state(abb = state.abb)
#' expand_state(abb = c("NM", "FR"), na_bad = TRUE)
#' expand_state(abb = "NE03", rm_nums = TRUE)
#' @family geographic normalization functions
#' @seealso abbrev_state is_abbrev normal_state normal_zip normal_city
#' @export
expand_state <- function(abb, na_bad = FALSE, rm_nums = FALSE) {
  if (!is.character(abb)) {
    stop("Full state name must be a character vector")
  }
  abb <- stringr::str_to_upper(abb)
  abb <- stringr::str_replace(abb, "[:punct:]", " ")
  if (rm_nums) {
    for (pattern in c("1ST", "2ND", "3RD", stringr::str_c(1:19, "TH"))) {
      abb <- stringr::str_remove(abb, pattern)
    }
    abb <- stringr::str_remove_all(abb, "\\d+")
  }
  abb <- stringr::str_trim(abb)
  abb <- stringr::str_squish(abb)
  if (na_bad) {
    abb[which(abb %out% valid_state & abb %out% valid_name)] <- NA
  }
  abb_match <- match(abb[which(abb %in% valid_state)], valid_state)
  abb[which(abb %in% valid_state)] <- valid_name[abb_match]
  return(abb)
}
