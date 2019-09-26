#' @title Convert Letter(s) or a Number to their Keypad Counterpart
#' @description This function works best when converting numbers to letters, as
#'   each number only has a single possible letter. For each letter, there are 3
#'   or 4 possible letters, resulting in a number of possible conversions. This
#'   function was inteded to convert phonetic telephone numbers to their valid
#'   numeric equivalent; when used in this manner, each letter in a string can
#'   be lazily replaced without changing the rest of the string.
#' @details When replacing letters, this function relies on the feature of
#'   [stringr::str_replace_all()] to work with named vectors (`c("A" = "2")`).
#' @param x A vector of characters or letters.
#' @return If a character vector is supplied, a vector of each elements numeric
#'   counterpart is returned. If a numeric vector (or a completely coercible
#'   character vector) is supplied, then a **list** is returned, each element of
#'   which contacts a vector of letetrs for each number.
#' @examples
#' keypad_convert("1-800-CASH-NOW")
#' keypad_convert(c("abc", "123"))
#' keypad_convert(letters)
#' @importFrom stringr str_replace_all str_to_upper
#' @export
keypad_convert <- function(x) {
  is_letter <- is.character(x)
  is_number <- is.numeric(x) | all(!is.na(suppressWarnings(as.numeric(x))))
  if (is_number) { x <- as.numeric(x) }
  if (is_letter) {
    stringr::str_replace_all(stringr::str_to_upper(x), keypad)
  } else {
    if (is_number) {
      combos <- rep_len(list(NA), length.out = length(x))
      for (i in seq_along(x)) {
        keypad2 <- invert_named(keypad)
        combos[[i]] <- unname(keypad2[which(names(keypad2) == x[i])])
        names(combos) <- x
      }
      return(combos)
    } else {
      stop("x can not be converted")
    }
  }
}
