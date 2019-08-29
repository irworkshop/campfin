#' Check if All Files Are New
#'
#' @param path The path to a directory to check.
#' @param glob A pattern to search for files (e.g., "csv").
#' @param ... Arguments to be passed to \code{fs::dir_ls()}
#' @return A logical value indicating whether or not all files in the directory have a modification date equal to today.
#' @importFrom fs dir_ls file_info
#' @importFrom lubridate today floor_date
#' @importFrom purrr is_empty
#' @importFrom magrittr use_series equals
#' @export
all_files_new <- function(path, glob = NULL, ...) {
  files <- fs::dir_ls(path = path, ...)
  if (!is_empty(files)) {
    files %>%
      fs::file_info() %>%
      magrittr::use_series(modification_time) %>%
      lubridate::floor_date(unit = "day") %>%
      magrittr::equals(lubridate::today()) %>%
      base::all() %>%
      base::return()
  } else {
    base::warning("Empty")
    base::return(FALSE)
  }
}

#' Check if a File is New
#'
#' @param path The path to a file to check.
#' @return A logical value indicating whether or a file has modification date equal to today.
#' @importFrom lubridate today
#' @importFrom magrittr use_series equals
#' @export
this_file_new <- function(path) {
  if (!file.exists(path)) {
    warning("File does not exist")
    new <- FALSE
  } else {
    mod_day <- lubridate::floor_date(file.mtime(path), unit = "day")
    new <- mod_day == lubridate::today()
  }
  return(new)
}
