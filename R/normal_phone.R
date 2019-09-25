#' @title Normalize a Phone Number
#' @description
#' @param number A vector of phone number in any format.
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

  vletterToNumber <- Vectorize(phonenumber::letterToNumber, USE.NAMES = FALSE)
  if (convert) {
    number <- vletterToNumber(number)
  }

  which_good <- stringr::str_which(number, rx_phone)
  which_bad <- stringr::str_which(number, rx_phone, negate = TRUE)
  good_nums <- number[which_good]

  good_nums <- good_nums %>%
    stringr::str_to_lower() %>%
    stringr::str_remove_all("[\\D&&[^x]]") %>%
    stringr::str_replace("x", " x")

  if (na_rep) {
    good_nums[good_nums::str_which(good_nums, "^(.)\\1+$")] <- NA
  }

  start_country <- which(stringr::str_length(good_nums) > 10 & stringr::str_sub(good_nums, end = 1L) == "1")
  good_nums[start_country] <- stringr::str_sub(good_nums[start_country], start = 2)

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

  good_nums <- good_nums %>%
    stringr::str_replace(
      pattern = "(^\\d{3})(\\d{3})(\\d{4})",
      replacement = format10
    ) %>%
    stringr::str_replace(
      pattern = "(^\\d{3})(\\d{4})",
      replacement = format7
    )

  number[which_good] <- good_nums

  if (na_bad) {
    number[which_bad] <- NA
  }

  return(number)
}
