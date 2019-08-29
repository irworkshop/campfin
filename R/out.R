#' Inverted Match
#' @description `%out%` is an inverted version of the infix opperator `%in%`.
#' @param x vector or NULL: the values to be matched. Long vectors are supported.
#' @param table vector or NULL: the values to be matched against.
#' @return Logical if X is not present in Y
#' @examples
#' c("A", "B", "3") %out% LETTERS
#' @details `%out%` is currently defined as `"%out%" <- function(x, table) match(x, table, nomatch = 0) == 0`
#' @export
"%out%" <- function(x, table) match(x, table, nomatch = 0) == 0
