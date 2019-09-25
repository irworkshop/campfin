#' @title Normalize a Phone Number
#' @description
#' @param number A vector of phone numbers in any format.
#' @return A normalized telephone number.
#' @importFrom stringr str_replace_all str_replace str_remove_all
#' @family Simple Counting Wrappers
#' @examples
#' normal_phone(number = c("916-225-5887"))
#' @export
normal_phone <- function(number,
                         format = "(%a) %e-%l",
                         na_bad = FALSE,
                         na_rep = FALSE,
                         convert = FALSE,
                         rm_ext = FALSE) {

  format10 <- format %>%
    stringr::str_replace_all("%", "\\\\") %>%
    stringr::str_replace("a", "1") %>%
    stringr::str_replace("e", "2") %>%
    stringr::str_replace("l", "3")

  format7 <- format %>%
    stringr::str_extract("%e.%l") %>%
    stringr::str_replace_all("%", "\\\\") %>%
    stringr::str_replace("e", "1") %>%
    stringr::str_replace("l", "2")

  vletterToNumber <- Vectorize(phonenumber::letterToNumber, USE.NAMES = FALSE)
  if (convert) {
    number <- vletterToNumber(number)
  }

  if (rm_ext) {
    number <- str_remove(number, "(\\s|\\d)x(.*)$")
  }

  if (na_bad) {
    number[stringr::str_detect(number, rx_phone, negate = TRUE)] <- NA
  }

  number <- number %>%
    stringr::str_to_lower() %>%
    stringr::str_remove_all("[\\D&&[^x]]") %>%
    stringr::str_replace("x", " x")

  if (na_rep) {
    number[stringr::str_which(number, "^(.)\\1+$")] <- NA
  }

  start_country <- which(str_length(number) > 10 & str_sub(number, end = 1L) == "1")
  number[start_country] <- str_sub(number[start_country], start = 2)

  number %>%
    stringr::str_replace(
      pattern = "(^\\d{3})(\\d{3})(\\d{4})",
      replacement = format10
    ) %>%
    stringr::str_replace(
      pattern = "(^\\d{3})(\\d{4})",
      replacement = format7
    )

}
