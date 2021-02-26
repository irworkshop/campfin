#' Check a URL file size
#'
#' Call [httr::HEAD()] and return the number of bytes in the file to be
#' downloaded.
#'
#' @param url The URL of the file to query.
#' @return The size of a file to be downloaded.
#' @importFrom httr HEAD headers
#' @importFrom fs as_fs_bytes
#' @examples
#' url_file_size("https://cran.r-project.org/bin/macosx/old/R-2.0.1.dmg")
#' @export
url_file_size <- function(url) {
  file_head <- httr::HEAD(url = url)
  file_length <- as.numeric(httr::headers(file_head)[["content-length"]])
  fs::as_fs_bytes(file_length)
}
