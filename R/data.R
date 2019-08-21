#' US City, State, and ZIPs
#'
#' A dataset containing all US ZIP codes alongside their city and state.
#'
#' @format A tibble with 44,360 rows of 3 variables:
#' \describe{
#'   \item{city}{City name}
#'   \item{state}{state abbreviation}
#'   \item{zip}{US ZIP code}
#'   ...
#' }
#' @details The original author claims this dataset contains over 98% of all US ZIP codes and
#'     covers 99.9% of the population. It may contains up to 0.5% false positives.
#' @source Daniel Coven's federalgovernmentzipcodes.us web site and the CivicSpace US ZIP Code
#'     Database written by Schuyler Erle <schuyler@geocoder.us>, 5 August 2004. Original CSV
#'     files available from
#'     \url{http://federalgovernmentzipcodes.us/free-zipcode-database-Primary.csv},
#'     \url{http://www.boutell.com/zipcodes/}, and
#'     \url{http://mappinghacks.com/data/}.
"geo"

#' Invalid City Values
#'
#' A vector containing common invalid city names.
#'
#' @format A vector of length 54:
"na_city"

#' USPS C1 Address Abbreviations
#'
#' A dataset containing common street suffixes or suffix abbreviations and their full equivalent.
#'
#' @format A tibble with 44,360 rows of 3 variables:
#' \describe{
#'   \item{abb}{Commonly Used Street Suffix or Abbreviation}
#'   \item{full}{Primary Street Suffix}
#'   ...
#' }
#' @source The USPS C1 Street Suffix Abbreviations
#'     \url{https://pe.usps.com/text/pub28/28apc_002.htm}
"usps"

#' USPS C1 City Abbreviations
#'
#' A currated and edited dataset containing the USPS abbreviations for only city names.
#'
#' @format A tibble with 44,360 rows of 3 variables:
#' \describe{
#'   \item{abb}{Commonly Used Street Suffix or Abbreviation}
#'   \item{full}{Primary Street Suffix}
#'   ...
#' }
#' @source The USPS C1 Street Suffix Abbreviations
#'     \url{https://pe.usps.com/text/pub28/28apc_002.htm}
"usps_city"

#' ZIP code regex
#'
#' The regex string to extract 5 or 9 digit zip from end of address.
#'
#' @format A single character string.
"rx_zip"

#' State regex
#'
#' The regex string to extract alpha state string preceding ZIP code
#'
#' @format A single character string.
"rx_state"

#' Many of the cities in America
#'
#' The `city` column of the `geo` tibble
#'
#' @format A vectory of city names
"valid_city"

#' All 2-letter State Abbreviations
#'
#' The `state` column of the `geo` tibble
#'
#' @format A vectory of 2-digit abbreviations
"valid_state"

#' Almost all of the valid USA ZIP Codes
#'
#' The `zip` column of the `geo` tibble
#'
#' @format A vectory of 5-digit ZIP codes
"valid_zip"
