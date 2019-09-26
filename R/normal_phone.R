#' @title Normalize a US Phone Number
#' @description Take US phone numbers in any number of formats and try to
#'   convert them to a standard format.
#' @param number A vector of phone number in any format.
#' @param format The desired output format, with `%a` representing the 3-digit
#'   area code, `%e` representing the 3-digit exchange, and `%l` representing
#'   the 4-digit line number.
#' @param na_bad logical; Should invalid numbers be replaced with `NA`.
#' @param na_rep logical; Should single digit (repeating) strings be replaced
#'   with `NA`.
#' @param convert logical; Should LETTERS be converted to their keypad number
#'   equivalent.
#' @param rm_ext logical; Should extensions be removed from the end of a number.
#' @return A normalized telephone number.
#' @importFrom stringr str_detect str_sub str_replace_all str_replace
#'   str_remove_all str_which str_to_lower str_length str_extract
#' @examples
#' normal_phone(number = c("916-225-5887"))
#' @export
normal_phone <- function(number,
                         format = "(%a) %e-%l",
                         na_bad = FALSE,
                         na_rep = FALSE,
                         convert = FALSE,
                         rm_ext = FALSE) {

  number <- as.character(number)

  # replace letters for strings that start with non-letter
  has_letters <- stringr::str_detect(number, "[A-z&&[^x]]")
  first_digit <- stringr::str_sub(number, end = 1L)
  ends_letters <- stringr::str_detect(first_digit, "[:alpha:]", negate = TRUE)
  which_letters <- which(has_letters & ends_letters)
  number[which_letters] <- stringr::str_replace_all(number[which_letters], keypad)
  number[which_letters] <- stringr::str_replace(
    string = stringr::str_remove_all(number[which_letters], "[\\D&&[^x]]"),
    pattern = "(^\\d{3})(\\d{3})(\\d{4})",
    replacement = "\\1-\\2-\\3"
  )

  # isolate those numbers which match rx_phone
  which_good <- stringr::str_which(number, campfin::rx_phone)
  which_bad <- stringr::str_which(number, campfin::rx_phone, negate = TRUE)
  good_nums <- number[which_good]

  good_nums <- good_nums %>%
    stringr::str_to_lower() %>%
    stringr::str_remove_all("[\\D&&[^x]]") %>%
    stringr::str_replace("x", " x")

  if (na_rep) {
    good_nums[stringr::str_which(good_nums, "^(.)\\1+$")] <- NA
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
