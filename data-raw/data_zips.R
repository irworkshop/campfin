## code to modify `zipcode` dataframe goes here

library(tidyverse)
library(googledrive)
library(googlesheets4)
library(zipcode)

cat(packageDescription(pkg = "zipcode", fields = "Description"))
## > This package contains a database of city, state, latitude, and longitude
## information for U.S. ZIP codes from the CivicSpace Database (August 2004)
## augmented by Daniel Coven's federalgovernmentzipcodes.us web site (updated
## January 22, 2012). Previous versions of this package (before 1.0) were based
## solely on the CivicSpace data, so an original version of the CivicSpace
## database is also included.

# CivicSpace README =======================================================
# http://civicspacelabs.org/zipcodedb
# CivicSpace US ZIP Code Database by Schuyler Erle <schuyler@geocoder.us>

## > The ZIP code database contains 43191 ZIP codes for the continetal United
## States, Alaska, Hawaii, Puerto Rico, and American Samoa...

## > This database was composed using ZIP code gazetteers from the US Census
## Bureau from 1999 and 2000, augmented with additional ZIP code information
## from the Census Bureau’s TIGER/Line 2003 data set.... The database is
## guaranteed to exclusively contain information gathered from sources in the
## public domain, and thus be legal to redistribute.

## > The database is believed to contain over 98% of the ZIP Codes in current
## use in the United States. The remaining ZIP Codes absent from this database
## are entirely PO Box or Firm ZIP codes added in the last five years, which
## are no longer published by the Census Bureau, but in any event serve a very
## small minority of the population (probably on the order of .1% or less).
## Although every attempt has been made to filter them out, this data set may
## contain up to .5% false positives, that is, ZIP codes that do not exist or
## are no longer in use but are included due to erroneous data sources...

## > The database andthis README are copyright 2004 CivicSpace Labs, Inc., and
## are published under a Creative Commons Attribution-ShareAlike license ,
## which requires that all updates must be released under the same license...
# =========================================================================

packageDescription(pkg = "zipcode", fields = "Author")
# > "Jeffrey Breen <jeffrey@atmosgrp.com>"

packageDescription(pkg = "zipcode", fields = "License")
# > CC BY-SA 2.0 + file LICENSE

# make tibble and normalize city
data("zipcode")
zipcodes <-
  as_tibble(zipcode) %>%
  select(city, state, zip) %>%
  mutate(
    city = city %>%
      str_replace("U S A F", "USAF") %>%
      str_replace("N A S", "NAS") %>%
      normal_city(geo_abbs = usps_city) %>%
      str_replace("$SOUTHEAST REE^", "SE REE")
  )

# save USA zipcodes tibble
usethis::use_data(zipcodes, overwrite = TRUE)

# save USA cities vector
valid_city <- sort(unique(zipcodes$city))
usethis::use_data(valid_city, overwrite = TRUE)

# save USA zipcodes vector
valid_zip <- sort(unique(zipcodes$zip))
usethis::use_data(valid_zip, overwrite = TRUE)

# add extra cities
# googledrive::drive_ls()
sheet_id <- "17pi8LW1nTaGzThfUmQMZ_6HMWPxUPatqrTEWzY6LPoI"
extra_city <- sort(unique(pull(read_sheet(ss = sheet_id))))
extra_city <- extra_city[which(extra_city %out% valid_city)]

# save extra custom city vector
usethis::use_data(extra_city, overwrite = TRUE)
