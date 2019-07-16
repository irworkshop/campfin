#' Check for All New Files
#'
#' @param path The path to a directory to check.
#' @param glob A pattern to search for files (e.g., "csv").
#' @return A logical value indicating whether or not all files in the directory have a modification date equal to today.
#' @importFrom fs dir_ls file_info
#' @importFrom lubridate today floor_date
#' @importFrom purrr is_empty
#' @importFrom magrittr use_series equals
#' @export
all_files_new <- function(path, glob = NULL) {
  files <- fs::dir_ls(path = path, glob = glob)
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
