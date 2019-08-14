#' NA if Out
#'
#' @param x A vector to check
#' @param y A vector to compare
#' @return A vector `x` with NA for those not `%in%` `y`
#' @examples
#' na_out(x = c("VT", "QC", "CA"), y = state.abb)
#' @export
na_out <- function(x, y) {
  x[which(x %out% y)] <- NA
  return(x)
}
