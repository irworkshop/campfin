#' @title Check whether an input is a valid place with Google Maps API
#' @description Check whether a place is a valid place or misspelling by matching against
#' the Google Geocoding seaerch result. Use the [httr::GET()] to
#' send a request to the Google Maps API for geocoding information. The query will concatenate
#' all the geographical information that is passed in into a long string.
#' Then the function pulls the `formatted_address` endpoint of the API results
#' and then identifies and extracts the long name field from the API _locality_ result and compare
#' it against the input to see if the input and output match up.
#' Note that you will need to pass in your Google Maps Place API key with the arguement `key=`.
#' @param city A string of city name to be submitted to the Google Maps Geocode API and tested.
#' @param state Optional. The state associated with the city that you wish to check against the Maps API.
#' @param zip Optional. Supply a string of zipcode will help with matching precision
#' @param key a character string to be passed into key=''
#' @param display_full a logical vector. If true, the function returns the matched formatted address returned by API.
#' @return By default, returns a logical vector: If the city returned by the API comes
#' back the same as the city input, the function will evaluate to true;
#' otherwise it will evaluate to false.The evaluation ignores case. If the display
#' @examples
#' \dontrun{ requires Google API key
#' check_city("WYOMISSING", "PA", key = your_key) #replace your_key with your API key
#' check_city("Waggaman", "LA", "70094", key = your_key)
#' }
#' @seealso \url{http://code.google.com/apis/maps/documentation/geocoding/}
#' @importFrom httr GET stop_for_status
#' @importFrom httr content
#' @importFrom stringr str_c str_match
#' @importFrom dplyr if_else
#' @importFrom glue glue
#' @family geographic normalization functions
#' @export
check_city <- function(city = NULL, state = NULL, zip = NULL, key = NULL, display_full = FALSE) {
  if(city == ""|is.na(city)){
    return(FALSE)
  }
  api_url_root <- "https://maps.googleapis.com/maps/api/geocode/json?"
  response <- httr::GET(api_url_root,
                        query = list(address = str_c(city, state, zip, sep = "+"),
                                     key = key))
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
    stop(glue("Error from API: {r_content$status}, see Google Maps Documentation for details"),
            call. = FALSE)
    return(NA)
  }
  else{
    returned_address <- r_content$results[[1]]$formatted_address %>% str_to_upper()
    returned_city <- str_match(returned_address,"(^.[^,]+),\\s.+")[,2]
    city_validity <- if_else(condition = str_to_upper(city) %>% trimws() == returned_city,
                             true = TRUE,
                             false = FALSE)
    if(display_full){
      return(returned_address)
    }
    else{
      return(city_validity)
    }
  }
}
