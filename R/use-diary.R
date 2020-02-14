#' Create a new template data diary
#'
#' Take the arguments supplied and put them into the appropriate places in a
#' new template diary. Write the new template diary in the supplied directory.
#'
#' @param st The USPS state abbreviation.
#' @param type The type of data, one of "contribs", "expends", or "lobby".
#' @param author The author name of the new diary.
#' @param auto If `TRUE`, file is created in the correct working directory.
#'   If `FALSE`, a plain character string is returned. If a directory name, the
#'   file is automatically written to that directory.
#' @return The file path of new diary, invisibly.
#' @examples
#' use_diary("VT", "contribs", "Kiernan Nicholls", FALSE)
#' # use_diary("VT", "contribs", "Kiernan Nicholls", tempdir())
#' @importFrom stringr str_to_upper str_to_lower str_sub str_replace_all str_to_title
#' @importFrom readr read_lines write_lines
#' @importFrom fs path
#' @export
use_diary <- function(st, type = c("contribs", "expends", "lobby"), author, auto = FALSE) {
  ST <- match.arg(st, campfin::valid_state)
  State <- campfin::valid_name[match(stringr::str_to_upper(st), campfin::valid_state)]
  State <- stringr::str_to_title(State)
  STATE <- stringr::str_to_upper(State)
  st <- stringr::str_to_lower(ST)
  stt <- paste0(st, stringr::str_sub(type, end = 1))
  type <- match.arg(type, c("contribs", "expends", "lobby"))
  Type <- if (type == "contribs") {
    "Contributions"
  } else if (type == "expends") {
    "Expenditures"
  } else if (type == "lobby") {
    "Lobbying"
  }
  temp <- system.file("templates", "template_diary.Rmd", package = "campfin")
  lines <- readr::read_lines(temp)
  new_lines <- lines %>%
    stringr::str_replace_all("\\{State\\}", State) %>%
    stringr::str_replace_all("\\{STATE\\}", STATE) %>%
    stringr::str_replace_all("\\{Type\\}", Type) %>%
    stringr::str_replace_all("\\{type\\}", type) %>%
    stringr::str_replace_all("\\{st\\}", st) %>%
    stringr::str_replace_all("\\{ST\\}", ST) %>%
    stringr::str_replace_all("\\{stt\\}", stt) %>%
    stringr::str_replace_all("\\{Author\\}", author)
  if (is.logical(auto) & !auto) {
    return(new_lines)
  } else if (is.logical(auto) & auto) {
    dir <- paste(getwd(), st, type, "docs", sep = "/")
    fs::dir_create(dir)
  } else {
    dir <- auto
  }
  file <- paste(st, type, "diary.Rmd", sep = "_")
  path <- fs::path(dir, file)
  readr::write_lines(new_lines, path = path)
  message(path, " was created")
  file.edit(path)
  invisible(path)
}
