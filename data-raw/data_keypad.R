library(stringr)
library(usethis)

# create vector for numbers per letter
numbers <- c(0, rep(2:6, each = 3), rep(7, 4), rep(8, 3), rep(9, 4))
length(numbers) == 27
# assign letter names to each number
names(numbers) <- c(" ", LETTERS)

keypad_alpha <- setNames(as.character(numbers), c(" ", LETTERS))
keypad_nums <- invert_named(keypad_alpha)

# test stringr replace
str_replace_all("TEST", keypad_alpha)
str_replace_all("8378", keypad_nums)

# save keypad data internally
use_data(keypad, internal = TRUE)
