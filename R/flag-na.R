#' Flag Missing Values With New Column
#'
#' This function uses [dplyr::mutate()] to create a new `na_flag` logical
#' variable with `TRUE` values for any record missing _any_ value in the
#' selected columns.
#'
#' @param data A data frame to flag.
#' @param  ... Arguments passed to [dplyr::select()] (needs to be at least
#'   [dplyr::everything()]).
#' @return A data frame with a new `na_flag` logical variable.
#' @importFrom dplyr select
#' @importFrom stats complete.cases
#' @examples
#' flag_na(dplyr::starwars, hair_color)
#' @export
flag_na <- function(data, ...) {
  sub_data <- dplyr::select(data, ...)
  nas <- !stats::complete.cases(sub_data)
  data$na_flag <- nas
  data
}
