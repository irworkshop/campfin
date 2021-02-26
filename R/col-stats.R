#' Apply a statistic function to all column vectors
#'
#' Apply a counting summary function like [dplyr::n_distinct()] or [count_na()]
#' to every column of a data frame and return the results along with a
#' _percentage_ of that value.
#'
#' @param data A data frame to glimpse.
#' @param fun A function to map to each column.
#' @param print logical; Should all columns be printed as rows?
#' @return A tibble with a row for every column with the count and proportion.
#' @examples
#' col_stats(dplyr::storms, dplyr::n_distinct)
#' col_stats(dplyr::storms, campfin::count_na)
#' @importFrom purrr map
#' @importFrom dplyr mutate select
#' @importFrom tibble enframe
#' @importFrom rlang as_label .data
#' @export
col_stats <- function(data, fun, print = TRUE) {
  if (class(fun) != "function") {
    stop("The fun argument must be a function.")
  }
  if ("data.frame" %out% class(data)) {
    stop("The data argument must be a data frame or similar.")
  }
  stats <- unlist(purrr::map(data, fun))
  if (!is.numeric(stats) | length(stats) != ncol(data)) {
    stop("The return of fun must be numeric length one.")
  }
  summary <- stats %>%
    tibble::enframe(name = "col", value = "n") %>%
    dplyr::mutate(p = .data$n / nrow(data)) %>%
    dplyr::mutate(class = purrr::map_chr(data, rlang::as_label)) %>%
    dplyr::select(.data$col, .data$class, .data$n, .data$p)
  if (print) {
    print(summary, n = length(data))
  } else {
    return(summary)
  }
}

#' @rdname col_stats
#' @export
glimpse_fun <- function(data, fun, print = TRUE) {
  .Deprecated("col_stats")
  summary <- data %>%
    purrr::map_dbl({{ fun }}) %>%
    tibble::enframe(name = "col", value = "n") %>%
    dplyr::mutate(p = .data$n / nrow(data)) %>%
    dplyr::mutate(type = format(purrr::map(data, rlang::as_label))) %>%
    dplyr::select(.data$col, .data$type, .data$n, .data$p)
  if (print) {
    print(summary, n = length(data))
  }
}
