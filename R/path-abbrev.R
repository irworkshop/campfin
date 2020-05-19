#' Abbreviate a file path
#'
#' This is an inverse of [path.expand()], which replaces the home directory or
#' project directory with a tilde.
#'
#' @param path Character vector containing one or more full paths.
#' @param dir The directory to replace with `~`. Defaults to [here::here()].
#' @return Abbreviated file paths.
#' @examples
#' print(here::here())
#' path.abbrev(here::here("test"))
#' @importFrom stringr str_replace
#' @importFrom here here
#' @export
path.abbrev <- function(path, dir = here::here()) {
  stringr::str_replace(path, dir, "~")
}
