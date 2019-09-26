#' @title Normalize a US Phone Number
#' @description Take US phone numbers in any number of formats and try to
#'   convert them to a standard format.
#' @param number A vector of phone number in any format.
#' @param format The desired output format, with `%a` representing the 3-digit
#'   **area** code, `%e` representing the 3-digit **exchange**, and `%l`
#'   representing the 4-digit **line** number. The puctuation between each part
#'   of the format is used in the normalized number (e.g., `"(%a) %e-%l"` or
#'   `"%a-%e-%l"`).
#' @param na_bad logical; Should invalid numbers be replaced with `NA`.
#' @param convert logical; Should [keypad_convert()] be invoked to replace
#'   numbers with their keypad equivalent.
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
                         convert = FALSE,
                         rm_ext = FALSE) {

  # stop if not a vector
  if (!is_vector(number)) {
    stop("Phone number is not a vector.")
  }

  # convert to character vector
  number <- as.character(number)

  # find any num with letters
  has_letters <- stringr::str_detect(number, "[A-z&&[^x]]")
  # extract the first digit of each num
  first_digit <- stringr::str_sub(number, end = 1L)
  # find those that don't start with letter
  ends_letters <- stringr::str_detect(first_digit, "[:alpha:]", negate = TRUE)
  # find those with letters but not at start
  lets <- which(has_letters & ends_letters)
  # convert numbers in those strings
  number[lets] <- keypad_convert(number[which_letters], ext = FALSE)
  # remove non digit characters to form valid rx_phone
  number[lets] <- stringr::str_remove_all(number[which_letters], "[\\D&&[^x]]")

  # isolate those numbers which match rx_phone
  # only these numbers will be changed any further
  which_good <- stringr::str_which(number, campfin::rx_phone)
  good_nums <- number[which_good]

  good_nums <- good_nums %>%
    # convert to lowercase
    stringr::str_to_lower() %>%
    # remove all non-digits
    stringr::str_remove_all("[\\D&&[^x]]") %>%
    # place space before extension
    stringr::str_replace("x", " x")

  # find any number that starts with a USA country code
  long_10 <- stringr::str_length(good_nums) > 10
  start_one <- stringr::str_sub(good_nums, end = 1L) == "1"
  start_code <- which(long_10 & start_one)
  # remove the country code
  good_nums[start_code] <- stringr::str_sub(good_nums[start_country], start = 2)

  # turn the format code into regex
  # for those with area code, exchange, and line
  format10 <- format %>%
    stringr::str_replace_all("%", "\\\\") %>%
    stringr::str_replace("a", "1") %>%
    stringr::str_replace("e", "2") %>%
    stringr::str_replace("l", "3")

  # and those with only the exchange and line
  format7 <- format %>%
    stringr::str_extract("%e(.*)%l") %>%
    stringr::str_replace_all("%", "\\\\") %>%
    stringr::str_replace("e", "1") %>%
    stringr::str_replace("l", "2")

  good_nums <- good_nums %>%
    # format 10+ digit strings
    stringr::str_replace(
      pattern = "(^\\d{3})(\\d{3})(\\d{4})",
      replacement = format10
    ) %>%
    # format 7 digit strings
    stringr::str_replace(
      pattern = "(^\\d{3})(\\d{4})",
      replacement = format7
    )

  # replace all rx_phones with formatted
  number[which_good] <- good_nums

  if (na_bad) {
    # remove unmatched rx_phone
    number[stringr::str_which(number, campfin::rx_phone, negate = TRUE)] <- NA
  }

  return(number)
}
