library(stringr)
library(usethis)

# matches 5 or 8 digit ZIP at end of string
rx_zip <- "\\d{5}(?:-\\d{4})?$"
# matches the letters before rx_zip at end
rx_state <- "[:alpha:]+(?=\\s+\\d{5}(?:-\\d{4})?$"
# matches 10 digit US phone numbers
rx_phone <- str_c(
  "^( )*(\\+?( )?\\(?( )?(\\d{1,3})?)\\)?", # country code
  "\\(?(\\d{3})\\)?", # area code
  "\\(?(\\d{3})\\)?", # exchange
  "\\(?(\\d{4})\\)?( )*$", # line number
  sep = "(.|-|_\\s)?" # possible seps
)

# check rx_zip and rx_state on Google Maps White House address
white_house <- "1600 Pennsylvania Ave NW, Washington, DC 20500"
str_extract(white_house, rx_zip)
str_extract(white_house, rx_state)

# save rx_zip and rx_state data
use_data(rx_zip, overwrite = TRUE)
use_data(rx_state, overwrite = TRUE)

# check rx_phone on many formats
numbers <- c(
  "2024561111",
  "2024561111001",
  "123456789",
  "(202) 456-1111",
  "(202)456-1111",
  "Telephone",
  "202.456.1111",
  "202-456-1111",
  "999",
  "202 456 1111",
  "456-1111",
  "+1 (202) 456-1111"
)

str_extract(numbers, rx_phone)

# save rx_phone data
use_data(rx_phone, overwrite = TRUE)
