#' @title Return the Keypad Number for a Letter
#' @param letter A character vector of letters.
#' @return A character vector of numbers.
#' @importFrom stringr str_replace_all str_to_upper
#' @examples
#' keypad_number("Example")
keypad_number <- function(letter) {
  stringr::str_replace_all(stringr::str_to_upper(letter), keypad_alpha)
}

#' @title Return the Keypad Letters for a Number
#' @param number A _single_ number.
#' @return The numbers which would return `number` in [keypad_number()].
#' @examples
#' keypad_letters(8)
keypad_letters <- function(number) {
  unname(keypad_nums[which(names(keypad_nums) == number)])
}
