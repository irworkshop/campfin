#' Normalize US State Abbreviations
#'
#' @param state A vector of US state names or abbreviations.
#' @param abbreviate If TRUE (default), replace state names with the 2-digit abbreviation using the built-in `state.abb` and `state.name` vectors.
#' @param na A vector of values to make `NA`.
#' @param na_rep If `TRUE`, make all single digit repeating strings `NA` (removes valid "AA" code for "American Armed Forces").
#' @param valid A vector of valid abbreviations to compare to and remove invalid.
#' @return A vector of normalized 2-digit state abbreviations.
#' @examples
#' normal_state(
#'   state = c("VT", "N/A", "Vermont", "XX", "ZA"),
#'   abbreviate = TRUE,
#'   na = c("", "NA"),
#'   na_rep = TRUE,
#'   valid = NULL
#' )
#' @import stringr
#' @importFrom tibble tibble
#' @export
normal_state <- function(state, abbreviate = TRUE, na = c("", "NA"), na_rep = FALSE, valid = NULL) {

  state2 <- state %>%
    str_to_upper() %>%
    str_remove_all("[^A-z\\s]") %>%
    str_trim()

  if (abbreviate) {
    state2 <- abbrev_state(state2)
  }

  if (na_rep) {
    state2[str_which(state2, "^(.)\\1+$")] <- NA
  }

  state2[which(state2 %in% na)] <- NA

  if (!is.null(valid)) {
    state2[!(state2 %in% valid)] <- NA
  }

  return(state2)
}
