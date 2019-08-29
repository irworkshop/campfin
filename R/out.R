#' Inverted Match
#'
#' @return Logical if X is not present in Y
#' @examples
#' c("A", "B", "3") %out% LETTERS
#' @export
"%out%" <- Negate("%in%")
