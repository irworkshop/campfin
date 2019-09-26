library(stringr)
library(usethis)

# matches 5 or 8 digit ZIP at end of string
rx_zip <- "\\d{5}(?:-\\d{4})?$"
# matches the letters before rx_zip at end
rx_state <- "[:alpha:]+(?=\\s+\\d{5}(?:-\\d{4})?$"

# check rx_zip and rx_state on Google Maps White House address
white_house <- "1600 Pennsylvania Ave NW, Washington, DC 20500"
str_extract(white_house, rx_zip)
str_extract(white_house, rx_state)

# save rx_zip and rx_state data
use_data(rx_zip, overwrite = TRUE)
use_data(rx_state, overwrite = TRUE)

# matches 10 digit US phone numbers
rx_phone <- "^(?:(?:\\+?1\\s*(?:[.-]\\s*)?)?(?:\\(\\s*([2-9]1[02-9]|[2-9][02-8]1|[2-9][02-8][02-9])\\s*\\)|([2-9]1[02-9]|[2-9][02-8]1|[2-9][02-8][02-9]))\\s*(?:[.-]\\s*)?)?([2-9]1[02-9]|[2-9][02-9]1|[2-9][02-9]{2})\\s*(?:[.-]\\s*)?([0-9]{4})(?:\\s*(?:#|x\\.?|ext\\.?|extension)\\s*(\\d+))?$"

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
