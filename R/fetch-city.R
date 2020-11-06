#' Return Closest Match Result of Cities from Google Maps API
#'
#' Use the [httr::GET()] to send a request to the Google Maps API for geocoding
#' information. The query will concatenate all the geographical information that
#' is passed in into a single string. Then the function pulls the
#' `formatted_address` endpoint of the API results and extracts the the first
#' field of the result. Note that you will need to pass in your Google Maps
#' Place API key with the `key` argument.
#'
#' @param address A vector of street addresses. Sent to the API as one string.
#' @param key A character containing your alphanumeric Google Maps API key.
#' @return A character vector of formatted address endpoints from Google. This
#'   will include all the fields from street address, city, state/province,
#'   zipcode/postal code to country/regions. `NA_character_` is returned for
#'   all errored API calls.
#' @seealso \url{https://developers.google.com/maps/documentation/geocoding/overview?csw=1}
#' @importFrom dplyr if_else
#' @importFrom glue glue
#' @importFrom httr GET stop_for_status content
#' @importFrom purrr map_lgl
#' @importFrom stringr str_c str_detect str_trim
#' @family geographic normalization functions
#' @export
fetch_city <- function(address = NULL, key = NULL) {
  address <- stringr::str_trim(address)
  if (nchar(address) == 0 | is.na(address) | is.null(address)) {
    stop("Geographical arguments required")
  }
  if (is.null(key)) {
    key <- Sys.getenv("GEOCODE_KEY")
  }
  api_url_root <- "https://maps.googleapis.com/maps/api/geocode/json?"
  response <- httr::GET(api_url_root, query = list(address = address, key = key))
  httr::stop_for_status(response)
  r_content <- httr::content(response)
  if (r_content$status == "REQUEST_DENIED") {
    warning("You must provide an API key", call. = FALSE)
    return(NA_character_)
  } else if (r_content$status == "ZERO_RESULTS") {
    warning("No results were found", call. = FALSE)
    return(NA_character_)
  } else if(r_content$status != "OK") {
    warning(glue::glue("Error from API: {r_content$statuse}, see Google Maps Documentation for details"), call. = FALSE)
    return(NA_character_)
  } else {
    str_to_upper(r_content$results[[1]]$formatted_address)
  }
}
