#' Print All
#'
#' Call the [print()] method with `n` set to `Inf`.
#'
#' @details `print(x, n = Inf)`
#' @param x An object used to select a method.
#' @examples
#' print_all(state.name)
#' @importFrom tibble is_tibble
#' @export
print_all <- function(x) {
  if (tibble::is_tibble(x)) {
    print(x, n = Inf)
  } else {
    print(x)
    warning("intended for use with tibble rows")
  }
}
