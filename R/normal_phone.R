#' @title Normalize a Phone Number
#' @description
#' @param number A vector of phone numbers in any format.
#' @return A normalized telephone number.
#' @importFrom stringr str_replace_all str_replace str_remove_all
#' @family Simple Counting Wrappers
#' @examples
#' normal_phone(number = c("916-225-5887"))
#' @export
normal_phone <- function(number, format = "(%a) %p-%l") {
  format <- format %>%
    stringr::str_replace_all("%", "\\\\") %>%
    stringr::str_replace("a", "1") %>%
    stringr::str_replace("p", "2") %>%
    stringr::str_replace("l", "3")
  number <- stringr::str_remove_all(string = number, pattern = "\\D")
  number %>%
    stringr::str_pad(
      width = 10,
      side = "left",
      pad = "0"
    ) %>%
    stringr::str_replace(
      pattern = "(^\\d{3})(\\d{3})(\\d{4}$)",
      replacement = format
    )
}
