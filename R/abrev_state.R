#' AbbreviateUS State Names
#'
#' @param state A vector of full state names
#' @return A vector of 2 letter state abbreviations
#' @importFrom stringr str_to_upper str_trim str_squish str_replace_all str_remove_all
#' @examples
#' abrev_state(c("Vermont", "District of Columbia", "France", "Maine 2nd"), rm_nums = TRUE)
#' @export
abrev_state <- function(state, rm_nums = FALSE) {
  state <- stringr::str_to_upper(state)
  if (rm_nums) {
    for (pattern in c("1ST", "2ND", "3RD", stringr::str_c(1:19, "TH"))) {
      state <- stringr::str_remove(state, pattern)
    }
    state <- stringr::str_remove_all(state, "\\d+")
  }
  state <- stringr::str_trim(state)
  state <- stringr::str_squish(state)
  abb   <- stringr::str_to_upper(c(state.abb, "DC"))
  name  <- stringr::str_to_upper(c(state.name, "District of Columbia"))
  state[which(state %in% name)] <- abb[match(state[which(state %in% name)], name)]
  return(state)
}

