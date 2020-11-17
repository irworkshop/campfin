#' Abbreviate a file path
#'
#' This is an inverse of [path.expand()], which replaces the home directory or
#' project directory with a tilde.
#'
#' @param path Character vector containing one or more full paths.
#' @param dir The directory to replace with `~`. Defaults to [here::here()].
#' @return Abbreviated file paths.
#' @examples
#' print(here::here("test"))
#' path.abbrev(here::here("test"))
#' @importFrom stringr str_replace
#' @importFrom fs path_wd as_fs_path
#' @export
path.abbrev <- function(path, dir = fs::path_wd()) {
  fs::as_fs_path(stringr::str_replace(path, dir, "~"))
}
