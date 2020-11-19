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
#' @param .both Whether to flag both duplicates or just subsequent.
#' @return A data frame with a new `dupe_flag` logical variable.
#' @importFrom dplyr select mutate everything
#' @examples
#' flag_dupes(iris, dplyr::everything())
#' flag_dupes(iris, dplyr::everything(), .both = FALSE)
#' @export
flag_dupes <- function(data, ..., .check = TRUE, .both = TRUE) {
  sub_data <- dplyr::select(data, ...)
  if (.both) {
    d1 <- duplicated(sub_data, fromLast = FALSE)
    flush_memory(1)
    d2 <- duplicated(sub_data, fromLast = TRUE)
    flush_memory(1)
    dupe_vec <- d1 | d2
    rm(d1, d2)
    flush_memory(1)
  } else {
    dupe_vec <- duplicated(sub_data)
    flush_memory(1)
  }
  if (.check & sum(dupe_vec) == 0) {
    warning("no duplicate rows, column not created")
    return(data)
  } else {
    dplyr::mutate(data, dupe_flag = dupe_vec)
  }
}
