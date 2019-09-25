library(stringr)
library(usethis)

# create vector for numbers per letter
keypad <- as.character(c(rep(2:6, each = 3), rep(7, 4), rep(8, 3), rep(9, 4)))
length(keypad) == 26
# assign letter names to each number
names(keypad) <- LETTERS

# test stringr replace
str_replace_all("TEST", keypad)

# save keypad data internally
use_data(keypad, internal = TRUE)
