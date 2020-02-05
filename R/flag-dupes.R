#' Flag Duplicate Rows With New Column
#'
#' This function uses [dplyr::mutate()] to create a new `dupe_flag` logical
#' variable with `TRUE` values for any record duplicated more than once.
#'
#' @param data A data frame to flag.
#' @param ... Arguments passed to [dplyr::select()] (needs to be at least
#'   [dplyr::everything()]).
#' @param .check Whether the resulting column should be summed and
#'   removed if empty.
#' @return A data frame with a new `dupe_flag` logical variable.
#' @importFrom dplyr mutate
#' @examples
#' flag_dupes(iris, dplyr::everything())
#' @export
flag_dupes <- function(data, ..., .check = TRUE) {
  sub_data <- dplyr::select(data, ...)
  dupe_vec <- duplicated(sub_data) | duplicated(sub_data, fromLast = TRUE)
  if (.check & sum(dupe_vec) == 0) {
    warning("no duplicate rows, column not created")
    return(data)
  } else {
    dplyr::mutate(data, dupe_flag = dupe_vec)
  }
}
