#' Proportion In
#'
#' @param x A vector to check.
#' @param y A vector to compare against.
#' @param na.rm Should NA values be ignored.
#' @return The proprtion of X present in Y.
#' @examples
#' prop_in(c("VT", "NH", "ZZ", "ME"), state.abb)
#' @export
prop_in <- function(x, y, na.rm = TRUE) {
  if (na.rm) {
    prop <- mean(na.omit(x) %in% y)
  } else {
    prop <- mean(x %in% y)
  }
  return(prop)
}

#' Proportion Out
#'
#' @param x A vector to check.
#' @param y A vector to compare against.
#' @param na.rm Should NA values be ignored.
#' @return The proprtion of X _not_ present in Y.
#' @examples
#' prop_in(c("VT", "NH", "ZZ", "ME"), state.abb)
#' @export
prop_out <- function(x, y, na.rm = TRUE) {
  if (na.rm) {
    prop <- mean(!(na.omit(x) %in% y))
  } else {
    prop <- mean(!(x %in% y))
  }
  return(prop)
}
