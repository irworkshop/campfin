#' Is even
#'
#' @param x An integer
#' @return Whether x is even or odd
#' @examples
#' is_even(5)
#' is_even(10L)
#' @export
is_even <- function(x) {
  x %% 2 == 0
}
