#' @title Check if All Files are New
#' @description This function tests whether all the files in a directory have a
#'   modification date equal to the system date. Useful when repeatedly running
#'   code with a lengthy download stage. Many state databases are updated daily,
#'   so new data can be helpful but not always neccesary. Set this function in
#'   an `if` statement.
#' @param path The path to a directory to check.
#' @param glob A pattern to search for files (e.g., "*.csv").
#' @param ... Arguments to be passed to `fs::dir_ls()`
#' @return logical; whether _all_ files in the directory have a modification
#'   date equal to today.
#' @importFrom fs dir_ls file_info
#' @importFrom lubridate today floor_date
#' @importFrom purrr is_empty
#' @importFrom magrittr use_series equals
#' @importFrom rlang .data
#' @examples
#' if (!all_files_new(tempdir())) {
#'   download.file(
#'     url = "http://212.183.159.230/5MB.zip",
#'     destfile = tempfile()
#'   )
#' }
#' @export
all_files_new <- function(path, glob = NULL, ...) {
  files <- fs::dir_ls(path = path, ...)
  if (!is_empty(files)) {
    file_times <- fs::file_info(files)$modification_time
    file_days <- lubridate::floor_date(file_times, unit = "day")
    all_today <- all(file_days == lubridate::today())
    return()
  } else {
    warning("Directory is empty, proceeding.")
    return(FALSE)
  }
}

#' @title Check if This File is New
#' @description This function tests whether a single file has a modification
#'   date equal to the system date. Useful when repeatedly running code with a
#'   lengthy download stage. Many state databases are updated daily, so new data
#'   can be helpful but not always neccesary. Set this function in an `if`
#'   statement.
#' @param path The path to a file to check.
#' @return logical; whether the files has a modification date equal to today.
#' @importFrom lubridate today floor_date
#' @importFrom magrittr use_series equals
#' @examples
#' temp <- tempfile()
#' if (!this_file_new(temp)) {
#'   download.file(
#'     url = "http://212.183.159.230/5MB.zip",
#'     destfile = temp
#'   )
#' }
#' @export
this_file_new <- function(path) {
  if (!file.exists(path)) {
    warning("File does not exist, proceeding.")
    new <- FALSE
  } else {
    mod_day <- lubridate::floor_date(file.mtime(path), unit = "day")
    new <- mod_day == lubridate::today()
  }
  return(new)
}
