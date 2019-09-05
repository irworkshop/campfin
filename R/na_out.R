#' @title Return `NA` if For Unmatched Values
#' @description Take a vector `x` and return `NA` for all values not in `y`.
#' @param x A vector to check.
#' @param y A vector to compare.
#' @return A vector `x` with NA for those not `%in%` `y`.
#' @examples
#' na_out(x = c("VT", "QC", "CA"), y = state.abb)
#' na_out(x = 1:10, seq(1, 10, 2))
#' @export
na_out <- function(x, y) {
  x[which(x %out% y)] <- NA
  return(x)
}
