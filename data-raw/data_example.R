vt_contribs <- tibble::tribble(
  ~id, ~cand, ~date, ~amount, ~first, ~last, ~address, ~city, ~state, ~zip,
  "01", "Bill Miller",as.Date("2019-09-02"), 10, "Lisa", "Miller", "4 Sheffield square Rd", "Sheffield", "VT", "05866",
  "02", "Bill Miller",as.Date("2009-09-03"), 20, "Deb", "Brown", "Requested", "Requested", "RE", "00000",
  "03", "Jake White", as.Date("2019-09-04"), 25, NA, NA, "p.o. box 567   ", "Midlebury", "Vermont", "05753-0567",
  "04", "Jake White", as.Date("2019-09-05"), 100, "Josh", "Jones", "sugarhouse road", "East Corinth", "V.T.", "5076",
  "05", "Bill Miller",as.Date("2019-09-02"), 10, "Lisa", "Miller", "4 Sheffield square Rd", "Sheffield", "VT", "05866",
  "06", "Jake White", as.Date("2019-09-06"), 1000, "Bob", "Taylor", "55 thisplace av", "young america", "mn", "55555",
  "07", "Jake White", as.Date("2019-09-07"), -600, "Alex", "Johnson", "11 Liberty STR", "Bristol, VT", "VT", "05443",
  "08", "Beth Walsh", as.Date("2019-09-08"), 0, "Ruth", "Smith", "2 Burlington Sq", "Brulington", "vt", "05401",
  "09", "Beth Walsh", as.Date("2019-09-09"), 69, "Joe", "Garcia", "770   5th-st-nw", "Washington", "DC", "20001-2674",
  "10", "Beth Walsh", as.Date("2019-09-11"), 222, "Dave", "Wilson", "XXXXXXXXXXXXXXXXX", "SA", "Texas", "78202"
)

usethis::use_data(vt_contribs, overwrite = TRUE)

vt_contribs$date <- format(vt_contribs$date, "%m/%d/%Y")

write_csv(vt_contribs, "data-raw/vt_contribs.csv")
