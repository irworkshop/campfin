#' Check if Binary
#'
#' Uses [dplyr::n_distinct()] to check if there are only two unique values.
#'
#' @param x A vector.
#' @param na.rm logical; Should NA be ignored, `TRUE` by default.
#' @return `TRUE` if only 2 unique values.
#' @importFrom dplyr n_distinct
#' @examples
#' if (is_binary(x <- c("Yes", "No"))) x == "Yes"
#' @export
is_binary <- function(x, na.rm = TRUE) {
  if (na.rm) x <- na.omit(x)
  dplyr::n_distinct(x) == 2
}
