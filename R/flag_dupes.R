#' Flag Duplicate Rows
#'
#' @param df A data frame
#' @param  ... Arguments to pass to dplyr::select() (e.g., dplyr::everything())
#' @return A data frame with a new `dupe_flag` logical variable
#' @importFrom dplyr mutate
#' @example
#' sum(flag_dupes(iris)$dupe_flag)
#' @export
flag_dupes <- function(df, ...) {
  flagged_data <- dplyr::mutate(df, dupe_flag = base::duplicated(dplyr::select(df, ...)))
  return(flagged_data)
}
