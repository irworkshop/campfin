#' AbbreviateUS State Names
#'
#' @param state A vector of full state names
#' @return A vector of 2 letter state abbreviations
#' @importFrom stringr str_to_upper str_trim str_squish str_replace_all str_remove_all
#' @examples
#' abrev_state(c("Vermont", "District of Columbia", "new_hampshire", "VT"))
#' @export
abrev_state <- function(state) {
  state <- stringr::str_to_upper(state)
  state <- stringr::str_replace_all(state, "[:punct:]", " ")
  state <- stringr::str_remove_all(state, "\\d+")
  state <- stringr::str_trim(state)
  state <- stringr::str_squish(state)
  abb   <- stringr::str_to_upper(c(state.abb, "DC"))
  name  <- stringr::str_to_upper(c(state.name, "District of Columbia"))
  state[which(state %out% abb)] <- abb[match(state[which(state %out% abb)], name)]
  return(state)
}
