#' Flag Duplicate Rows
#'
#' @param df A data frame
#' @return A data frame with a new `dupe_flag` logical variable
#' @importFrom dplyr mutate
#' @export
flag_dupes <- function(df) {
  flagged_data <- dplyr::mutate(df, dupe_flag = base::duplicated(df))
  return(flagged_data)
}
