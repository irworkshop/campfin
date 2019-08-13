#' Is Binary
#'
#' @param x A vector
#' @param na.rm Should NA be ignored, `TRUE` by default
#' @return TRUE if only 2 unique values
#' @importFrom dplyr n_distinct
#' @examples
#' is_binary(x = c("Yes", "No"))
#' @export
is_binary <- function(x, na.rm = TRUE) {
  if (na.rm) x <- na.omit(x)
  dplyr::n_distinct(x) == 2
}
