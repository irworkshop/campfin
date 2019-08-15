#' Ready Microsoft Access Tables
#'
#' @description Wraps around `readr::read_csv()` and MDB Tools
#' @return A tibble
#' @importFrom readr read_csv
#' @export
read_mdb <- function(data, table, ...) {
  read_csv(
    file = system(command = paste("mdb-export", data, table), intern = TRUE),
    ...
  )
}
