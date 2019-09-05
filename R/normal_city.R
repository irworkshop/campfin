#' @title Normalize City Names
#' @description Return consistent version of a city names using
#'   `stringr::str_*()` functions. Letters are capitalized, hyphens and
#'   underscores are replaced with whitespace, other punctuation is removed,
#'   numbers are removed, and excess whitespace is trimed and squished.
#'   Optionally, geographic abbreviations ("MT") can be replaced with their long
#'   form ("MOUNT"). Invalid addresses from a vector can be removed (possibly
#'   using [invalid_city]) as well as single (repeating) character strings
#'   ("XXXXXX").
#' @param city A vector of city names.
#' @param geo_abbs A two-column data frame like [usps_city], with a full
#'   geographic feature ("LAKE") in the first column and abbreviations ("LK")
#'   in the second. Replace all abbreviations with their full version.
#' @param st_abbs A vector of state abbreviations ("VT") to remove from the
#'   _end_ (and only end) of city names ("STOWE VT").
#' @param na A vector of values to make `NA` (useful with the [invalid_city]
#'   vector).
#' @param na_rep logical; If `TRUE`, replace all single digit (repeating)
#'   strings with `NA`.
#' @return A vector of normalized city names.
#' @examples
#' normal_city(
#'   city = c("Stowe, VT", "N/A", "Burlington", "ST JOHNSBURY", "XXXXXXXXX"),
#'   geo_abbs = tibble::tibble(rep = "SAINT", abb = "ST", ),
#'   st_abbs = c("VT"),
#'   na = c("", "NA", "UNKNOWN"),
#'   na_rep = TRUE
#' )
#' @importFrom stringr str_to_upper str_replace_all str_remove_all str_trim
#'   str_squish str_c str_replace str_remove str_which
#' @importFrom dplyr na_if
#' @importFrom tibble tibble
#' @export
normal_city <- function(
  city,
  geo_abbs = NULL,
  st_abbs = NULL,
  na = c("", "NA"),
  na_rep = FALSE
) {

  city_clean <- city %>%
    stringr::str_to_upper() %>%
    stringr::str_replace_all("-", " ") %>%
    stringr::str_replace_all("_", " ") %>%
    stringr::str_remove_all("[[:punct:]]") %>%
    stringr::str_remove_all("\\d+") %>%
    stringr::str_trim() %>%
    stringr::str_squish()

  if (!is.null(geo_abbs)) {
    geo_abbs <- as.data.frame(geo_abbs)
    for (i in seq_along(geo_abbs[, 2])) {
      city_clean <- stringr::str_replace(
        string = city_clean,
        pattern = stringr::str_c("\\b", geo_abbs[[i, 2]], "\\b"),
        replacement = geo_abbs[[i, 1]]
      )
    }
  }

  if (!is.null(st_abbs)) {
    for (i in seq_along(st_abbs)) {
      city_clean <- stringr::str_remove(city_clean, str_c("\\s", st_abbs[i], "$"))
    }
  }

  if (na_rep) {
    city_clean[city_clean %>% stringr::str_which("^(.)\\1+$")] <- NA
  }

  city_clean[which(city_clean %in% na)] <- NA

  return(city_clean)
}
