#' AbbreviateUS State Names
#'
#' @param state A vector of full state names
#' @return A vector of 2 letter state abbreviations
#' @importFrom stringr str_to_upper
#' @example
#' abrev_state(c("Vermont", "District of Columbia"))
#' @export
abrev_state <- function(state) {
  state <- stringr::str_to_upper(state)
  state <- stringr::str_remove_all(state, "[:punct:]")
  state <- stringr::str_remove_all(state, "\\d+")
  state <- stringr::trim(state)
  state <- stringr::squish(state)
  abb   <- stringr::str_to_upper(c(state.abb, "DC"))
  name  <- stringr::str_to_upper(c(state.name, "District of Columbia"))
  abb[match(state, name)]
}
