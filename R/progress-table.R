#' Create a progress table
#'
#' Create a tibble with rows for each stage of normalization and columns for the
#' various statistics most useful in assessing the progress of each stage.
#'
#' @param ... Any number of vectors to check.
#' @param compare A vector to compare each of `...` against. Useful
#'     with [valid_zip], [valid_state] ([valid_name]), or
#'     [valid_city].
#' @return A table with a row for each vector in `...`.
#' @importFrom stringr str_remove
#' @importFrom tibble tibble add_row
#' @importFrom dplyr n_distinct
#' @family Simple Counting Wrappers
#' @examples
#' progress_table(state.name, toupper(state.name), compare = valid_name)
#' @export
progress_table <- function(..., compare) {
  table <- tibble::tibble(
    stage = character(),
    prop_in = double(),
    n_distinct = double(),
    prop_na = double(),
    n_out = double(),
    n_diff = double()
  )
  extra <- list(...)
  names(extra) <- lapply(substitute(list(...))[-1], deparse)
  if (!is_empty(extra)) {
    for (i in seq_along(extra)) {
      table <- table %>% tibble::add_row(
        stage = names(extra)[i],
        prop_in = prop_in(extra[[i]], compare),
        n_distinct = dplyr::n_distinct(extra[[i]]),
        prop_na = prop_na(extra[[i]]),
        n_out = count_out(extra[[i]], compare),
        n_diff = length(setdiff(extra[[i]], compare)),
      )
    }
  }
  table
}
