#' Create Basic Barplots
#'
#' This function simply wraps around [ggplot2::geom_col()] to take a dataframe
#' and categorical variable to return a custom barplot `ggplot` object. The bars
#' are arranged in descending order and are limited to the 8 most frequent
#' values.
#'
#' @param data The data frame to explore.
#' @param var A variable to plot.
#' @param flip logical; Whether plot should be flipped horizontally.
#' @param nbar The number of bars to plot. Always shows most common values.
#' @param palette The color palette passed to [ggplot2::scale_fill_brewer().
#' @param ... Additional optional arguments passed to [ggplot2::labs()].
#' @return A `ggplot` barplot object. Can then be combined with other `ggplot`
#'   layers with `+` to customize.
#' @examples
#' explore_plot(ggplot2::diamonds, cut)
#' @importFrom dplyr count mutate desc
#' @importFrom ggplot2 ggplot geom_col scale_fill_brewer scale_y_continuous aes
#' @importFrom stringr str_to_title str_replace_all
#' @export
explore_plot <- function(data, var, flip = FALSE, nbar = 8, palette = "Dark2", ...) {
  var_string <- deparse(substitute(var))
  title_var <- stringr::str_to_title(stringr::str_replace_all(var_string, "_|-|\\.", " "))
  base_plot <- data %>%
    dplyr::count({{ var }}, sort = TRUE) %>%
    dplyr::mutate(p = .data$n/sum(.data$n)) %>%
    utils::head(nbar) %>%
    ggplot2::ggplot(ggplot2::aes(stats::reorder({{ var }}, dplyr::desc(.data$p)), .data$p)) +
    ggplot2::geom_col(ggplot2::aes(fill = {{ var }})) +
    ggplot2::scale_fill_brewer(palette = palette, guide = FALSE) +
    ggplot2::scale_y_continuous(labels = scales::percent) +
    ggplot2::labs(
      x = title_var,
      y = "Percent",
      ...
    )
  if (flip) {
    base_plot + ggplot2::coord_flip()
  } else {
    base_plot
  }
}
