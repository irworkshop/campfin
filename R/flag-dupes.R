#' Flag Duplicate Rows With New Column
#'
#' This function uses [dplyr::mutate()] to create a new `dupe_flag` logical
#' variable with `TRUE` values for any record duplicated more than once.
#'
#' @param data A data frame to flag.
#' @param ... Arguments passed to [dplyr::select()] (needs to be at least
#'   [dplyr::everything()]).
#' @return A data frame with a new `dupe_flag` logical variable.
#' @importFrom dplyr mutate
#' @examples
#' flag_dupes(iris, dplyr::everything())
#' @export
flag_dupes <- function(data, ...) {
  sub_data <- dplyr::select(data, ...)
  dupe_vec <- duplicated(sub_data)
  dplyr::mutate(data, dupe_flag = dupe_vec)
}
