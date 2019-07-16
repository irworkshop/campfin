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

#' US City, State, and ZIPs
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
