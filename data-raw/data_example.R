vt_contribs <- tibble::tribble(
  ~id, ~cand, ~date, ~amount, ~name, ~address, ~city, ~state, ~zip,
  "01", "Bob Miller", "02/09/2019", 10, "Lisa Miller", "4 Sheffield square Road", "Sheffield", "VT", "05866",
  "02", "Bob Miller", "03/09/2009", 20, "Deb Brown", "Requested", "Requested", "RE", "00000",
  "03", "Chuck White",  "04/09/2019", 25, "N/A", "p.o. box 567   ", "Midlebury", "Vermont", "05753-0567",
  "04", "Chuck White",  "05/09/2019", 100, "Josh Jones", "sugarhouse SQU", "e Corinth", "VT", "5076",
  "05", "Bob Miller", "02/09/2019", 10, "Lisa Miller", "4 Sheffield square Road", "Sheffield", "VT", "05866",
  "06", "Chuck White",  "06/09/2019", 1000, "Bob Taylor", "55 thisplace av", "young america", "mn", "55555",
  "07", "Chuck White",  "07/09/2019", -600, "Alex Johnson", "11 Liberty AVN", "Bristol, VT", "VT", "99999",
  "08", "Alice Walsh",  "08/09/2019", 0, "Ruth Smith", "2 Burlington sqre", "Brulington", "vt", "05401",
  "09", "Alice Walsh",  "09/09/2019", 69, "Joe Garcia", "770   5th-st-nw", "Washington", "D.C.", "20001-2674",
  "10", "Alice Walsh",  "11/09/2019", 222, "Dave Wilson", "XXXXXXXXXXXXXXXXX", "SA", "Texas", "78202"
)

usethis::use_data(vt_contribs, overwrite = TRUE)
fs::dir_create("inst/extdata")
fs::file_move("data/vt_contribs.rda", "inst/extdata/vt_contribs.rda")
readr::write_csv(vt_contribs, "data-raw/vt_contribs.csv")
readr::write_csv(vt_contribs, "inst/extdata/vt_contribs.csv")
