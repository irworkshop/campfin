#' Extract a content file name from HTTP request headers
#'
#' @param x An [httr::GET()] request object.
#' @return File name character string
#' @importFrom httr headers
#' @importFrom stringr str_extract
#' @export
http_filename <- function(x) {
  cd <- httr::headers(x)[["content-disposition"]]
  if (is.null(cd)) {
    stop("no content disposition found")
  } else {
    stringr::str_extract(cd, "(?<=filename\\=).*")
  }
}
