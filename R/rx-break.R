#' Form a word break regex pattern
#'
#' Wrap a word in word boundary (`\\b`) characters. Useful when combined with
#' [stringr::str_which()] and [stringr::str_detect()] to match only entire words
#' and not that word _inside_ another word (e.g., "sting" and "testing").
#'
#' @param pattern A regex pattern (a word) to wrap in `\\b`.
#' @return The a glue vector of `pattern` wrapped in `\\b`.
#' @importFrom glue glue
#' @examples
#' rx_break("test")
#' rx_break(state.abb[1:5])
#' @export
rx_break <- function(pattern) {
  glue::glue("\\b{pattern}\\b")
}
