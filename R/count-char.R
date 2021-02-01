#' Count values in a character vector
#'
#' Method for [dplyr::count()]
#'
#' @param x A character vector.
#' @param sort If `TRUE`, sort the result so that the most common values float
#'   to the top.
#' @param prop If `TRUE`, compute the fraction of marginal table.
#' @examples
#' x <- sample(LETTERS)[rpois(1000, 10)]
#' table(x)
#' dplyr::count(x)
#' dplyr::count(x, sort = TRUE, prop = TRUE)
#' @importFrom tibble as_tibble
#' @return A tibble of element counts
#' @export
count.character <- function(x, sort = FALSE, prop = FALSE) {
  if (!is.character(x)) {
    stop("x must be a character vector", call. = FALSE)
  }
  tb <- table(x)
  if (sort) {
    tb <- rev(sort(tb))
  }
  df <- tibble::as_tibble(tb)
  if (prop) {
    df$p <- prop.table(df$n)
  }
  return(df)
}
