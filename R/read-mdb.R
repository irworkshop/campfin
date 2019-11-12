#' Read Microsoft Access tables
#'
#' Wraps around [readr::read_csv()] and the `mdb-export` command line tool.
#'
#' @param file A path to a `.mdb` file.
#' @param table A character string to a table name (see [mdb_tables()]).
#' @param ... Additional arguments passed to [readr::read_csv()].
#' @return A tibble.
#' @importFrom readr read_csv
#' @export
read_mdb <- function(file, table, ...) {
  read_csv(
    file = system(command = paste("mdb-export", file, table), intern = TRUE),
    ...
  )
}

#' Get tables from Microsoft Access file
#'
#' Wraps around the `mdb-tables` command line tool.
#'
#' @param file A path to a .mdb file.
#' @return A vector of table names.
#' @importFrom readr read_csv
#' @export
mdb_tables <- function(file) {
  system(paste("mdb-tables -1", file), intern = TRUE)
}
