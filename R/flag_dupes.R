#' Flag Duplicate Rows
#'
#' @param df A data frame
#' @param  ... Arguments to pass to dplyr::select() (e.g., dplyr::everything())
#' @return A data frame with a new `dupe_flag` logical variable
#' @importFrom dplyr mutate
#' @examples
#' flag_dupes(iris, dplyr::everything())
#' @export
  flag_dupes <- function(df, ...) {
    sub_df <- dplyr::select(df, ...)
    dupe_vec <- duplicated(sub_df)
    flagged_df <- dplyr::mutate(df, dupe_flag = dupe_vec)
    rm(sub_df, dupe_vec)
    flagged_df
  }
