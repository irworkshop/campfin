#' Normalize US Street Addresses
#'
#' @param address A vector of street addresses
#' @param add_abbs An optional data frame of abbreviations and replacements
#' @param na A vector of values to make `NA`
#' @param na_rep If TRUE, make all single digit repeating strings `NA`
#' @return A vector of normalized street addresses
#' @import stringr

normal_address <- function(address, add_abbs = NULL, na = c(""), na_rep = FALSE) {

  address2 <- address %>%
    str_to_upper() %>%
    str_replace("-", " ") %>%
    str_remove_all("[[:punct:]]") %>%
    str_trim() %>%
    str_squish() %>%
    str_replace("P\\sO", "PO")

  if (!is.null(abbs)) {
    abbs <- as.data.frame(abbs)
    for (i in seq_along(abbs[, 1])) {
      address2 <- str_replace(
        string = address2,
        pattern = str_c("\\b", abbs[i, 1], "\\b"),
        replacement = abbs[i, 2]
      )
    }
  }

  if (na_rep) {
    address2[str_which(address2, "^(.)\\1+$")] <- NA
  }

  address2[which(address2 %in% na)] <- NA

  return(address2)
}