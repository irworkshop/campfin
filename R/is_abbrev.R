#' @title Check if Abbreviation
#' @description To return a value of `TRUE`, (1) the first letter of `abb` must
#'   match the first letter of `full`, (2) _all_ letters of `abb` must exist in
#'   `full`, and (3) those letters of `abb` must be in the same order as they
#'   appear in `full`.
#' @param abb A suspected abbreviation
#' @param full A long form string to test against
#' @return logical; whether `abb` is potential abbreviation of `full`
#' @importFrom stringr str_split
#' @importFrom dplyr lead
#' @examples
#' is_abbrev(abb = "BRX", full = "BRONX")
#' is_abbrev(abb = state.abb, full = state.name)
#' is_abbrev(abb = "NOLA", full = "New Orleans")
#' @export
is_abbrev <- Vectorize(
  function(abb, full) {
    less <- nchar(abb) < nchar(full)
    match <- .first_letter_match(x = abb, y = full)
    inside <- .letters_inside(x = abb, y = full)
    ordered <- .letters_ordered(x = abb, y = full)
    all <- less & match & inside & ordered
    return(unname(all))
  }, USE.NAMES = FALSE
)

.first_letter_match <- function(x, y) {
    stringr::str_sub(x, end = 1) == stringr::str_sub(y, end = 1)
}

.letters_inside <- function(x, y) {
    split_x <- stringr::str_split(stringr::str_to_lower(x), pattern = "", simplify = TRUE)
    split_y <- stringr::str_split(stringr::str_to_lower(y), pattern = "", simplify = TRUE)
    all(split_x %in% split_y)
}

.letters_ordered <- function(x, y) {
    xs <- stringr::str_split(x, pattern = "", simplify = TRUE)
    xs <- stringr::str_to_lower(xs)
    ys <- stringr::str_split(y, pattern = "", simplify = TRUE)
    ys <- stringr::str_to_lower(ys)
    match_order <- match(xs, ys)
    all(match_order < dplyr::lead(match_order), na.rm = TRUE)
}
