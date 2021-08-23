#' Normalize street addresses
#'
#' Return consistent version of a US Street Address using `stringr::str_*()`
#' functions. Letters are capitalized, punctuation is removed or replaced, and
#' excess whitespace is trimmed and squished. Optionally, street suffix
#' abbreviations ("AVE") can be replaced with their long form ("AVENUE").
#' Invalid addresses from a vector can be removed (possibly using
#' [invalid_city]) as well as single (repeating) character strings ("XXXXXX").
#'
#' @param address A vector of street addresses (ideally without city, state, or
#'   postal code).
#' @param abbs A named vector or two-column data frame (like [usps_street])
#'   passed to [expand_abbrev()]. See `?expand_abbrev` for the type of object
#'   structure needed.
#' @param na A character vector of values to make `NA` (like [invalid_city]).
#' @param na_rep logical; If `TRUE`, replace all single digit (repeating)
#'   strings with `NA`.
#' @return A vector of normalized street addresses.
#' @examples
#' normal_address("P.O. 123, C/O John Smith", abbs = usps_street)
#' normal_address("12east 2nd street, suite209", abbs = usps_street)
#' @importFrom stringr str_to_upper str_replace_all str_trim str_squish str_replace
#' @family geographic normalization functions
#' @export
normal_address <- function(address, abbs = NULL, na = c("", "NA"), na_rep = FALSE) {
  address2 <- address %>%
    stringr::str_remove_all("(?<=(^|\\.|\\s)\\w)\\.") %>%
    str_normal() %>%
    stringr::str_replace_all("^P\\sO", "PO") %>%
    stringr::str_replace_all("(?<=^|\\s)C\\sO(?=\\s|$)", "C/O") %>%
    stringr::str_replace_all("^([:digit:]+)([:alpha:]+)", "\\1 \\2") %>%
    stringr::str_replace_all("([:alpha:]+)([:digit:]+)$", "\\1 \\2")
  if (!is.null(abbs)) {
    address2 <- abbrev_full(x = address2, full = abbs, end = TRUE)
  }
  if (na_rep) {
    address2 <- na_rep(address2)
  }
  if (!rlang::is_empty(na)) {
    address2 <- na_in(address2, na)
  }
  address2
}
