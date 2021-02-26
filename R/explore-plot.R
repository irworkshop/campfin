#' Create Basic Barplots
#'
#' This function simply wraps around [ggplot2::geom_col()] to take a dataframe
#' and categorical variable to return a custom barplot `ggplot` object. The bars
#' are arranged in descending order and are limited to the 8 most frequent
#' values.
#'
#' @param data The data frame to explore.
#' @param var A variable to plot.
#' @param nbar The number of bars to plot. Always shows most common values.
#' @param palette The color palette passed to [ggplot2::scale_fill_brewer().
#' @param na.rm logical: Should `NA` values of `var` be removed?
#' @return A `ggplot` barplot object. Can then be combined with other `ggplot`
#'   layers with `+` to customize.
#' @examples
#' explore_plot(iris, Species)
#' @importFrom dplyr count mutate desc filter
#' @importFrom ggplot2 ggplot geom_col scale_fill_brewer scale_y_continuous aes
#' @importFrom stringr str_to_title str_replace_all
#' @export
explore_plot <- function(data, var, nbar = 8, palette = "Dark2", na.rm = TRUE) {
  var_string <- deparse(substitute(var))
  if (na.rm) {
    data <- dplyr::filter(data, !is.na({{ var }}))
  }
  dat <- dplyr::count(data, {{ var }}, sort = TRUE)
  dat$p <- dat$n / sum(dat$n)
  ggplot2::ggplot(
    data = utils::head(dat, nbar),
    mapping = ggplot2::aes(
      x = stats::reorder({{ var }}, dplyr::desc(.data$p)),
      y = .data$p
    )
  ) +
    ggplot2::geom_col(mapping = ggplot2::aes(fill = {{ var }})) +
    ggplot2::scale_fill_brewer(palette = palette, guide = FALSE) +
    ggplot2::scale_y_continuous(labels = scales::percent) +
    ggplot2::labs(y = "Percent", x = var_string)
}
