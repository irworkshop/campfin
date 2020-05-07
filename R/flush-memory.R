#' Flush Garbage Memory
#'
#' Run a full [gc()] a number of times.
#'
#' @param n The number of times to run [gc()].
#' @export
flush_memory <- function(n = 10) {
  for (i in 1:n) {
    suppressMessages(gc(reset = TRUE, full = TRUE))
  }
}
