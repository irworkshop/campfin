#' Check whether an input is a valid place with Google Maps API
#'
#' Check whether a place is a valid place or misspelling by matching against the
#' Google Geocoding search result. Use the [httr::GET()] to send a request to
#' the Google Maps API for geocoding information. The query will concatenate all
#' the geographical information that is passed in into a long string. Then the
#' function pulls the `formatted_address` endpoint of the API results and then
#' identifies and extracts the long name field from the API _locality_ result
#' and compare it against the input to see if the input and output match up.
#' Note that you will need to pass in your Google Maps Place API key to the
#' `key` argument.
#'
#' @param city A string of city name to be submitted to the Geocode API.
#' @param state Optional. The state associated with the `city`.
#' @param zip Optional. Supply a string of ZIP code to increase precision.
#' @param key A character string to be passed into `key`. Save your key as
#'   "GEOCODE_KEY" using `Sys.setenv()` or by editing your `.Renviron` file.
#' @param guess logical; Should the function return a single row tibble
#'   containing the original data sent and the multiple components returned by
#'   the Geocode API.
#' @return A logical value by default. If the city returned by the API
#'   comes back the same as the city input, the function will evaluate to
#'   `TRUE`, in all other circumstances (including API errors) `FALSE` is returned.
#'
#'   If the the `guess` argument is set to `TRUE`, a tibble with 1 row and six
#'   columns is returned:
#'   * `original_city`: The `city` value sent to the API.
#'   * `original_state`: The `state` value sent to the API.
#'   * `original_zip`: The `zip` value sent to the API.
#'   * `check_city_flag`: logical; whether the guessed city matches.
#'   * `guess_city`: The legal city guessed by the API.
#'   * `guess_place`: The generic locality guessed by the API.
#' @seealso \url{https://developers.google.com/maps/documentation/geocoding/overview?csw=1}
#' @importFrom httr GET stop_for_status content
#' @importFrom stringr str_c str_match
#' @importFrom dplyr if_else
#' @importFrom purrr map_lgl
#' @importFrom glue glue
#' @family geographic normalization functions
#' @export
check_city <- function(city = NULL, state = NULL, zip = NULL, key = NULL, guess = FALSE) {
  city_validity <- NA
  locality <- NA_character_
  returned_norm <- NA_character_
  if (nchar(city) == 0 | is.na(city)) {
    stop("Input is empty", call. = FALSE)
    create_table()
  }
  if (is.null(key)) {
    key <- Sys.getenv("GEOCODE_KEY")
  }
  api_url_root <- "https://maps.googleapis.com/maps/api/geocode/json?"
  response <- httr::GET(
    url = api_url_root,
    query = list(
      address = stringr::str_c(city, state, zip, sep = "+"),
      key = key
    )
  )
  httr::stop_for_status(response)
  r_content <- httr::content(response)
  create_table <- function() {
    if (guess) {
      y <- tibble::tibble(
        original_city = city,
        original_state = ifelse(is.null(state), NA_character_, state),
        original_zip = ifelse(is.null(zip), NA_character_, zip),
        check_city_flag = city_validity,
        guess_city = locality,
        guess_place = returned_norm
      )
      return(y)
    } else {
      return(city_validity)
    }
  }

  if (r_content$status == "REQUEST_DENIED") {
    warning("You must use an API key")
    create_table()
  } else if (r_content$status == "ZERO_RESULTS") {
    result_state <- ifelse(is.null(state), "", state)
    result_zip <- ifelse(is.null(zip), "", zip)
    warning("No results were found for the given information")
    city_validity <- FALSE
    create_table()
  } else if(r_content$status != "OK"){
    warning(glue("Error from API: {r_content$status}, see Google Maps Documentation for details"))
    create_table()
  } else {
    returned_address <- stringr::str_to_upper(r_content$results[[1]]$formatted_address)
    returned_city <- stringr::str_split(returned_address, ",\\s", simplify = TRUE)[, 1]
    returned_norm <- normal_city(
      city = returned_city,
      abbs = campfin::usps_city,
      states = c(campfin::valid_state),
      na = campfin::invalid_city,
      na_rep = TRUE
    )
    city_validity <- grepl(city, returned_norm, ignore.case = TRUE)
    address_list <- r_content$results[[1]]$address_components
    locality_position <- purrr::detect_index(
      .x = purrr::transpose(address_list)$type,
      .f = ~any(stringr::str_detect(., "locality"))
    )
    locality <- if (any(locality_position)) {
      normal_city(
        city = address_list[[locality_position]]$long_name,
        abbs = campfin::usps_city,
        states = campfin::valid_state,
        na = campfin::invalid_city,
        na_rep = TRUE
      )
    } else {
      NA_character_
    }
    create_table()
  }
}
