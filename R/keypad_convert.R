#' @title Return the Keypad Number for a Letter
#' @param letter A character vector of letters.
#' @return A character vector of numbers.
#' @importFrom stringr str_replace_all str_to_upper
#' @examples
#' keypad_number(letter = "Example")
keypad_number <- function(letter) {
  stringr::str_replace_all(stringr::str_to_upper(letter), keypad)
}

#' @title Return the Keypad Letters for a Number
#' @param number A _single_ number.
#' @return The numbers which would return `number` in [keypad_number()].
#' @examples
#' keypad_letters(number = 8)
keypad_letters <- function(number) {
  keypad2 <- invert_named(keypad)
  unname(keypad2[which(names(keypad2) == number)])
}
