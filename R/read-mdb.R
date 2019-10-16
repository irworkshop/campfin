#' Read Microsoft Access Table
#'
#' @description Wraps around `readr::read_csv()` and `mdb-export`
#' @param file A path to a .mdb file
#' @param table A character string to a table name (see `mdb_tables()`)
#' @param ... Arguments to be passed to `readr::read_csv()`
#' @return A tibble
#' @importFrom readr read_csv
#' @export
read_mdb <- function(file, table, ...) {
  read_csv(
    file = system(command = paste("mdb-export", file, table), intern = TRUE),
    ...
  )
}

#' Get Tables from Microsoft Access File
#'
#' @description Wraps around `mdb-tables`
#' @param file A path to a .mdb file
#' @return A vector of table names
#' @importFrom readr read_csv
mdb_tables <- function(file) {
  system(paste("mdb-tables -1", file), intern = TRUE)
}
