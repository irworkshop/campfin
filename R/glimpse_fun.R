#' Check for All New Files
#'
#' @param data A data frame to glimpse.
#' @param fun A function to map to each column.
#' @return A tibble with a row for every column and new columns with count and proportion.
#' @examples
#' glimpse_fun(dplyr::storms, dplyr::n_distinct)
#' @importFrom purrr map
#' @importFrom dplyr mutate select
#' @importFrom tibble enframe
#' @importFrom pillar new_pillar_type
#' @export
glimpse_fun <- function(data, fun) {
  summary <- data %>%
    purrr::map({{ fun }}) %>%
    base::unlist() %>%
    tibble::enframe(name = "var", value = "n") %>%
    dplyr::mutate(p = .data$n / nrow(data)) %>%
    dplyr::mutate(type = format(purrr::map(data, pillar::new_pillar_type))) %>%
    dplyr::select(.data$var, .data$type, .data$n, .data$p)
  print(summary, n = length(data))
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
  if (format) {
    scales::percent(mean(is.na(x)))
  } else
    mean(is.na(x))
}
