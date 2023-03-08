#' Add proportions
#'
#' Use [prop.table()] to add a proportion column to a [dplyr::count()] tibble.
#'
#' @details `mean(x %in% y)`
#' @param .data A data frame with a count column.
#' @param n The column name with a count, usually `n` from [dplyr::count()].
#' @param sum Should [cumsum()] be called on the new `p` column.
#' @return A data frame with the new column `p`.
#' @examples
#' add_prop(dplyr::count(ggplot2::diamonds, cut))
#' @importFrom dplyr mutate
#' @export
add_prop <- function(.data, n, sum = FALSE) {
  p <- if (sum) {
    cumsum(prop.table(.data$n))
  } else {
    prop.table(.data$n)
  }
  .data$p <- p
  return(.data)
}
