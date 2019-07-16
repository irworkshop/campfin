#' Normalize US State Abbreviations
#'
#' @param state A vector of US state names or abbreviations.
#' @param abbreviate If TRUE (default), replace state names with the 2-digit abbreviation using the built-in `state.abb` and `state.name` vectors.
#' @param na A vector of values to make `NA`.
#' @param na_rep If `TRUE`, make all single digit repeating strings `NA` (removes valid "AA" code for "American Armed Forces").
#' @param valid A vector of valid abbreviations to compare to and remove invalid.
#' @return A vector of normalized 2-digit state abbreviations.
#' @import stringr
#' @importFrom tibble tibble

normal_state <- function(state, abbreviate = TRUE, na = c(""), na_rep = FALSE, valid = NULL) {

  state2 <- state

  if (abbreviate) {
    states_df <- tibble(
      name = str_to_upper(c(datasets::state.name, "District of Columbia")),
      abb = c(datasets::state.abb, "DC")
    )
    for (i in seq_along(states_df$name)) {
      state2 <- str_replace(
        string = state2,
        pattern = states_df$name[i],
        replacement = states_df$abb[i]
      )
    }
  }

  state2 <- state2 %>%
    str_to_upper() %>%
    str_remove("[^A-z]") %>%
    str_trim()


  if (!is.null(valid)) {
    state2[!(state2 %in% valid)] <- NA
  }

  if (na_rep) {
    state2[str_which(state2, "^(.)\\1+$")] <- NA
  }

  state2[which(state2 %in% na)] <- NA

  return(state2)
}
