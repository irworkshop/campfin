#' @title Normalize Street Addresses
#' @description Return consistent version of a US Street Address using
#'   `stringr::str_*()` functions. Letters are capitalized, hyphens and
#'   underscores are replaced with whitespaces, other punctuation is removed,
#'   and excess whitespace is trimed and squished. Optionally, street suffix
#'   abbreviations ("AVE") can be replaced with their long form ("AVENUE").
#'   Invalid addresses from a vector can be removed (possibly using
#'   [invalid_city]) as well as single (repeating) character strings ("XXXXXX").
#' @param address A vector of street addresses (ideally without city, state, and
#'   ZIP code; you can use the [rx_state] and [rx_city] regular expression
#'   patterns to remove the later two).
#' @param add_abbs A two-column data frame like [usps_street], with a full
#'   suffix ("STREET") in the first column and abbreviations ("ST") in the
#'   second. Replace all abbreviations with their full version.
#' @param na A vector of values to make `NA` (like [invalid_city]).
#' @param na_rep logical; If `TRUE`, replace all single digit (repeating)
#'   strings with `NA`.
#' @return A vector of normalized street addresses.
#' @importFrom stringr str_to_upper str_replace_all str_trim str_squish str_replace
#' @export
normal_address <- function(
  address,
  add_abbs = NULL,
  na = c("", "NA"),
  na_rep = FALSE
) {

  address2 <- address %>%
    stringr::str_to_upper() %>%
    stringr::str_replace_all("-", " ") %>%
    stringr::str_replace_all("_", " ") %>%
    stringr::str_remove_all("[[:punct:]]") %>%
    stringr::str_trim() %>%
    stringr::str_squish() %>%
    stringr::str_replace_all("P\\sO", "PO")

  if (!is.null(add_abbs)) {
    add_abbs <- as.data.frame(add_abbs)
    for (i in seq_along(add_abbs[, 1])) {
      address2 <- stringr::str_replace(
        string = address2,
        pattern = str_c("\\b", add_abbs[i, 1], "\\b"),
        replacement = add_abbs[i, 2]
      )
    }
  }

  if (na_rep) {
    address2[stringr::str_which(address2, "^(.)\\1+$")] <- NA
  }

  address2[which(address2 %in% na)] <- NA

  return(address2)
}
