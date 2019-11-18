#' Check if even
#'
#' @param x A numeric vector.
#' @return logical; Whether the integer is even or odd.
#' @examples
#' is_even(1:10)
#' is_even(10L)
#' @export
is_even <- function(x) {
  x %% 2 == 0
}
