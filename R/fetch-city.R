#' @title Return Closest Match Result of Cities from Google Maps API
#' @description Get the matching against
#' the Google Geocode seaerch result. Use the [httr::GET()] to
#' send a request to the Google Maps API for geocoding information. The query will concatenate
#' all the geographical information that is passed in into a long string.
#' Then the function pulls the `formatted_address` endpoint of the API results
#' and then identifies and extracts the the first field of the result. Note that you will
#' need to pass in your Google Maps Place API key with the arguement `key=`.
#' @param address A vector of street addresses. Sent to the API all in one string.
#' @param key a character string to be passed into key=''. This is your API key obtained from Google.
#' @return A character vector: results of the formatted address endpoint from Google. This will include all the fields
#' from street address, city, state/province, zipcode/postal code to country/regions.
#' @examples
#' \dontrun{ requires Google API key
#' fetch_city("4400 Mass Ave. DC", key = api_key) # Use your API key from Google Maps
#' }
#' @seealso \url{http://code.google.com/apis/maps/documentation/geocoding/}
#' @importFrom httr GET stop_for_status
#' @importFrom httr content
#' @importFrom purrr map_lgl
#' @importFrom stringr str_c str_detect
#' @importFrom dplyr if_else
#' @family geographic normalization functions
#' @export
fetch_city <- function(address = NULL, key = NULL) {
  if(address %>% trimws() == ""|is.na(address)){
    stop("geographical arguments required")
    return(NA_character_)
  }
  api_url_root <- "https://maps.googleapis.com/maps/api/geocode/json?"
  response <- httr::GET(api_url_root, query = list(address = address, key = key))
  stop_for_status(response)
  r_content <- content(response)
  if (identical(r_content$status,   "REQUEST_DENIED")) {
    warning("You must use an API key", call. = FALSE)
    return(NA_character_)
  }
  else if (identical(r_content$status,   "ZERO_RESULTS")){
    warning("No results were found", call. = FALSE)
    return(NA_character_)
  }
  else if(r_content$status != 'OK'){
    warning(glue("Error from API: {r_content$status}, see Google Maps Documentation for details"), call. = FALSE)
    return(NA_character_)
  }
   else{
     address_list <- r_content$results[[1]]$address_components
     returned_address <- r_content$results[[1]]$formatted_address %>% str_to_upper()
    return(returned_address)
  }
}
