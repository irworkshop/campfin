#' Abbreviate US state names
#'
#' This function is used to first normalize a `full` state name and then call
#' [abbrev_state()] using [valid_name] and [valid_state] as the `full` and `rep`
#' arguments.
#'
#' @param full A full US state name character vector (e.g., "Vermont").
#' @return The 2-letter USPS abbreviation of for state names (e.g., "VT").
#' @importFrom stringr str_trim str_squish str_remove_all str_to_upper
#' @examples
#' abbrev_state(full = state.name)
#' abbrev_state(full = c("new mexico", "france"))
#' @family geographic normalization functions
#' @export
abbrev_state <- function(full) {
  if (!is.character(full)) {
    stop("full state name must be a character vector")
  }
  full <- full %>%
    str_trim() %>%
    str_squish() %>%
    str_remove_all("^A-z") %>%
    str_to_upper()
  abbrev_full(x = full, full = campfin::valid_name, rep = campfin::valid_state)
}
