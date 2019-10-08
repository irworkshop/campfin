#' @title Form a Word Break Regex
#' @description Wrape a word in word boundry (`\\b`) characters. Useful when
#'   combined with [stringr::str_which()] and [stringr::str_detect()] to match
#'   only entire words and not that word _inside_ another word (e.g., "sting"
#'   and "testing").
#' @param pattern A regex pattern (a word) to wrap in `\\b`.
#' @return The `pattern` wrapped in `\\b`.
#' @importFrom glue glue
#' @examples
#' rx_break("test")
#' rx_break(state.abb)
#' @export
rx_break <- function(pattern) {
  glue::glue("\\b{pattern}\\b")
}
