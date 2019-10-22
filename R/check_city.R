#' @title Check whether city input is a valid place with Google Maps API
#' @description Check whether a place is a valid place or misspelling by matching against
#' the Google Geocode seaerch result. Use the [httr::GET()] to
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
#' @return A logical vector: If the city returned by the API comes
#' back the same as the city input, the function will evaluate to true;
#' otherwise it will evaluate to false.The evaluation ignores case.
#' @examples
#' \dontrun{ requires Google API key
#' check_city("WYOMISSING", "PA", key = your_key) #replace your_key with your API key
#' check_city("Waggaman", "LA", "70094", key = your_key)
#' }
#' @seealso \url{http://code.google.com/apis/maps/documentation/geocoding/}
#' @importFrom httr GET stop_for_status
#' @importFrom httr content
#' @importFrom stringr str_c
#' @importFrom dplyr if_else
#' @family geographic normalization functions
#' @export
check_city <- function(city = NULL, state = NULL, zip = NULL, key = NULL) {
  api_url_root <- "https://maps.googleapis.com/maps/api/geocode/json?"
  response <- httr::GET(api_url_root,
                        query = list(address = str_c(city, state, zip, sep = "+"),
                                     key = key))
  stop_for_status(response)
  r_content <- content(response)
  if (identical(r_content$status,   "REQUEST_DENIED")) {
    warning("You must use an API key", call. = FALSE)
    return(NA)
  }
  else if (identical(r_content$status,   "ZERO_RESULTS")){
    warning("No results were found", call. = FALSE)
    return(NA)
  }
  else if(r_content$status != 'OK'){
    warning(glue("Error from API: {r_content$status}, see Google Maps Documentation for details"),
            call. = FALSE)
  }
  else{
    #returned_adress <- r_content$results[[1]]$formatted_address %>% str_to_upper()
    #returned_city <- str_match(returned_adress,"(^\\D[^,]+),\\s.+")[,2]
    #returned_city <- r_content$results[[1]]$address_components[[1]]$long_name %>% str_to_upper()
    address_list <- r_content$results[[1]]$address_components
    locality_position <- lapply(address_list, unlist,recursive = T) %>%
      map(str_detect, "locality") %>%
      map(any) %>%
      unlist()
    returned_city <- address_list[locality_position][[1]]$long_name %>%
      str_to_upper()
    city_validity <- if_else(condition = str_to_upper(city) == returned_city,
                             true = TRUE,
                             false = FALSE)
    return(city_validity)
  }
}
