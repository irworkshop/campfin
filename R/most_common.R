#' Most Common Values
#'
#' @param x A vector
#' @param n number of values to return
#' @return Sorted vector of `n` most common values
#' @examples
#' most_common(dplyr::storms$month, 3)
#' @export
most_common <- function(x, n = 6) {
  as.vector(na.omit(names(sort(table(x), decreasing = TRUE)[1:n])))
}
