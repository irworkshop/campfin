#' @title Calculate the time to download a file
#' @description Using [httr::HEAD()] and [speedtest::spd_test()] to check the
#'   size of a file before downloading.
#' @param x
#' @param speed The bandwidth in megabytes per second (Mbps) of the internet
#'   connection. If not provided, the function will call
#'   [speedtest::spd_download_test()] on the best availber servers and return
#'   the median bandwidth of the test.
#' @return The number of seconds needed to download a given file.
#' @importFrom speedtest spd_config spd_servers spd_best_servers
#'   spd_download_test
#' @importFrom stringr str_detect
#' @examples stats median
#' @export
download_time <- function(x, speed = NULL) {
  if (suppressWarnings(!is.na(as.numeric(x)))) {
    x <- as.numeric(x)
  } else {
    if (stringr::str_detect(x, rx_url)) {
      x <- url_file_size(x, format = FALSE) # bytes
      x <- x/1e+6 # megabytes
    }
  }
  if (is.null(speed)) {
    warning("No speed has been provided so a speed test is being performed.")
    config <- speedtest::spd_config()
    servers <- speedtest::spd_servers()
    close <- speedtest::spd_closest_servers(servers)
    down <- speedtest::spd_download_test(close, summarise = TRUE)
    speed <- median(down$bw) # megabytes per second
  }
  time <- round(x/speed, digits = 2)
  return() # seconds
}


