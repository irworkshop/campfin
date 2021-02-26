#' Parse USA date columns in readr functions
#'
#' Parse dates with format MM/DD/YYYY. This function simply wraps around
#' [readr::col_date()] with the `format` argument set to `"%m/%d/%Y"`. Many US
#' campaign finance datasets use this format.
#'
#' @return A `POSIXct` vector.
#' @importFrom readr col_date cols
#' @examples
#' readr::read_csv(file = "x\n11/09/2016", col_types = readr::cols(x = col_date_mdy()))
#' @export
col_date_mdy <- function() {
  readr::col_date(format = "%m/%d/%Y")
}

#' @rdname col_date_mdy
#' @export
col_date_usa <- function() {
  .Deprecated("col_date_mdy")
  readr::col_date(format = "%m/%d/%Y")
}
