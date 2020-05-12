#' File Encoding
#'
#' Call the `file` command line tool with option `-i`.
#'
#' @param path A local file path or glob to check.
#' @return A tibble of file encoding.
#' @importFrom fs as_fs_path
#' @importFrom tibble tibble
#' @importFrom stringr str_detect str_extract
#' @examples
#' file_encoding(system.file("extdata", "vt_contribs.csv", package = "campfin"))
#' @export
file_encoding <- function(path) {
  enc <- system2("file", args = paste("-i", path), stdout = TRUE)
  if (any(stringr::str_detect(enc, "\\(No such file or directory\\)"))) {
    stop("no such file or directory")
  } else {
    tibble::tibble(
      path = fs::as_fs_path(stringr::str_extract(enc, "(.*)(?=:\\s)")),
      mime = stringr::str_extract(enc, "(?<=:\\s)(.*)(?=;)"),
      charset = stringr::str_extract(enc, "(?<=;\\scharset\\=)(.*)")
    )
  }
}
