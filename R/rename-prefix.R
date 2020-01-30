#' Convert data frame name suffixes to prefixes
#'
#' When performing a [dplyr::left_join()], the `suffix` argument allows the user
#' to replace the default `.x` and `.y` that are appended to column names shared
#' between the two data frames. This function allows a user to convert those
#' suffixes to _prefixes_.
#'
#' @param df A joined data frame.
#' @param suffix If there are non-joined duplicate variables in x and y, these
#'   suffixes will be added to the output to disambiguate them. Should be a
#'   character vector of length 2. Will be converted to prefixes.
#' @param punct logical; Should punctuation at the start of the suffix be
#'   detected and placed at the end of the new prefix? `TRUE` by default.
#' @return A data frame with new column names.
#' @importFrom stringr str_replace str_extract
#' @importFrom glue glue
#' @examples
#' a <- data.frame(x = letters[1:3], y = 1:3)
#' b <- data.frame(x = letters[1:3], y = 4:6)
#' df <- dplyr::left_join(a, b, by = "x", suffix = c(".a", ".b"))
#' rename_prefix(df, suffix = c(".a", ".b"), punct = TRUE)
#' @export
rename_prefix <- function(df, suffix = c(".x", ".y"), punct = TRUE) {
  if (length(suffix) != 2) {
    stop("there must be two suffixes")
  }
  if (punct) {
    punct <- unique(stringr::str_extract(suffix, "[:punct:]"))
    prefix <- stringr::str_replace(
      string = suffix,
      pattern = glue::glue("{punct}(.*)"),
      replacement = glue::glue("\\1{punct}")
    )
  } else {
    prefix <- suffix
  }
  nm <- names(df)
  nm <- stringr::str_replace(
    string = nm,
    pattern = glue::glue("^(.*){suffix[[1]]}$"),
    replacement = glue::glue("{prefix[[1]]}\\1")
  )
  nm <- stringr::str_replace(
    string = nm,
    pattern = glue::glue("^(.*){suffix[[2]]}$"),
    replacement = glue::glue("{prefix[[2]]}\\1")
  )
  names(df) <- nm
  return(df)
}
