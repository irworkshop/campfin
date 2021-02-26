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
#' @importFrom dplyr select
#' @examples
#' flag_dupes(iris, dplyr::everything())
#' flag_dupes(iris, dplyr::everything(), .both = FALSE)
#' @export
flag_dupes <- function(data, ..., .check = TRUE, .both = TRUE) {
  sub_data <- dplyr::select(data, ...)
  dupe <- duplicated(sub_data, fromLast = FALSE)
  if (.both && any(dupe)) {
    d2 <- duplicated(sub_data, fromLast = TRUE)
    dupe <- dupe | d2
    rm(d2)
  }
  rm(sub_data)
  flush_memory(1)
  if (.check & !any(dupe)) {
    warning("no duplicate rows, column not created")
  } else {
    data$dupe_flag <- dupe
  }
  data
}
