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
#' @param punct A character value with which to replace all punctuation.
#' @param na_rep logical; If `TRUE`, replace all single digit (repeating)
#'   strings with `NA`.
#' @param abb_end logical; Should only the last word the string be abbreviated
#'   with the `abbs` argument? Passed to the `end` argument of [str_normal()].
#' @return A vector of normalized street addresses.
#' @examples
#' normal_address("P.O. #123, C/O John Smith", abbs = usps_street)
#' normal_address("12east 2nd street, #209", abbs = usps_street, abb_end = FALSE)
#' @importFrom stringr str_to_upper str_replace_all str_trim str_squish
#'    str_replace
#' @family geographic normalization functions
#' @export
normal_address <- function(address, abbs = NULL, na = c("", "NA"), punct = "",
                           na_rep = FALSE, abb_end = TRUE) {
  address <- address %>%
    stringr::str_remove_all("(?<=(^|\\.|\\s)\\w)\\.") %>%
    str_normal(punct = punct)
  if (!is.null(abbs)) {
    address <- abbrev_full(x = address, full = abbs, end = abb_end)
  }
  if (na_rep) {
    address <- na_rep(address)
  }
  if (!rlang::is_empty(na)) {
    address <- na_in(address, na)
  }
  address
}
