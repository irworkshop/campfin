#' Invert a named vector
#'
#' Invert the names and elements of a vector, useful when using named vectors as
#' the abbreviation arguments both of [expand_abbrev()] and [abbrev_full()] (or
#' their parent normalization functions like [normal_address()])
#'
#' @param x A named vector.
#' @return A named vector with names in place of elements and _vice versa_.
#' @importFrom rlang set_names
#' @examples
#' invert_named(x = c("name" = "element"))
#' @export
invert_named <- function(x) {
  if (is.null(names(x))) {
    stop("Vector is unnamed, use rlang::set_names() to... well, set names")
  }
  rlang::set_names(names(x), unname(x))
}
