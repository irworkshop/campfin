#' Normalize ZIP codes
#'
#' Return consistent version US ZIP codes using `stringr::str_*()` functions.
#' Non-number characters are removed, strings are padded with zeroes on the
#' left, and ZIP+4 suffixes are removed. Invalid ZIP codes from a vector can be
#' removed as well as single (repeating) character strings.
#'
#' @param zip A vector of US ZIP codes.
#' @param na A vector of values to pass to [na_in()].
#' @param na_rep logical; If `TRUE`, [na_rep()] will be called. Please note that
#'   22222, 44444, and 55555 valid ZIP codes that will _not_ be removed.
#' @param pad logical; Should ZIP codes less than five digits be padded with a
#'   leading zero? Leading zeros (as are found in New England ZIP codes) are
#'   often dropped by programs like Microsoft Excel when parsed as numeric
#'   values.
#' @return A _character_ vector of normalized 5-digit ZIP codes.
#' @examples
#' normal_zip(
#'   zip = c("05672-5563", "N/A", "05401", "5819", "00000"),
#'   na = c("", "NA"),
#'   na_rep = TRUE,
#'   pad = TRUE
#' )
#' @importFrom stringr str_remove_all str_pad str_sub str_which
#' @family geographic normalization functions
#' @export
normal_zip <- function(zip, na = c("", "NA"), na_rep = FALSE, pad = FALSE) {
  zip <- zip <- stringr::str_remove_all(zip, "\\D")
  zip[which(zip == "")] <- NA
  if (isTRUE(pad)) {
    zip <- stringr::str_pad(zip, width = 5, side = "left", pad = "0")
  }
  zip <- stringr::str_sub(zip, start = 1, end = 5)
  good_rep <- c("22222", "44444", "55555")
  if (isTRUE(na_rep)) {
    zip.rm <- which(zip %out% good_rep)
    zip[zip.rm] <- na_rep(zip[zip.rm])
  }
  if (!is.null(na)) {
    zip <- na_in(zip, na)
  }
  return(zip)
}
