#' File modification date age
#'
#' The period of time since a system file was modified.
#'
#' @param ... Arguments passed to [file.info()], namely character vectors
#'   containing file paths. Tilde-expansion is done: see [path.expand()].
#' @examples
#' file_age(system.file("README.md", package = "campfin"))
#' @importFrom lubridate as.period
#' @return A Period class object.
#' @export
file_age <- function(...) {
  finfo <- file.info(...)
  lubridate::as.period(Sys.time() - finfo$mtime)
}
