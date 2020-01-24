#' Convert letters or numbers to their keypad counterpart
#'
#' This function works best when converting numbers to letters, as each number
#' only has a single possible letter. For each letter, there are 3 or 4 possible
#' letters, resulting in a number of possible conversions. This function was
#' intended to convert phonetic telephone numbers to their valid numeric
#' equivalent; when used in this manner, each letter in a string can be lazily
#' replaced without changing the rest of the string.
#'
#' @details When replacing letters, this function relies on the feature of
#'   [stringr::str_replace_all()] to work with named vectors (`c("A" = "2")`).
#' @param x A vector of characters or letters.
#' @param ext logical; Should extension text be converted to numbers. Defaults to
#'   `FALSE` and matches x, ext, and extension followed by a space or number.
#' @return If a character vector is supplied, a vector of each elements numeric
#'   counterpart is returned. If a numeric vector (or a completely coercible
#'   character vector) is supplied, then a **list** is returned, each element of
#'   which contacts a vector of letters for each number.
#' @examples
#' keypad_convert("1-800-CASH-NOW ext123")
#' keypad_convert(c("abc", "123"))
#' keypad_convert(letters)
#' @importFrom stringr str_replace_all str_to_upper
#' @export
keypad_convert <- function(x, ext = FALSE) {
  rx_ext <- "ext(\\s+\\d+|\\d+)|x(\\s+\\d+|\\d+)|extension(\\s+\\d+|\\d+)"
  which_ext <- stringr::str_which(stringr::str_to_lower(x), rx_ext)
  if (!ext & !rlang::is_empty(x[which_ext])) {
    e <- str_extract(x[which_ext], rx_ext)
    x[which_ext] <- str_remove(x[which_ext], rx_ext)
    x <- str_replace_all(x, keypad)
    x[which_ext] <- paste0(x[which_ext], e)
  } else {
    x <- stringr::str_replace_all(
      string = stringr::str_to_upper(x),
      pattern = keypad
    )
  }
  return(x)
}

