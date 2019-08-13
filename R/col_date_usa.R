#' Parse USA (MDY) Dates
#'
#' @description Parse MM/DD/YYY dates
#' @return A `POSIXct()` vector
#' @importFrom readr col_date
#' @examples
#' readr::read_csv(file = "x\n09/18/1996", col_types = cols(x = col_date_usa()))
#' @export
col_date_usa <- function() {
  readr::col_date(format = "%m/%d/%Y")
}
