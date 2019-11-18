#' Find most common values
#'
#' From a character vector, which values are most common?
#'
#' @param x A vector.
#' @param n Number of values to return.
#' @return Sorted vector of `n` most common values.
#' @examples
#' most_common(iris$Species, n = 1)
#' @export
most_common <- function(x, n = 6) {
  as.vector(na.omit(names(sort(table(x), decreasing = TRUE)[1:n])))
}
