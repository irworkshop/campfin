#' @title Glimpse Column Count Functions
#' @description Apply a counting summary function like [dplyr::n_distinct()] or
#'   [count_na()] to every column of a dataframe and return the results along
#'   with a _percentage_ of that value.
#' @param data A data frame to glimpse.
#' @param fun A function to map to each column.
#' @return A tibble with a row for every column and new columns with count and
#'   proportion.
#' @examples
#' glimpse_fun(dplyr::storms, dplyr::n_distinct)
#' @importFrom purrr map
#' @importFrom dplyr mutate select
#' @importFrom tibble enframe
#' @importFrom pillar new_pillar_type
#' @export
glimpse_fun <- function(data, fun, print = TRUE) {
  summary <- data %>%
    purrr::map_dbl({{ fun }}) %>%
    tibble::enframe(name = "col", value = "n") %>%
    dplyr::mutate(p = .data$n / nrow(data)) %>%
    dplyr::mutate(type = format(purrr::map(data, pillar::new_pillar_type))) %>%
    dplyr::select(.data$var, .data$type, .data$n, .data$p)
  if (print) {
    print(summary, n = length(data))
  }
}

#' Count NA Values
#'
#' @description Wrap around `sum(is.na())`
#' @param x A vector to count `NA`
#' @return The number of `NA` values in a vector
#' @examples
#' count_na(dplyr::starwars$gender)
#' @export
count_na <- function(x) {
  sum(is.na(x))
}

#' Count NA Proportion
#'
#' @description Wrap around `mean(is.na())`
#' @param x A vector to count `NA`
#' @param format Should the output use `scales::percent()`?
#' @return The proportion of `NA` values in a vector
#' @examples
#' prop_na(dplyr::starwars$gender)
#' @export
prop_na <- function(x, format = FALSE) {
  prop <- mean(is.na(x))
  if (format) {
    scales::percent(mean)
  }
  return(prop)
}
