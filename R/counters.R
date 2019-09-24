#' @title Inverted Match
#' @description `%out%` is an inverted version of the infix opperator `%in%`.
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

#' @title Proportion In
#' @description Count total values of one vector in another vector.
#' @details `mean(x %in% y)`
#' @param x A vector to check.
#' @param y A vector to compare against.
#' @param na.rm logical; Should `NA` be ignored?
#' @return The proprtion of `x` present in `y`.
#' @family Simple Counting Wrappers
#' @importFrom stats na.omit
#' @examples
#' prop_in(c("VT", "NH", "ZZ", "ME"), state.abb)
#' @export
prop_in <- function(x, y, na.rm = TRUE) {
  if(na.rm) x <- stats::na.omit(x)
  mean(x %in% y)
}

#' @title Proportion Out
#' @description Find proportion of values of one vector not in another vector.
#' @details `mean(x %out% y)`
#' @param x A vector to check.
#' @param y A vector to compare against.
#' @param na.rm logical; Should `NA` be ignored?
#' @return The proprtion of `x` absent in `y`.
#' @family Simple Counting Wrappers
#' @importFrom stats na.omit
#' @examples
#' prop_out(c("VT", "NH", "ZZ", "ME"), state.abb)
#' @export
prop_out <- function(x, y, na.rm = TRUE) {
  if(na.rm) x <- stats::na.omit(x)
  mean(x %out% y)
}

#' @title Count In
#' @description Count total values of one vector in another vector.
#' @details `sum(x %out% y)`
#' @param x A vector to check.
#' @param y A vector to compare against.
#' @param na.rm logical; Should `NA` be ignored?
#' @return The sum of `x` present in `y`.
#' @family Simple Counting Wrappers
#' @importFrom stats na.omit
#' @examples
#' count_in(c("VT", "NH", "ZZ", "ME"), state.abb)
#' @export
count_in <- function(x, y, na.rm = TRUE) {
  if(na.rm) x <- stats::na.omit(x)
  sum(x %in% y)
}

#' @title Count Out
#' @description Find proportion of values of one vector not in another vector.
#' @details `sum(x %out% y)`
#' @param x A vector to check.
#' @param y A vector to compare against.
#' @param na.rm logical; Should `NA` be ignored?
#' @return The sum of `x` absent in `y`.
#' @family Simple Counting Wrappers
#' @importFrom stats na.omit
#' @examples
#' count_out(c("VT", "NH", "ZZ", "ME"), state.abb)
#' @export
count_out <- function(x, y, na.rm = TRUE) {
  if(na.rm) x <- stats::na.omit(x)
  sum(x %out% y)
}

#' @title Count Set Difference
#' @description Find length of the set of differences between `x` and `y`.
#' @details `sum(x %out% y)`
#' @param x A vector to check.
#' @param y A vector to compare against.
#' @return The number of _unique_ values of `x` not in `y`.
#' @family Simple Counting Wrappers
#' @examples
#' # Only unique values are checked
#' count_diff(c("VT", "NH", "ZZ", "ZZ", "ME"), state.abb)
#' @export
count_diff <- function(x, y) {
  length(setdiff(x, y))
}

#' @title Count `NA`
#' @description Count the values of a vector that are missing.
#' @details `sum(is.na(x))`
#' @param x A vector to check.
#' @return The sum of `x` that are `NA`
#' @family Simple Counting Wrappers
#' @importFrom stats na.omit
#' @examples
#' count_na(c("VT", "NH", NA, "ME"))
#' @export
count_na <- function(x) {
  sum(is.na(x))
}

#' @title Proportion `NA`
#' @description Find the proportion of values of a vector that are missing.
#' @details `mean(is.na(x))`
#' @param x A vector to check.
#' @return The sum of `x` absent in `y`.
#' @family Simple Counting Wrappers
#' @importFrom stats na.omit
#' @examples
#' prop_na(c("VT", "NH", NA, "ME"))
#' @export
prop_na <- function(x) {
  mean(is.na(x))
}

#' @title Remove In
#' @description Remove the values of one vector that are in another vector.
#' @param x A vector to check.
#' @param y A vector to compare against.
#' @return The vector `x` missing any values in `y`.
#' @family Simple Counting Wrappers
#' na_in(c("VT", "NH", "ZZ", "ME"), state.abb)
#' na_in(1:10, seq(1, 10, 2))
#' @export
na_in <- function(x, y) {
  x[which(x %in% y)] <- NA
  return(x)
}

#' @title Remove Out
#' @description Remove the values of one vector that are not in another vector.
#' @param x A vector to check.
#' @param y A vector to compare against.
#' @return The vector `x` missing any values not in `y`.
#' @family Simple Counting Wrappers
#' na_out(c("VT", "NH", "ZZ", "ME"), state.abb)
#' na_out(1:10, seq(1, 10, 2))
#' @export
na_out <- function(x, y) {
  x[which(x %out% y)] <- NA
  return(x)
}

#' @title Count Values of a Vector
#' @description A version of [dplyr::count()] which uses [tibble::enframe()] to
#'   count the number of values in a single vector.
#' @param x A vector to check.
#' @param sort logical; if TRUE will sort output in descending order of `n`
#' @return A tibble, with counts of each `value` in `n`.
#' @family Simple Counting Wrappers
#' count_vec(x = rivers)
#' count_vec(x = sample(x = state.name, size = 1000, replace = TRUE))
#' @importFrom dplyr count
#' @importFrom tibble enframe
#' @export
count_vec <- function(x, sort = TRUE) {
  dplyr::count(x = tibble::enframe(x = x), .data$value, sort = sort)
}
