#' Make a File Path from a URL
#'
#' Useful in the `destfile` argument to [download.file()] to save a file with
#' the same name as the URL's file name.
#'
#' @description Combine the [basename()] of a file URL with a directory path.
#' @param url The URL of a file to download.
#' @param dir The directory where the file will be downloaded.
#' @return The desired file path to a URL file.
#' @importFrom fs as_fs_path
#' @examples
#' url2path("https://floridalobbyist.gov/reports/llob.txt", tempdir())
#' @export
url2path <- function(url, dir) {
  fs::path(dir, basename(url))
}
