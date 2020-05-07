#' @title Expand Abbreviations
#' @description Create or use a named vector (`c("abb" = "rep")`) and pass it to
#'   [stringr::str_replace_all()]. The `abb` argument is surrounded with `\\b`
#'   to capture only isolated abbreviations. To be used inside
#'   [normal_address()] and [normal_city()] with [usps_street] and [usps_city],
#'   respectively.
#' @param x A vector containing abbreviations.
#' @param abb One of three objects: (1) A dataframe with abbreviations in the
#'   _first_ column and corresponding replacement strings in the _second_
#'   column; (2) a _named_ vector, with abbreviations as names for their
#'   respective replacements (e.g., `c("abb" = "rep")`); or (3) an unnamed
#'   vector of abbreviations with an unnamed vector of replacements in the `rep`
#'   argument.
#' @param rep If `abb` is an unnamed vector, a vector of replacement strings for
#'   each abbreviation in `abb`.
#' @return The vector `x` with abbreviation replaced with their full version.
#' @examples
#' expand_abbrev(x = "MT VERNON", abb = c("MT" = "MOUNT"))
#' expand_abbrev(x = "VT", abb = state.abb, rep = state.name)
#' expand_abbrev(x = "Low FE Level", abb = tibble::tibble(x = "FE", y = "Iron"))
#' @importFrom stringr str_replace_all
#' @importFrom tibble deframe
#' @family geographic normalization functions
#' @export
expand_abbrev <- function(x, abb = NULL, rep = NULL) {
  if (is.data.frame(abb)) {
    abb <- tibble::deframe(abb)
  } else {
    if (is.null(names(abb))) {
      if (is.null(rep)) {
        stop("if abbs are not named, need rep")
      } else {
        if (length(abb) == length(rep)) {
          names(rep) <- abb
          abb <- rep
        } else {
          stop("abb and rep must be of the same length")
        }
      }
    }
  }
  names(abb) <- sprintf("\\b%s\\b", names(abb))
  stringr::str_replace_all(string = x, pattern = abb)
}

#' Expand US state names
#'
#' This function is used to first normalize an `abb` and then call
#' [expand_abbrev()] using [valid_state] and [valid_name] as the `abb` and `rep`
#' arguments.
#'
#' @param abb A abb US state name character vector (e.g., "Vermont").
#' @return The 2-letter USPS abbreviation of for state names (e.g., "VT").
#' @importFrom stringr str_trim str_squish str_remove_all str_to_upper
#' @examples
#' expand_state(abb = state.abb)
#' expand_state(abb = c("nm", "fr"))
#' @family geographic normalization functions
#' @export
expand_state <- function(abb) {
  if (!is.character(abb)) {
    stop("abbreviated state name must be a character vector")
  }
  abb <- abb %>%
    str_squish() %>%
    str_remove_all("^A-z") %>%
    str_to_upper()
  expand_abbrev(x = abb, campfin::valid_state, campfin::valid_name)
}
