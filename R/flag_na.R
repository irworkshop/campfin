#' Flag Missing Values
#'
#' @param df A data frame
#' @return A data frame with a new `na_flag` logical variable
#' @importFrom dplyr mutate select
#' @examples
#' flag_na(dplyr::storms, ts_diameter)
#' @export
flag_na <- function(data, ...) {
  dplyr::mutate(data, na_flag = !complete.cases(dplyr::select(data, ...)))
}
