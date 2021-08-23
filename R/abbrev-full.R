#' Abbreviate full strings
#'
#' Create or use a named vector (`c("full" = "abb")`) and pass it to
#' [stringr::str_replace_all()]. The `full` argument is surrounded with `\\b` to
#' capture only isolated intended full versions. Note that the built-in
#' [usps_street], [usps_city], and [usps_state] dataframes have the columns
#' reversed from what this function needs (to work by default with the
#' counterpart [expand_abbrev()]).
#'
#' @param x A vector containing full words.
#' @param full One of three objects: (1) A dataframe with full strings in the
#'   _first_ column and corresponding abbreviations in the _second_
#'   column; (2) a _named_ vector, with full strings as names for their
#'   respective abbreviations (e.g., `c("full" = "abb")`); or (3) an unnamed
#'   vector of full words with an unnamed vector of abbreviations in the `rep`
#'   argument.
#' @param rep If `full` is an unnamed vector, a vector of abbreviations strings
#'   for each full word in `abb`.
#' @param end logical; if `TRUE`, then the `$` regular expression will be used
#'   to only replace words at the _end_ of a string (such as "ROAD" in a street
#'   address). If `FALSE` (default), then the `\b` regular expression will
#'   target _all_ instances of `full` to be replaced with `rep`.
#' @return The vector `x` with full words replaced with their abbreviations.
#' @examples
#' abbrev_full("MOUNT VERNON", full = c("MOUNT" = "MT"))
#' abbrev_full("123 MOUNTAIN ROAD", full = usps_street)
#' abbrev_full("123 MOUNTAIN ROAD", full = usps_street, end = TRUE)
#' abbrev_full("Vermont", full = state.name, rep = state.abb)
#' @importFrom stringr str_replace_all
#' @importFrom tibble deframe
#' @family geographic normalization functions
#' @export
abbrev_full <- function(x, full = NULL, rep = NULL, end = FALSE) {
  if (is.data.frame(full)) {
    full <- tibble::deframe(full)
  } else {
    if (is.null(names(full))) {
      if (is.null(rep)) {
        stop("if fulls are not named, need rep")
      } else {
        if (length(full) == length(rep)) {
          names(rep) <- full
          full <- rep
        } else {
          stop("full and rep must be of the same length")
        }
      }
    }
  }
  names(full) <- sprintf("\\b%s%s", names(full), ifelse(end, "$", "\\b"))
  stringr::str_replace_all(string = x, pattern = full)
}

#' Abbreviate US state names
#'
#' This function is used to first normalize a `full` state name and then call
#' [abbrev_full()] using [valid_name] and [valid_state] as the `full` and `rep`
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
    stringr::str_squish() %>%
    stringr::str_remove_all("^A-z") %>%
    stringr::str_to_upper()
  abbrev_full(full, campfin::valid_name, campfin::valid_state) %>%
    stringr::str_replace("^WEST VA$", "WV")
}
