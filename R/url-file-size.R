#' Check a URL file size
#'
#' Call [httr::HEAD()] and return the number of bytes in the file to be
#' downloaded.
#'
#' @param url The URL of the file to query.
#' @param format logical; Whether to format as byte measurement and symbol.
#' @return The size of a file to be downloaded.
#' @importFrom httr HEAD headers
#' @importFrom scales number_bytes
#' @examples
#' url_file_size("https://campaignfinance.cdn.sos.ca.gov/dbwebexport.zip", format = TRUE)
#' @export
url_file_size <- function(url, format = FALSE) {
  file_head <- httr::HEAD(url = url)
  file_length <- as.numeric(httr::headers(file_head)[["content-length"]])
  if (format) {
    file_length <- scales::number_bytes(file_length)
  }
  return(file_length)
}
