#' Truncate and wrap x-axis labels
#'
#' Truncate the labels of a plot's discrete x-axis labels so that the text does
#' not overflow and collide with other bars.
#'
#' @param n The maximum width of string. Passed to [stringr::str_trunc()].
#' @param width Positive integer giving target line width in characters. A width
#'   less than or equal to 1 will put each word on its own line. Passed to
#'   [stringr::str_wrap()].
#' @param ... Additional arguments passed to [ggplot2::scale_x_discrete()].
#' @importFrom ggplot2 scale_x_discrete
#' @importFrom stringr str_trunc str_wrap
#' @export
scale_x_truncate <- function(n = 15, ...) {
   ggplot2::scale_x_discrete(
     label = function(x) {
       stringr::str_trunc(x, n)
     }, ...
   )
}

#' @rdname scale_x_truncate
#' @export
scale_x_wrap <- function(width = 15, ...) {
  ggplot2::scale_x_discrete(
    label = function(x) {
      stringr::str_wrap(x, width)
    }, ...
  )
}
