#' Guess the delimiter of a text file
#'
#' Taken from code used in [vroom::vroom()] with automatic reading.
#'
#' @param path The path of a delimited file to read.
#' @param delims The single characters to guess from.
#' @examples
#' guess_delim(system.file("extdata", "vt_contribs.csv", package = "campfin"))
#' @source <https://github.com/r-lib/vroom/blob/7b7e775fd6d4261532116bcc881879f9439f29df/R/vroom.R>
#' @return The single character guessed as a delimiter.
#' @export
guess_delim <- function(path, delims = c(",", "\t", " ", "|", ":", ";")) {
  lines <- readLines(path, n = 2L)
  if (length(lines) == 0) {
    return("")
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
