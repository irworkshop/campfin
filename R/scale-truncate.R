#' Truncate x-axis labels
#'
#' Truncate the labels of a plot's discrete x-axis labels so that the text does
#' not overflow and collide with other bars.
#'
#' @param n The maximum width of string passed to [stringr::str_trunc()].
#' @param ... Additional arguments passed to [ggplot2::scale_x_discrete()].
#' @importFrom ggplot2 scale_x_discrete
#' @importFrom stringr str_trunc
#' @export
scale_x_truncate <- function(n = 20, ...) {
   ggplot2::scale_x_discrete(..., label = function(x) stringr::str_trunc(x, n))
}
