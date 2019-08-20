#' Check URL File Size
#'
#' @param url The url of the page to retrieve
#' @param format Whether to format as byte measurment and symbol (e.g., Mb)
#' @return The size of a file to be downloaded
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
