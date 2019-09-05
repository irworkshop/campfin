#' @title Normalize US ZIP Codes
#' @param zip A vector of US ZIP codes.
#' @param na A vector of values to make `NA`.
#' @param na_rep If `TRUE`, make all single digit repeating strings (e.g.,
#'   "00000") `NA`. This removes the valid but uncommon "22222", "44444", and
#'   "55555".
#' @return A vector of normalized 5-digit ZIP codes.
#' @examples
#' normal_zip(
#'   zip = c("05672-5563", "N/A", "05401", "5819", "00000"),
#'   na = c("", "NA"),
#'   na_rep = TRUE
#' )
#' @importFrom stringr str_remove_all str_pad str_sub str_which
#' @export
normal_zip <- function(zip, na = c("", "NA"), na_rep = FALSE) {

  zip2 <- zip %>%
    as.character() %>%
    str_remove_all("\\D") %>%
    str_pad(width = 5, side = "left", pad = "0") %>%
    str_sub(start = 1, end = 5)

  if (na_rep) {
    zip2[zip2 %>% str_which("^(.)\\1+$")] <- NA
  }

  zip2[which(zip2 %in% na)] <- NA

  return(zip2)
}
