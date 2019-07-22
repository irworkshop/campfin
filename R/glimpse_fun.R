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
#' @export
glimpse_fun <- function(data, fun) {
  summary <- data %>%
    map(fun) %>%
    unlist() %>%
    enframe(name = "var", value = "n") %>%
    mutate(p = n / nrow(data)) %>%
    mutate(type = format(map(data, pillar::new_pillar_type))) %>%
    select(var, type, n, p)
  print(summary, n = length(data))
}

#' Count NA Values
#'
#' @param x A vector to count `NA`
#' @return The number of `NA` values in a vector
#' @examples
#' count_na(dplyr::starwars$gender)
#' @export
count_na <- function(x) {
  sum(is.na(x))
}
