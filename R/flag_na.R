#' Flag Missing Values With New Column
#'
#' @description This function uses [dplyr::mutate()] to create a new `dupe_flag` logical variable
#' with `TRUE` values for any record duplicated more than once.
#' @param data A data frame to flag.
#' @param  ... Arguments passed to [dplyr::select()] (needs to be at least [dplyr::everything()]).
#' @return A data frame with a new `na_flag` logical variable.
#' @importFrom dplyr mutate select
#' @importFrom stats complete.cases
#' @examples
#' flag_na(dplyr::starwars, gender)
#' @export
flag_na <- function(data, ...) {
  dplyr::mutate(data, na_flag = !stats::complete.cases(dplyr::select(data, ...)))
}
