#' Normalize ZIP codes
#'
#' Return consistent version US ZIP codes using `stringr::str_*()` functions.
#' Non-number characters are removed, strings are padded with zeroes on the left
#' (leading zeroes for New England ZIP codes are often removed by Microsoft
#' Excel and other programs), and ZIP+4 suffixes are removed. Invalid ZIP codes
#' from a vector can be removed as well as single (repeating) character strings.
#'
#' @param zip A vector of US ZIP codes.
#' @param na A vector of values to pass to [na_in()].
#' @param na_rep logical; If `TRUE`, [na_rep()] will be called. Please note that
#'   22222, 44444, and 55555 are rare but valid ZIP codes that will be removed.
#' @return A _character_ vector of normalized 5-digit ZIP codes.
#' @examples
#' normal_zip(
#'   zip = c("05672-5563", "N/A", "05401", "5819", "00000"),
#'   na = c("", "NA"),
#'   na_rep = TRUE
#' )
#' @importFrom stringr str_remove_all str_pad str_sub str_which
#' @family geographic normalization functions
#' @export
normal_zip <- function(zip, na = c("", "NA"), na_rep = FALSE) {
  zip <- zip %>%
    stringr::str_remove_all("\\D") %>%
    dplyr::na_if("") %>%
    stringr::str_pad(width = 5, side = "left", pad = "0") %>%
    stringr::str_sub(start = 1, end = 5)
  if (na_rep) {
    zip <- na_rep(zip)
  }
  if (!is.null(na)) {
    zip <- na_in(zip, na)
  }
}
