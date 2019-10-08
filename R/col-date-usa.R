#' Parse USA Date Columns in readr Functions
#'
#' @description Parse dates with format MM/DD/YYYY. This function simply wraps around
#' [readr::col_date()] with the `format` argument set to `"%m/%d/%Y"`. Most US campaign finance
#' datasets use this format. Does not work with [vroom::vroom()] version 1.0.2.9000 or lower.
#' @return A `POSIXct()` vector.
#' @importFrom readr col_date cols
#' @examples
#' readr::read_csv(file = "x\n09/18/1996", col_types = readr::cols(x = col_date_usa()))
#' @export
col_date_usa <- function() {
  readr::col_date(format = "%m/%d/%Y")
}
