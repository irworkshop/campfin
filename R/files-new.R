#' Check if all files in a directory are new
#'
#' Tests whether all the files in a given directory have a modification date
#' equal to the system date. Useful when repeatedly running code with a lengthy
#' download stage. Many state databases are updated daily, so new data can be
#' helpful but not always necessary. Set this function in an `if` statement.
#'
#' @param path The path to a directory to check.
#' @param glob A pattern to search for files (e.g., "*.csv").
#' @param ... Additional arguments passed to [fs::dir_ls()].
#' @return logical; Whether [all()] files in the directory have a modification
#'   date equal to today.
#' @importFrom fs dir_ls file_info
#' @importFrom lubridate today floor_date
#' @importFrom magrittr use_series equals
#' @importFrom rlang .data is_empty
#' @examples
#' tmp <- tempdir()
#' file.create(tempfile(pattern = as.character(1:5)))
#' all_files_new(tmp)
#' @export
all_files_new <- function(path, glob = NULL, ...) {
  files <- fs::dir_ls(path = path, ...)
  if (rlang::is_empty(files)) {
    warning("directory is empty, returning FALSE (and proceeding)")
    return(FALSE)
  } else {
    file_info <- fs::file_info(files)
    file_times <- file_info$modification_time
    file_days <- lubridate::floor_date(file_times, unit = "day")
    all(file_days == lubridate::today())
  }
}

#' Check if a single file is new
#'
#' This function tests whether a single file has a modification date equal to
#' the system date. Useful when repeatedly running code with a lengthy download
#' stage. Many state databases are updated daily, so new data can be helpful but
#' not always necessary. Set this function in an `if` statement.
#'
#' @param path The path to a file to check.
#' @return logical; Whether the file has a modification date equal to today.
#' @importFrom lubridate today floor_date
#' @importFrom magrittr use_series equals
#' @examples
#' tmp <- tempfile()
#' this_file_new(tmp)
#' @export
this_file_new <- function(path) {
  if (all(!file.exists(path))) {
    warning("file does not exist, proceeding.")
    new <- FALSE
  } else {
    mod_day <- lubridate::floor_date(file.mtime(path), unit = "day")
    new <- mod_day == lubridate::today()
  }
  return(new)
}
