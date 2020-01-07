#' Print All
#'
#' Call the [print()] method with `n` set to `Inf`.
#'
#' @details `print(x, n = Inf)`
#' @param x An object used to select a method.
#' @examples
#' print_all(state.name)
#' @export
print_all <- function(x) {
  print(x, n = Inf)
}
