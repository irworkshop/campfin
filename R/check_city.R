#' @title Check whether City Input is a Valid Place with Google Maps Places API
#' @description Check whether a place is a valid place or misspelling by matching against
#' the Google Place Seaerch result. Use the [httr::GET()] to
#' send a request to the Google Maps API for place search. The query will concatenate
#' all the geographical information that is passed in into a long string.
#' Then the function upulls the `formatted_address` endpoint of the API
#' and uses the [stringr::str_match()] to extracts the city fron the API result,
#' the first field before comma. Note that you will
#' need to pass in your Google Maps Place API key with the arguement `key=`. This result
#' is NOT case sensitive.
#' @param city A string of city name to be tested.
#' @param state Optional. The state associated with the city that you wish to check against the Maps API.
#' @param zip Supply a string of zipcode will help with matching precision
#' @param key a character string to be passed into key=''
#' @return A logical vector: If the city returned by the API comes
#' back the same as the city input, the function will evaluate to true;
#' otherwise it will evaluate to false.
#' @examples
#' check_city("WYOMISSING", "PA", key = your_key) #replace your_key with your API key
#' check_city("Waggaman", LA 70094, USAfull = state.name, rep = state.abb)
#' @importFrom httr GET
#' @importFrom httr content
#' @importFrom stringr str_c
#' @importFrom stringr str_to_upper()
#' @importFrom stringr str_natcg
#' @importFrom dyplyr if_else
#' @family geographic normalization functions
#' @export
check_city <- function(city = NULL, state = NULL, zip = NULL, verbose = FALSE, key = NULL) {
  response <- GET(api_url_root, query = list(query = str_c(city, state, zip, sep = " "), key = key))
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
  else{
    returned_adress <- r_content$results[[1]]$formatted_address %>% str_to_upper()
    returned_city <- str_match(returned_adress,"(^\\D[^,]+),\\s.+")[,2]
    city_validity <- if_else(condition = city == returned_city,
                             true = TRUE,
                             false = FALSE)
    return(city_validity)
  }
}
