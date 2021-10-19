#' Normalize US State Abbreviations
#'
#' Return consistent version of a state _abbreviations_ using `stringr::str_*()`
#' functions. Letters are capitalized, all non-letters characters are removed,
#' and excess whitespace is trimmed and squished, and then [abbrev_full()] is
#' called with [usps_state].
#'
#' @param state A vector of US state names or abbreviations.
#' @param abbreviate If TRUE (default), replace state names with the 2-digit
#'   abbreviation using the built-in `state.abb` and `state.name` vectors.
#' @param na A vector of values to make `NA`.
#' @param na_rep logical; If `TRUE`, make all single digit repeating strings
#'   `NA` (removes valid "AA" code for "American Armed Forces").
#' @param valid A vector of valid abbreviations to compare to and remove those
#'   not shared.
#' @return A vector of normalized 2-digit state abbreviations.
#' @examples
#' normal_state(
#'   state = c("VT", "N/A", "Vermont", "XX", "ZA"),
#'   abbreviate = TRUE,
#'   na = c("", "NA"),
#'   na_rep = TRUE,
#'   valid = NULL
#' )
#' @importFrom stringr str_to_upper str_remove_all str_trim str_which
#' @importFrom tibble tibble
#' @family geographic normalization functions
#' @export
normal_state <- function(state, abbreviate = TRUE, na = c("", "NA"), na_rep = FALSE, valid = NULL) {
  state <- state %>%
    stringr::str_to_upper() %>%
    stringr::str_remove_all("[^A-z\\s]") %>%
    stringr::str_trim()
  if (abbreviate) {
    state <- abbrev_state(state)
  }
  if (na_rep) {
    is_aa <- state != "AA" & !is.na(state)
    state[is_aa] <- na_rep(state[is_aa])
  }
  if (length(na) > 0 & is.character(na)) {
    state[which(state %in% stringr::str_to_upper(na))] <- NA
  }
  if (!is.null(valid)) {
    state[!(state %in% valid)] <- NA
  }
  return(state)
}
