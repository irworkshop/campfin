#' Flag Missing Values
#'
#' @param data A data frame
#' @param ... Column names passed to \code{dplyr::select()} and checked for \code{NA}
#' @return A data frame with a new `na_flag` logical variable
#' @importFrom dplyr mutate select
#' @importFrom stats complete.cases
#' @examples
#' flag_na(dplyr::storms, ts_diameter)
#' @export
flag_na <- function(data, ...) {
  dplyr::mutate(data, na_flag = !stats::complete.cases(dplyr::select(data, ...)))
}
