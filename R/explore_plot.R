#' Check for All New Files
#'
#' @param data A data frame to glimpse.
#' @param fun A function to map to each column.
#' @return A tibble with a row for every column and new columns with count and proportion.
#' @examples
#' glimpse_fun(dplyr::storms, dplyr::n_distinct)
#' @importFrom snakecase to_title_case
#' @importFrom ggplot2 ggplot geom_col scale_fill_brewer scale_y_continuous aes
#' @importFrom dplyr count mutate desc
#' @export
explore_plot <- function(data, var, flip = FALSE, nbar = 8, palette = "Set1", ...) {
  var_string <- deparse(substitute(var))
  title_var <- snakecase::to_title_case(var_string)
  base_plot <- data %>%
    dplyr::count({{ var }}, sort = TRUE) %>%
    dplyr::mutate(p = n/sum(n)) %>%
    utils::head(nbar) %>%
    ggplot2::ggplot(ggplot2::aes(reorder({{ var }}, dplyr::desc(p)), p)) +
    ggplot2::geom_col(ggplot2::aes(fill = {{ var }})) +
    ggplot2::scale_fill_brewer(palette = palette, guide = FALSE) +
    ggplot2::scale_y_continuous(labels = scales::percent) +
    ggplot2::labs(
      x = title_var,
      y = "Percent",
      ...
    )
  flip_plot <- base_plot + ggplot2::coord_flip()
  if (!flip) {
    return(base_plot)
  } else {
    return(flip_plot)
  }
}
