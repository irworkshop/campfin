#' Read column names
#'
#' Read the first line of a delimited file as vector.
#'
#' @param file Path to text file.
#' @param delim Character separating column names.
#' @return Character vector of column names.
#' @examples
#' read_names("date,lgl\n11/09/2016,TRUE")
#' @importFrom readr read_delim cols
#' @export
read_names <- function(file, delim = guess_delim(file)) {
  names(readr::read_delim(file, delim, n_max = 0, col_types = readr::cols(.default = "c")))
}
