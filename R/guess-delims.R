#' Guess the delimiter of a text file
#'
#' @description
#' Taken from code used in [vroom::vroom()][1] with automatic reading.
#'
#' [1]: https://github.com/r-lib/vroom/blob/master/R/vroom.R#L248
#'
#' @param file Either a path to a file or character string (with at least one
#'   newline character).
#' @param delims The vector of single characters to guess from. Defaults to:
#' comma, tab, pipe, or semicolon.
#' @param string Should the file be treated as a string regardless of newline.
#' @examples
#' guess_delim(system.file("extdata", "vt_contribs.csv", package = "campfin"))
#' guess_delim("ID;FirstName;MI;LastName;JobTitle", string = TRUE)
#' guess_delim("
#' a|b|c
#' 1|2|3
#' ")
#' @source <https://github.com/r-lib/vroom/blob/master/R/vroom.R#L248>
#' @return The single character guessed as a delimiter.
#' @export
guess_delim <- function(file, delims = c(",", "\t", "|", ";"), string = FALSE) {
  if (isTRUE(string) | grepl("\n", file)) {
    lines <- file
  } else {
    lines <- readLines(file, n = 2L)
    if (length(lines) == 0) {
      return("")
    }
  }

  # blank text within quotes
  lines <- gsub('"[^"]*"', "", lines)

  splits <- lapply(delims, strsplit, x = lines, useBytes = TRUE, fixed = TRUE)

  counts <- lapply(splits, function(x) table(lengths(x)))

  num_fields <- vapply(counts, function(x) as.integer(names(x)[[1]]), integer(1))

  num_lines <- vapply(counts, function(x) (x)[[1]], integer(1))

  top_lines <- 0
  top_idx <- 0
  for (i in seq_along(delims)) {
    if (num_fields[[i]] >= 2 && num_lines[[i]] > top_lines ||
        (top_lines == num_lines[[i]] && (top_idx <= 0 || num_fields[[top_idx]] < num_fields[[i]]))) {
      top_lines <- num_lines[[i]]
      top_idx <- i
    }
  }
  if (top_idx == 0) {
    stop("Could not guess the delimiter", call. = FALSE)
  }

  delims[[top_idx]]
}
