#' @title Make a File Path from a URL
#' @details Useful in the `destfile` argument to [download.file()] to save a
#'   file with the same name as the URL's file name.
#' @description Combine the [basename()] of a file URL with the path to a
#'   directory.
#' @param url The URL of a file to download.
#' @param dir The directory where the file will be downloaded.
#' @return The desired file path to a URL file.
#' @importFrom stringr str_c
#' @examples
#' url2path("https://floridalobbyist.gov/reports/llob.txt", "~/Downloads")
#' @export
url2path <- function(url, dir) {
  stringr::str_c(path.expand(dir), basename(url), sep = "/")
}
