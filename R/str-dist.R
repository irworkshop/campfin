#' Calculate string distance
#'
#' This function wraps around [stringdist::stringdist()].
#'
#' @param a `R` object (target); will be converted by [base::as.character()].
#' @param b `R` object (source); will be converted by [base::as.character()].
#' @param method Method for distance calculation. The default is "osa."
#' @param ... Other arguments passed to [stringdist::stringdist()].
#' @return The distance between string `a` and string `b`.
#' @importFrom stringdist stringdist
#' @examples
#' str_dist(a = "BRULINGTN", b = "BURLINGTON")
#' @export
str_dist <- function(a, b, method = "osa", ...) {
  stringdist::stringdist(a, b, method)
}
