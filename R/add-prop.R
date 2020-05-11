#' Add proportions
#'
#' Use [prop.table()] to add a proportion column to a [dplyr::count()] tibble.
#'
#' @details `mean(x %in% y)`
#' @param .data A data frame with a count column.
#' @param n The column name with a count, usually `n` from [dplyr::count()].
#' @return A data frame with the new column `p`.
#' @examples
#' add_prop(dplyr::count(ggplot2::diamonds, cut))
#' @importFrom dplyr mutate
#' @export
add_prop <- function(.data, n) {
  dplyr::mutate(.data, p = prop.table(n))
}
