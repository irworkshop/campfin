<<<<<<< HEAD
#' Proportion In
#'
#' @param x A vector to check.
#' @param y A vector to compare against.
#' @return Logical if X is not present in Y
#' @examples
#' c("A", "B", "0") %out% LETTERS
=======
#' Out opperator
#'
#' @name %out%
#' @rdname out
#' @keywords internal
#' @usage x %out% y
>>>>>>> b9f842d7addc2db1b363cd20b39d4705201d0bf0
#' @export
"%out%" <- Negate("%in%")
