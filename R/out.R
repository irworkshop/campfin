#' Inverted Match
#'
#' @param x A vector to check.
#' @param y A vector to compare against.
#' @return Logical if X is not present in Y
#' @examples
#' c("A", "B", "0") %out% LETTERS
#' @usage x %out% y
#' @export
"%out%" <- Negate("%in%")
