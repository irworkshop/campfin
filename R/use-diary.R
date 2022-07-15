#' Create a new template data diary
#'
#' Take the arguments supplied and put them into the appropriate places in a
#' new template diary. Write the new template diary in the supplied directory.
#'
#' @param st The USPS state abbreviation. State data only, no federal agencies.
#' @param type The type of data, one of "contribs", "expends", "lobby",
#'   "contracts", "salary", or "voters".
#' @param author The author name of the new diary.
#' @param path The file path, relative to your working directory, where the
#'   diary file will be created. If you use `NA`, then the lines of the diary
#'   will be returned as a character vector. If you specify a character string
#'   file path that contains directories that do not exist then they will be
#'   created. By default, the path creates the diary in a directory that is
#'   expected by the [Accountability Project GitHub repository](https://github.com/irworkshop/accountability_datacleaning).
#' @param auto Must be set to `TRUE` for the diary to be created and opened.
#' @return The file path of new diary, invisibly.
#' @examples
#' use_diary("VT", "contribs", "Kiernan Nicholls", NA, auto = FALSE)
#' use_diary("DC", "expends", "Kiernan Nicholls", tempfile(), auto = FALSE)
#' @importFrom stringr str_to_upper str_to_lower str_sub str_replace_all str_to_title
#' @importFrom readr read_lines write_lines
#' @importFrom fs path file_exists dir_create
#' @importFrom glue glue
#' @importFrom utils file.edit
#' @export
use_diary <- function(st, type, author,
                      path = "state/{st}/{type}/docs/{st}_{type}_diary.Rmd",
                      auto = FALSE) {
  more_abbs <- c(campfin::valid_state, "US")
  ST <- match.arg(st, more_abbs)
  more_names <- c(campfin::valid_name, "United States")
  State <- more_names[match(stringr::str_to_upper(st), more_abbs)]
  State <- stringr::str_to_title(State)
  STATE <- stringr::str_to_upper(State)
  st <- stringr::str_to_lower(ST)
  type_arg <- c("contribs", "expends", "lobby", "contracts", "salary", "voters")
  stt <- paste0(st, stringr::str_sub(type, end = 1))
  type_match <- match(type, type_arg)
  if (is.na(type_match)) {
    Type <- stringr::str_to_sentence(type)
  } else {
    Type <- c("Contributions", "Expenditures", "Lobbyists",
              "Contracts", "Salary", "Voters")
    Type <- Type[type_match]
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

  if (is.na(path) || isFALSE(auto)) {
    return(new_lines)
  } else {
    path <- glue(path)
    dir <- paste(getwd(), dirname(path), sep = "/")
    fs::dir_create(dir)
    path <- fs::path(dir, basename(path))
    if (fs::file_exists(path)) {
      stop(path, " already exists")
    } else {
      readr::write_lines(new_lines, file = path)
      message(path, " was created")
      if (requireNamespace("usethis", quietly = TRUE) & interactive()) {
        usethis::edit_file(path)
      }
    }
    invisible(path)
  }
}
