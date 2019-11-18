#' Inverted match
#'
#' `%out%` is an inverted version of the infix `%in%` opperator.
#'
#' @param x vector: the values to be matched. Long vectors are supported.
#' @param table vector or `NULL`: the values to be matched against.
#' @return logical; if `x` is not present in `table`
#' @examples
#' c("A", "B", "3") %out% LETTERS
#' @details `%out%` is currently defined as
#'   `"%out%" <- function(x, table) match(x, table, nomatch = 0) == 0`
#' @export
"%out%" <- function(x, table) {
  match(x, table, nomatch = 0) == 0
}

#' Proportion in
#'
#' Find the proportion of values of `x` that are `%in%` the vector `y`.
#'
#' @details `mean(x %in% y)`
#' @param x A vector to check.
#' @param y A vector to compare against.
#' @param na.rm logical; Should `NA` be ignored?
#' @return The proprtion of `x` present in `y`.
#' @family Simple counting wrappers
#' @importFrom stats na.omit
#' @examples
#' prop_in(c("VT", "NH", "ZZ", "ME"), state.abb)
#' @export
prop_in <- function(x, y, na.rm = TRUE) {
  if(na.rm) x <- stats::na.omit(x)
  mean(x %in% y)
}

#' Proportion out
#'
#' Find the proportion of values of `x` that are `%out%` of the vector `y`.
#'
#' @details `mean(x %out% y)`
#' @param x A vector to check.
#' @param y A vector to compare against.
#' @param na.rm logical; Should `NA` be ignored?
#' @return The proprtion of `x` absent in `y`.
#' @family Simple counting wrappers
#' @importFrom stats na.omit
#' @examples
#' prop_out(c("VT", "NH", "ZZ", "ME"), state.abb)
#' @export
prop_out <- function(x, y, na.rm = TRUE) {
  if(na.rm) x <- stats::na.omit(x)
  mean(x %out% y)
}

#' Count in
#'
#' Count the total values of `x` that are `%in%` the vector `y`.
#'
#' @details `sum(x %out% y)`
#' @param x A vector to check.
#' @param y A vector to compare against.
#' @param na.rm logical; Should `NA` be ignored?
#' @return The sum of `x` present in `y`.
#' @family Simple counting wrappers
#' @importFrom stats na.omit
#' @examples
#' count_in(c("VT", "NH", "ZZ", "ME"), state.abb)
#' @export
count_in <- function(x, y, na.rm = TRUE) {
  if(na.rm) x <- stats::na.omit(x)
  sum(x %in% y)
}

#' Count out
#'
#' Count the total values of `x` that are are `%out%` of the vector `y`.
#'
#' @details `sum(x %out% y)`
#' @param x A vector to check.
#' @param y A vector to compare against.
#' @param na.rm logical; Should `NA` be ignored?
#' @return The sum of `x` absent in `y`.
#' @family Simple counting wrappers
#' @importFrom stats na.omit
#' @examples
#' count_out(c("VT", "NH", "ZZ", "ME"), state.abb)
#' @export
count_out <- function(x, y, na.rm = TRUE) {
  if(na.rm) x <- stats::na.omit(x)
  sum(x %out% y)
}

#' Count set difference
#'
#' Find the length of the set of difference between `x` and `y` vectors.
#'
#' @details `sum(x %out% y)`
#' @param x A vector to check.
#' @param y A vector to compare against.
#' @return The number of _unique_ values of `x` not in `y`.
#' @family Simple counting wrappers
#' @examples
#' # Only unique values are checked
#' count_diff(c("VT", "NH", "ZZ", "ZZ", "ME"), state.abb)
#' @export
count_diff <- function(x, y) {
  length(setdiff(x, y))
}

#' Count missing
#'
#' Count the total values of `x` that are `NA`.
#'
#' @details `sum(is.na(x))`
#' @param x A vector to check.
#' @return The sum of `x` that are `NA`
#' @family Simple counting wrappers
#' @importFrom stats na.omit
#' @examples
#' count_na(c("VT", "NH", NA, "ME"))
#' @export
count_na <- function(x) {
  sum(is.na(x))
}

#' Proportion missing
#'
#' Find the proportion of values of `x` that are `NA`.
#'
#' @details `mean(is.na(x))`
#' @param x A vector to check.
#' @return The sum of `x` absent in `y`.
#' @family Simple counting wrappers
#' @importFrom stats na.omit
#' @examples
#' prop_na(c("VT", "NH", NA, "ME"))
#' @export
prop_na <- function(x) {
  mean(is.na(x))
}

#' Remove in
#'
#' Set `NA` for the values of `x` that are `%in%` the vector `y`.
#'
#' @param x A vector to check.
#' @param y A vector to compare against.
#' @return The vector `x` missing any values in `y`.
#' @family Simple counting wrappers
#' na_in(c("VT", "NH", "ZZ", "ME"), state.abb)
#' na_in(1:10, seq(1, 10, 2))
#' @export
na_in <- function(x, y) {
  x[which(x %in% y)] <- NA
  return(x)
}

#' Remove out
#'
#' Set `NA` for the values of `x` that are `%out%` of the vector `y`.
#'
#' @param x A vector to check.
#' @param y A vector to compare against.
#' @return The vector `x` missing any values not in `y`.
#' @family Simple counting wrappers
#' na_out(c("VT", "NH", "ZZ", "ME"), state.abb)
#' na_out(1:10, seq(1, 10, 2))
#' @export
na_out <- function(x, y) {
  x[which(x %out% y)] <- NA
  return(x)
}

#' Remove repeated character elements
#'
#' Set `NA` for the values of `x` that contain a single repeating character and
#' no other characters.
#'
#' @details Uses the regular expression `"^(.)\\1+$"`.
#' @param x A vector to check.
#' @param n The minumum number times a character must repeat. If 0, the default,
#'   then any string of one character will be replaced with `NA`. If greater
#'   than 0, the string must contain greater than `n` number of repetitions.
#' @return The vector `x` with `NA` replacing repeating character values.
#' @family Simple counting wrappers
#' na_rep(c("VT", "NH", "ZZ", "ME"))
#' @export
na_rep <- function(x, n = 0) {
  rx <- sprintf("^(.)\\1{%i,}$", n)
  x[stringr::str_which(x, rx)] <- NA
  return(x)
}

#' Count values of a vector
#'
#' A version of [dplyr::count()] which uses [tibble::enframe()] to count the
#' number of values in a single vector.
#'
#' @param x A vector to check.
#' @param sort logical; if TRUE will sort output in descending order of `n`
#' @return A tibble, with counts of each `value` in `n`.
#' @family Simple counting wrappers
#' count_vec(x = rivers)
#' count_vec(x = sample(x = state.name, size = 1000, replace = TRUE))
#' @importFrom dplyr count
#' @importFrom tibble enframe
#' @export
count_vec <- function(x, sort = TRUE) {
  dplyr::count(x = tibble::enframe(x = x), .data$value, sort = sort)
}
