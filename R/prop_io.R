#' Proportion In
#'
#' @param x A vector to check.
#' @param y A vector to compare against.
#' @param na.rm Should `NA` be ignored?
#' @return The proprtion of X present in Y.
#' @importFrom stats na.omit
#' @examples
#' prop_in(c("VT", "NH", "ZZ", "ME"), state.abb)
#' @export
prop_in <- function(x, y, na.rm = TRUE) {
  if(na.rm) x <- stats::na.omit(x)
  mean(x %in% y, na.rm = TRUE)
}

#' Proportion Out
#'
#' @param x A vector to check.
#' @param y A vector to compare against.
#' @param na.rm Should `NA` be ignored?
#' @return The proprtion of X _not_ present in Y.
#' @examples
#' prop_in(c("VT", "NH", "ZZ", "ME"), state.abb)
#' @export
prop_out <- function(x, y, na.rm = TRUE) {
  if(na.rm) x <- stats::na.omit(x)
  mean(x %out% y, na.rm = TRUE)
}
