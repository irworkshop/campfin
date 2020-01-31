## code to prepare `dark2` dataset goes here

dark2 <- RColorBrewer::brewer.pal(8, name = "Dark2")
names(dark2) <- c(
  "teal", "orange", "purple", "pink", "green", "yellow", "brown", "grey"
)
usethis::use_data(dark2, overwrite = TRUE)
