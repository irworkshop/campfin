#' @title Return Closest Match Result of Cities from Google Maps API
#' @description Get the matching against
#' the Google Geocode seaerch result. Use the [httr::GET()] to
#' send a request to the Google Maps API for geocoding information. The query will concatenate
#' all the geographical information that is passed in into a long string.
#' Then the function pulls the `formatted_address` endpoint of the API results
#' and then identifies and extracts the long name field from the API _locality_ result Note that you will
#' need to pass in your Google Maps Place API key with the arguement `key=`.
#' @param address A vector of street addresses. Sent to the API all in one string.
#' @param city A string of city name to be submitted to the Google Maps Geocode API.
#' @param state Optional. The state associated with the city that you wish to check against the Maps API.
#' @param key a character string to be passed into key=''. This is your API key obtained from Google.
#' @return A character vector: results of the closest match of the submitted city names returned by the API.
#' @examples
#' \dontrun{ requires Google API key
#' fetch_city("One CVS Drive","RI", "02895", key = api_key)
#' }
#' @seealso \url{http://code.google.com/apis/maps/documentation/geocoding/}
#' @importFrom httr GET stop_for_status
#' @importFrom httr content
#' @importFrom purrr map_lgl
#' @importFrom stringr str_c str_detect
#' @importFrom dplyr if_else
#' @family geographic normalization functions
#' @export
fetch_city <- function(address = NULL, city = NULL, state = NULL, key = NULL) {
  if(str_c(address,city,state) %>% trimws() == ""|is.na(str_c(address,city,state))){
    warning("geographical arguments required")
    return(NA)
  }
  api_url_root <- "https://maps.googleapis.com/maps/api/geocode/json?"
  response <- httr::GET(api_url_root, query = list(address = str_c(address, city, state, sep = "+"), key = key))
  stop_for_status(response)
  r_content <- content(response)
  if (identical(r_content$status,   "REQUEST_DENIED")) {
    stop("You must use an API key", call. = FALSE)
    return(NA)
  }
  else if (identical(r_content$status,   "ZERO_RESULTS")){
    stop("No results were found", call. = FALSE)
    return(NA)
  }
  else if(r_content$status != 'OK'){
    stop(glue("Error from API: {r_content$status}, see Google Maps Documentation for details"), call. = FALSE)
    return(NA)
  }
  else{
    locality_position <- lapply(address_list, unlist,recursive = T) %>% map(str_detect, "locality") %>% map_lgl(any)
    returned_city <- ifelse(TRUE %in% locality_position,
                       address_list[locality_position][[1]]$long_name %>% normal_city(.,geo_abbs = campfin::usps_city,
                                                                                      st_abbs = c(campfin::valid_state),
                                                                                      na = campfin::invalid_city,
                                                                                      na_rep = TRUE),
                       NA_character_)
    return(returned_city)
  }
}
