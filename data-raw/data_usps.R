## code to prepare `usps_*` dataframes, `valid_state` and `valid_abbs` vectors

library(tidyverse)
library(rvest)

# state names and abbs ----------------------------------------------------

# Publication 28 - Postal Addressing Standards
# Appendix B - Two–Letter State and Possession Abbreviations
usps_b0 <- "https://pe.usps.com/text/pub28/28apb.htm"

# scrape states table
usps_state <-
  read_html(x = usps_b0) %>%
  html_node(css = "#ep18684") %>%
  html_table(fill = TRUE, header = TRUE) %>%
  set_names(nm = c("full", "abb")) %>%
  mutate(full = str_to_upper(full))

# scrape armed forces table
usps_armed <-
  read_html(x = usps_b0) %>%
  html_node(css = "#ep19241") %>%
  html_table(fill = TRUE, header = TRUE) %>%
  set_names(nm = c("full", "abb")) %>%
  mutate(full = str_to_upper(str_remove(full, "([:punct:].*)$")))

# combined tables
usps_state <- usps_state %>%
  bind_rows(usps_armed) %>%
  arrange(full) %>%
  as_tibble()

# save usps state abbs tibble
usethis::use_data(usps_state, overwrite = TRUE)

# save state names vector
valid_name <- usps_state$full
usethis::use_data(valid_name, overwrite = TRUE)

# save state abbs vector
valid_state <- usps_state$abb
usethis::use_data(valid_state, overwrite = TRUE)

# street words and abbs ---------------------------------------------------

# Publication 28 - Postal Addressing Standards
# Appendix C - C1 Street Suffix Abbreviations
usps_c1 <- "https://pe.usps.com/text/pub28/28apc_002.htm"

# scrape states table
usps_street <-
  read_html(x = usps_c1) %>%
  html_node(css = "#ep533076") %>%
  html_table(fill = TRUE, header = TRUE) %>%
  select(1, 2) %>%
  set_names(nm = c("full", "abb")) %>%
  filter(full != abb) %>%
  as_tibble()

# Publication 28 - Postal Addressing Standards
# Appendix C - C2 Secondary Unit Designators
usps_c2 <- "https://pe.usps.com/text/pub28/28apc_003.htm"

# scrape states table
usps_unit <-
  read_html(x = usps_c2) %>%
  html_node(css = "#ep538257") %>%
  html_table(fill = TRUE, header = TRUE) %>%
  as_tibble(.name_repair = "unique") %>%
  slice(-26) %>%
  select(1, 3) %>%
  na_if("") %>%
  drop_na() %>%
  set_names(nm = c("full", "abb")) %>%
  mutate(
    full = str_to_upper(full) %>% str_remove_all("[^\\w]"),
    abb = str_remove_all(abb, "[^\\w]")
  ) %>%
  filter(full != abb)

# scrape geographic directions
usps_dirs <-
  read_html(x = usps_b0) %>%
  html_node(css = "#ep19168") %>%
  html_table(fill = TRUE, header = TRUE) %>%
  set_names(nm = c("full", "abb")) %>%
  mutate(full = str_to_upper(full))

# combine tables
usps_street <- usps_street %>%
  bind_rows(usps_unit) %>%
  bind_rows(usps_dirs) %>%
  arrange(full)

# save usps street abbs tibble
usethis::use_data(usps_street, overwrite = TRUE)

# city abbs ---------------------------------------------------------------

# create a subet of abbs in city names
usps_city <- usps_street %>%
  filter(
    # keep only those used
    full %in% valid_city,
    # drop those shouldn't be changed
    abb %out% c("CENTRE", "ST", "ARC")
  ) %>%
  # add those not included
  add_row(
    full = c("MOUNT", "PORT", "MOUNTAIN", "SAINT", "FORT"),
    abb = c("MT", "PRT", "MTN", "ST", "FT")
  ) %>%
  # add directional abbs
  bind_rows(usps_dirs) %>%
  arrange(full) %>%
  distinct()

# save usps city abbs object
usethis::use_data(usps_city, overwrite = TRUE)
