#' Normalize phone number
#'
#' Take US phone numbers in any number of formats and try to convert them to a
#' standard format.
#'
#' @param number A vector of phone number in any format.
#' @param format The desired output format, with `%a` representing the 3-digit
#'   **area** code, `%e` representing the 3-digit **exchange**, and `%l`
#'   representing the 4-digit **line** number. The punctuation between each part
#'   of the format is used in the normalized number (e.g., `"(%a) %e-%l"` or
#'   `"%a-%e-%l"`).
#' @param na_bad logical; Should invalid numbers be replaced with `NA`.
#' @param convert logical; Should [keypad_convert()] be invoked to replace
#'   numbers with their keypad equivalent.
#' @param rm_ext logical; Should extensions be removed from the end of a number.
#' @return A normalized telephone number.
#' @importFrom stringr str_detect str_sub str_replace_all str_replace
#'   str_remove_all str_which str_to_lower str_length str_extract str_trim
#'   str_squish
#' @examples
#' normal_phone(number = c("916-225-5887"))
#' @export
normal_phone <- function(number, format = "(%a) %e-%l", na_bad = FALSE, convert = FALSE, rm_ext = FALSE) {
  if (!is.vector(number)) {
    stop("Phone number is not a vector.")
  }
  number <- as.character(number)
  number <- stringr::str_squish(number)
  has_letters <- stringr::str_detect(number, "[A-z&&[^x]]")
  first_digit <- stringr::str_sub(number, end = 1L)
  ends_letters <- stringr::str_detect(first_digit, "[:alpha:]", negate = TRUE)
  lets <- which(has_letters & ends_letters)
  number[lets] <- keypad_convert(number[lets], ext = FALSE)
  number[lets] <- stringr::str_remove_all(number[lets], "[\\D&&[^x]]")

  which_good <- stringr::str_which(number, campfin::rx_phone)
  good_nums <- number[which_good]

  good_nums <- good_nums %>%
    stringr::str_to_lower() %>%
    stringr::str_remove_all("[\\D&&[^x]]") %>%
    stringr::str_replace("x", " x")

  long_10 <- stringr::str_length(good_nums) > 10
  start_one <- stringr::str_sub(good_nums, end = 1L) == "1"
  start_code <- which(long_10 & start_one)
  good_nums[start_code] <- stringr::str_sub(good_nums[start_code], start = 2)

  format10 <- format %>%
    stringr::str_replace_all("%", "\\\\") %>%
    stringr::str_replace("a", "1") %>%
    stringr::str_replace("e", "2") %>%
    stringr::str_replace("l", "3")

  format7 <- format %>%
    stringr::str_extract("%e(.*)%l") %>%
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
    number[stringr::str_which(number, campfin::rx_phone, negate = TRUE)] <- NA
  }

  if (rm_ext) {
    number <- stringr::str_remove(number, "\\sx(.*)$")
  }

  number
}
