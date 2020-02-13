#' Inverted match
#'
#' `%out%` is an inverted version of the infix `%in%` operator.
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
#' @param ignore.case logical; if `FALSE`, the pattern matching is case
#'   sensitive and if `TRUE`, case is ignored during matching.
#' @return The proportion of `x` present in `y`.
#' @family counting wrappers
#' @examples
#' prop_in(c("VT", "NH", "ZZ", "ME"), state.abb)
#' @importFrom stats na.omit
#' @importFrom stringr str_to_lower
#' @export
prop_in <- function(x, y, na.rm = TRUE, ignore.case = FALSE) {
  if (ignore.case) {
    x <- stringr::str_to_lower(x)
    y <- stringr::str_to_lower(y)
  }
  if(na.rm) {
    x <- stats::na.omit(x)
  }
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
#' @param ignore.case logical; if `FALSE`, the pattern matching is case
#'   sensitive and if `TRUE`, case is ignored during matching.
#' @return The proportion of `x` absent in `y`.
#' @family counting wrappers
#' @examples
#' prop_out(c("VT", "NH", "ZZ", "ME"), state.abb)
#' @importFrom stats na.omit
#' @importFrom stringr str_to_lower
#' @export
prop_out <- function(x, y, na.rm = TRUE, ignore.case = FALSE) {
  if (ignore.case) {
    x <- stringr::str_to_lower(x)
    y <- stringr::str_to_lower(y)
  }
  if(na.rm) {
    x <- stats::na.omit(x)
  }
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
#' @param ignore.case logical; if `FALSE`, the pattern matching is case
#'   sensitive and if `TRUE`, case is ignored during matching.
#' @return The sum of `x` present in `y`.
#' @family counting wrappers
#' @examples
#' count_in(c("VT", "NH", "ZZ", "ME"), state.abb)
#' @importFrom stats na.omit
#' @importFrom stringr str_to_lower
#' @export
count_in <- function(x, y, na.rm = TRUE, ignore.case = FALSE) {
  if (ignore.case) {
    x <- stringr::str_to_lower(x)
    y <- stringr::str_to_lower(y)
  }
  if(na.rm) {
    x <- stats::na.omit(x)
  }
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
#' @param ignore.case logical; if `FALSE`, the pattern matching is case
#'   sensitive and if `TRUE`, case is ignored during matching.
#' @return The sum of `x` absent in `y`.
#' @family counting wrappers
#' @examples
#' count_out(c("VT", "NH", "ZZ", "ME"), state.abb)
#' @importFrom stats na.omit
#' @importFrom stringr str_to_lower
#' @export
count_out <- function(x, y, na.rm = TRUE, ignore.case = FALSE) {
  if (ignore.case) {
    x <- stringr::str_to_lower(x)
    y <- stringr::str_to_lower(y)
  }
  if(na.rm) {
    x <- stats::na.omit(x)
  }
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
#' @param ignore.case logical; if `FALSE`, the pattern matching is case
#'   sensitive and if `TRUE`, case is ignored during matching.
#' @family counting wrappers
#' @examples
#' # only unique values are checked
#' count_diff(c("VT", "NH", "ZZ", "ZZ", "ME"), state.abb)
#' @importFrom stringr str_to_lower
#' @export
count_diff <- function(x, y, ignore.case = FALSE) {
  if (ignore.case) {
    x <- stringr::str_to_lower(x)
    y <- stringr::str_to_lower(y)
  }
  length(setdiff(x, y))
}

#' Count missing
#'
#' Count the total values of `x` that are `NA`.
#'
#' @details `sum(is.na(x))`
#' @param x A vector to check.
#' @return The sum of `x` that are `NA`
#' @family counting wrappers
#' @examples
#' count_na(c("VT", "NH", NA, "ME"))
#' @importFrom stats na.omit
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
#' @return The proportion of values of `x` that are `NA`.
#' @family counting wrappers
#' @examples
#' prop_na(c("VT", "NH", NA, "ME"))
#' @importFrom stats na.omit
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
#' @param ignore.case logical; if `FALSE`, the pattern matching is case
#'   sensitive and if `TRUE`, case is ignored during matching.
#' @return The vector `x` missing any values in `y`.
#' @family counting wrappers
#' @examples
#' na_in(c("VT", "NH", "ZZ", "ME"), state.abb)
#' na_in(1:10, seq(1, 10, 2))
#' @importFrom stringr str_to_lower
#' @export
na_in <- function(x, y, ignore.case = FALSE) {
  if (ignore.case) {
    x <- stringr::str_to_lower(x)
    y <- stringr::str_to_lower(y)
  }
  x[which(x %in% y)] <- NA
  return(x)
}

#' Remove out
#'
#' Set `NA` for the values of `x` that are `%out%` of the vector `y`.
#'
#' @param x A vector to check.
#' @param y A vector to compare against.
#' @param ignore.case logical; if `FALSE`, the pattern matching is case
#'   sensitive and if `TRUE`, case is ignored during matching.
#' @return The vector `x` missing any values not in `y`.
#' @family counting wrappers
#' @examples
#' na_out(c("VT", "NH", "ZZ", "ME"), state.abb)
#' na_out(1:10, seq(1, 10, 2))
#' @importFrom stringr str_to_lower
#' @export
na_out <- function(x, y, ignore.case = FALSE) {
  if (ignore.case) {
    x <- stringr::str_to_lower(x)
    y <- stringr::str_to_lower(y)
  }
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
#' @param n The minimum number times a character must repeat. If 0, the default,
#'   then any string of one character will be replaced with `NA`. If greater
#'   than 0, the string must contain greater than `n` number of repetitions.
#' @return The vector `x` with `NA` replacing repeating character values.
#' @family counting wrappers
#' @examples
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
#' @family counting wrappers
#' @examples
#' count_vec(x = rivers)
#' count_vec(x = sample(x = state.name, size = 1000, replace = TRUE))
#' @importFrom dplyr count
#' @importFrom tibble enframe
#' @export
count_vec <- function(x, sort = TRUE) {
  dplyr::count(x = tibble::enframe(x = x), .data$value, sort = sort)
}

#' Proportion missing
#'
#' Find the proportion of values of `x` that are distinct.
#'
#' @details `length(unique(x))/length(x)`
#' @param x A vector to check.
#' @return The ratio of distinct values `x` to total values of `x`.
#' @family counting wrappers
#' @examples
#' prop_distinct(c("VT", "VT", NA, "ME"))
#' @export
prop_distinct <- function(x) {
  length(unique(x))/length(x)
}

#' Which in
#'
#' Return the values of `x` that are `%in%` of the vector `y`.
#'
#' @details `x[which(x %in% y)]`
#' @param x A vector to check.
#' @param y A vector to compare against.
#' @param ignore.case logical; if `FALSE`, the pattern matching is case
#'   sensitive and if `TRUE`, case is ignored during matching.
#' @return The elements of `x` that are `%in%` y.
#' @family counting wrappers
#' @examples
#' which_in(c("VT", "DC", NA), state.abb)
#' @importFrom stats na.omit
#' @export
which_in <- function(x, y, ignore.case = FALSE) {
  if (ignore.case) {
    x <- stringr::str_to_lower(x)
    y <- stringr::str_to_lower(y)
  }
  x[which(x %in% y)]
}

#' Which out
#'
#' Return the values of `x` that are `%out%` of the vector `y`.
#'
#' @details `x[which(x %out% y)]`
#' @param x A vector to check.
#' @param y A vector to compare against.
#' @param na.rm logical; Should `NA` be ignored?
#' @param ignore.case logical; if `FALSE`, the pattern matching is case
#'   sensitive and if `TRUE`, case is ignored during matching.
#' @return The elements of `x` that are `%out%` y.
#' @family counting wrappers
#' @examples
#' which_out(c("VT", "DC", NA), state.abb)
#' @importFrom stats na.omit
#' @export
which_out <- function(x, y, na.rm = TRUE, ignore.case = FALSE) {
  if (ignore.case) {
    x <- stringr::str_to_lower(x)
    y <- stringr::str_to_lower(y)
  }
  if (na.rm) {
    x <- stats::na.omit(x)
  }
  x[which(x %out% y)]
}
