#' Is Binary
#'
#' @param x A vector
#' @return TRUE if only 2 unique values
#' @importFrom dplyr n_distinct
#' @examples
#' is_binary(x = c("Yes", "No"))
#' @export
is_binary <- function(x) {
  dplyr::n_distinct(x) == 2
}
