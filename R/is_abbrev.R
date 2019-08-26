#' Check if Abbreviation
#'
#' @param abb A suspected abbreviation
#' @param full A long form string to test against
#' @return A logical if `abb` is potential abbreviation of `full`
#' @importFrom stringr str_split
#' @importFrom dplyr lead
#' @examples
#' is_abbrev(abb = "BRX", full = "BRONX")
#' is_abbrev(abb = "BRX", full = "BROOKLYN")
#' @export
is_abbrev <- function(abb, full) {
  all(.all_inside(abb, full), .all_ordered(abb, full))
}

.all_inside <- Vectorize(
  function(x, y) {
    xs <- stringr::str_split(x, pattern = "", simplify = TRUE)
    ys <- stringr::str_split(y, pattern = "", simplify = TRUE)
    all(xs %in% ys)
  }
)
.all_ordered <- Vectorize(
  function(x, y) {
    xs <- stringr::str_split(x, pattern = "", simplify = TRUE)
    ys <- stringr::str_split(y, pattern = "", simplify = TRUE)
    match_order <- match(xs, ys)
    all(match_order < dplyr::lead(match_order), na.rm = TRUE)
  }
)
