#' @title Check whether an input is a valid place with Google Maps API
#' @description Check whether a place is a valid place or misspelling by
#'   matching against the Google Geocoding seaerch result. Use the [httr::GET()]
#'   to send a request to the Google Maps API for geocoding information. The
#'   query will concatenate all the geographical information that is passed in
#'   into a long string. Then the function pulls the `formatted_address`
#'   endpoint of the API results and then identifies and extracts the long name
#'   field from the API _locality_ result and compare it against the input to
#'   see if the input and output match up. Note that you will need to pass in
#'   your Google Maps Place API key with the arguement `key=`.
#' @param city A string of city name to be submitted to the Google Maps Geocode
#'   API and tested.
#' @param state Optional. The state associated with the city that you wish to
#'   check against the Maps API.
#' @param zip Optional. Supply a string of zipcode will help with matching
#'   precision
#' @param key a character string to be passed into key=''
#' @param guess a logical vector. If true, the function returns a dataframe with
#'   three columns. In addition to the first logical vector, it would return a
#'   `locality` column with the API-matched localities, i.e. unincorporated
#'   cities or census designated places returned by API, and a third column
#'   first part of matched formatted address returned by the API. When `place`
#'   is set to TRUE, the results returned can be any address, including
#'   highways, street addresses, cities, townships, states, provinces,
#'   countires, etc.
#' @return By default, returns a logical vector: If the city returned by the API
#'   comes back the same as the city input, the function will evaluate to true;
#'   otherwise it will evaluate to false.The evaluation ignores case. If the the
#'   guess argument is set to T, returns a dataframe with columns
#'   `original_city`, `original_state`, `original_zip`, `check_city_flag`,
#'   `guess_city` and `guess_place`.
#' @examples
#' \dontrun{ requires Google API key
#' check_city("WYOMISSING", "PA", key = your_key) #replace your_key with your API key
#' check_city("Waggaman", "LA", "70094", key = your_key, guess = TRUE)
#' }
#' @seealso \url{http://code.google.com/apis/maps/documentation/geocoding/}
#' @importFrom httr GET stop_for_status
#' @importFrom httr content
#' @importFrom stringr str_c str_match
#' @importFrom dplyr if_else
#' @importFrom purrr map_lgl
#' @importFrom glue glue
#' @family geographic normalization functions
#' @export
check_city <- function(city = NULL, state = NULL, zip = NULL, key = NULL, guess = FALSE) {
  city_validity = NA
  locality = NA_character_
  normal_returned = NA_character_
  create_table <- function() {
    if (guess) {
      y <- tibble::tibble(original_city = city,
                          original_state = ifelse(is.null(state),NA_character_,state),
                          original_zip = ifelse(is.null(zip),NA_character_,zip),
                          check_city_flag = city_validity,
                          guess_city = locality,
                          guess_place = normal_returned)
      return(y)
    } else {
      return(city_validity)
    }
  }

  if(city == ""|is.na(city)){
    stop("Input is empty", call. = FALSE)
    create_table()
  }
  api_url_root <- "https://maps.googleapis.com/maps/api/geocode/json?"
  response <- httr::GET(api_url_root,
                        query = list(address = str_c(city, state, zip, sep = "+"),
                                     key = key))
  stop_for_status(response)
  r_content <- content(response)
  if (identical(r_content$status,   "REQUEST_DENIED")) {
    warning("You must use an API key", call. = FALSE)
    create_table()
  } else if (identical(r_content$status,   "ZERO_RESULTS")) {
    city_validity = FALSE
    warning(str_c("No results were found for ", city, " ", state, " ", zip))
    create_table()
  } else if(r_content$status != 'OK'){
    warning(glue("Error from API: {r_content$status}, see Google Maps Documentation for details"),
            call. = FALSE)
    create_table()
  } else {
    returned_address <- r_content$results[[1]]$formatted_address %>% str_to_upper()
    returned_city <- str_match(returned_address,"(^.[^,]+),\\s.+")[,2]
    normal_returned <- normal_city(city = returned_city,
                                   geo_abbs = campfin::usps_city,
                                   st_abbs = c(campfin::valid_state),
                                   na = campfin::invalid_city,
                                   na_rep = TRUE)
    city_validity <- str_to_upper(city) %>% trimws() == normal_returned
    address_list <- r_content$results[[1]]$address_components
    locality_position <- lapply(address_list, unlist,recursive = T) %>% map(str_detect, "locality") %>% map_lgl(any)
    locality <- ifelse(TRUE %in% locality_position,
                       address_list[locality_position][[1]]$long_name %>% normal_city(.,geo_abbs = campfin::usps_city,
                                                                                      st_abbs = c(campfin::valid_state),
                                                                                      na = campfin::invalid_city,
                                                                                      na_rep = TRUE),
                       NA_character_
    )
    create_table()
  }
}
