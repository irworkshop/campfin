#' @title Normalize US ZIP Codes
#' @description Return consistent version US ZIP codes using `stringr::str_*()`
#'   functions. Non-number characters are removed, strings are padded with
#'   zeroes on the left (leading zeroes for New England ZIP codes are often
#'   removed by Microsoft Excel and other progrmas), and ZIP+4 suffixes are
#'   removed. Invalid ZIP codes from a vector can be removed as well as single
#'   (repeating) character strings.
#' @details From [Wikipedia](https://en.wikipedia.org/wiki/ZIP_Code#ZIP+4):
#'   > In 1983, the U.S. Postal Service introduced an expanded ZIP Code system
#'   that it called ZIP+4, often called "plus-four codes", "add-on codes", or
#'   "add-ons". A ZIP+4 Code uses the basic five-digit code plus four additional
#'   digits to identify a geographic segment within the five-digit delivery
#'   area, such as a city block, a group of apartments, an individual
#'   high-volume receiver of mail, a post office box, or any other unit that
#'   could use an extra identifier to aid in efficient mail sorting and
#'   delivery. However, initial attempts to promote universal use of the new
#'   format met with public resistance and today the plus-four code is not
#'   required.
#' @param zip A vector of US ZIP codes.
#' @param na A vector of values to replace with `NA`.
#' @param na_rep logical; If `TRUE`, make all single digit repeating strings
#'   (e.g., "00000", "99999") `NA`. The valid ZIP codes "22222", "44444", and
#'   "55555" are not removed.
#' @return A vector of normalized 5-digit ZIP codes.
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

  if (na_rep) {
    zip[zip %>% str_which("^(.)\\1+[^22222|44444|55555]$")] <- NA
  }

  zip[which(zip %in% stringr::str_to_upper(na))] <- NA

  zip <- zip %>%
    str_remove_all("\\D") %>%
    na_if("") %>%
    str_pad(width = 5, side = "left", pad = "0") %>%
    str_sub(start = 1, end = 5)

  return(zip)
}
