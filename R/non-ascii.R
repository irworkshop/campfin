#' Show non-ASCII lines of file
#'
#' @param path The path to a text file to check.
#' @param highlight A function used to add ANSI escapes to highlight bytes.
#' @examples
#' non_ascii(system.file("README.md", package = "campfin"))
#' @return Tibble of line locations.
#' @importFrom stringr str_locate_all str_sub
#' @export
non_ascii <- function(path, highlight = FALSE) {
  x <- readLines(path, warn = FALSE)
  asc <- iconv(x, "latin1", "ASCII")
  ind <- is.na(asc) | asc != x
  if (any(ind)) {
    bad <- iconv(x[ind], "latin1", "ASCII", sub = "byte")
    if (is.function(highlight)) {
      # from stringr::str_view_all()
      loc <- stringr::str_locate_all(bad, "<[0-9a-fA-F]+>")
      string_list <- Map(loc = loc, string = bad, f = function(loc, string) {
        if (nrow(loc) == 0) {
          return(string)
        } else {
          for (i in rev(seq_len(nrow(loc)))) {
            hl <- highlight(stringr::str_sub(string, loc[i, , drop = FALSE]))
            stringr::str_sub(string, loc[i, , drop = FALSE]) <- hl
          }
        }
        string
      })
      bad <- unlist(string_list)
    }
    tibble::tibble(
      row = which(ind),
      line = bad
    )
  } else {
    FALSE
  }
}



