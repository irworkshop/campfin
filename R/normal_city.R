#' @title Normalize City Names
#' @param city A vector of US city names.
#' @param geo_abbs A two-column data frame with replacement strings ("MOUNT") in
#'   the first column and geographic abbreviations ("MT") in the second.
#' @param st_abbs A vector of state abbreviations ("VT") to remove from the
#'   _end_ of city names ("STOWE VT").
#' @param na A vector of values to make `NA` (useful with the `campfin::na_city`
#'   vector).
#' @param na_rep If `TRUE`, make all single digit repeating strings `NA`.
#' @return A vector of normalized city names.
#' @examples
#' normal_city(
#'   city = c("Stowe, VT", "N/A", "Burlington", "ST JOHNSBURY", "XXXXXXXXX"),
#'   geo_abbs = tibble::tibble(abb = "ST", rep = "SAINT"),
#'   st_abbs = c("VT"),
#'   na = c("", "NA", "UNKNOWN"),
#'   na_rep = TRUE
#' )
#' @import stringr
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
    str_to_upper() %>%
    str_replace_all("-", " ") %>%
    str_replace_all("_", " ") %>%
    str_remove_all("[[:punct:]]") %>%
    str_remove_all("\\d+") %>%
    str_trim() %>%
    str_squish() %>%
    na_if("")

  if (!is.null(geo_abbs)) {
    geo_abbs <- as.data.frame(geo_abbs)
    for (i in seq_along(geo_abbs[, 2])) {
      city_clean <- str_replace(
        string = city_clean,
        pattern = str_c("\\b", geo_abbs[[i, 2]], "\\b"),
        replacement = geo_abbs[[i, 1]]
      )
    }
  }

  if (!is.null(st_abbs)) {
    for (i in seq_along(st_abbs)) {
      city_clean <- str_remove(city_clean, str_c("\\s", st_abbs[i], "$"))
    }
  }

  if (na_rep) {
    city_clean[city_clean %>% str_which("^(.)\\1+$")] <- NA
  }

  city_clean[which(city_clean %in% na)] <- NA

  return(city_clean)
}
