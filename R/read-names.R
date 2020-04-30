#' Read column names
#'
#' Read the first line of a delimited file as vector.
#'
#' @param file Path to text file.
#' @param delim Character separating column names.
#' @return Character vector of column names.
#' @examples
#' read_names("x\n11/09/2016")
#' @importFrom readr read_delim cols
#' @export
read_names <- function(file, delim = ",") {
  names(readr::read_delim(file, delim, n_max = 0, col_types = readr::cols(.default = "c")))
}
