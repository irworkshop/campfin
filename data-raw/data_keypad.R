library(stringr)
library(usethis)

# create vector for numbers per letter
numbers <- c(0, rep(2:6, each = 3), rep(7, 4), rep(8, 3), rep(9, 4))
length(numbers) == 27
# assign letter names to each number
names(numbers) <- c(" ", LETTERS)

keypad <- setNames(as.character(numbers), c(" ", LETTERS))

# test stringr replace
str_replace_all("TEST", keypad)
str_replace_all("8378", invert_named(keypad))

# save keypad data internally
use_data(keypad, internal = TRUE)
