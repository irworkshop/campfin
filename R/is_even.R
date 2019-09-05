#' @title Check if Even
#' @description Is a number even? Pretty simple...
#' @param x An integer.
#' @return logical; Whether the integer is even or odd.
#' @examples
#' is_even(5)
#' is_even(10L)
#' @export
is_even <- function(x) {
  x %% 2 == 0
}
