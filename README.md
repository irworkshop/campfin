
<!-- README.md is generated from README.Rmd. Please edit that file -->

# campfin <img src="man/figures/logo.png" align="right" width="120" />

[![CRAN\_Status\_Badge](http://www.r-pkg.org/badges/version/campfin)](https://cran.r-project.org/package=campfin)

## Overview

The `campfin` package was created to facilitate the work being done on
the [The Accountability Project](https://www.publicaccountability.org/),
a tool created by [The Investigative Reporting
Workshop](https://investigativereportingworkshop.org/) in Washington,
DC. The Accountability Project curates, cleans, and indexes public data
to give journalists, researchers and others a simple way to search
across otherwise siloed records.

The data focuses on people, organizations and locations. This package
was created specifically to help with state-level **camp**aign
**fin**ance data, although the tools included are useful in general
database exploration and normalization.

## Installation

The package is not yet on [CRAN](https://cran.r-project.org/) and must
be installed from GitHub.

``` r
# install.packages("remotes")
remotes::install_github("irworkshop/campfin")
```

## Normalize

The package was originally built to normalize geographic data using the
`normal_*()` functions, which take the messy self-reported geographic
data of a contributor, vendor, candidate, or committee and return
[normalized text](https://en.wikipedia.org/wiki/Text_normalization) that
is more searchable. They are largely wrappers around the
[`stringr`](https://github.com/tidyverse/stringr) package, and can call
other sub-functions to streamline normalization.

  - `normal_address()` takes a *street* address and reduces
    inconsistencies.
  - `normal_zip()` takes [ZIP
    Codes](https://cran.r-project.org/web/packages/zipcode/) and aims to
    return a valid 5-digit code.
  - `normal_state()` takes US states and returns a [2 digit
    abbreviation](https://en.wikipedia.org/wiki/List_of_U.S._state_abbreviations).
  - `normal_city()` takes cities and reduces inconsistencies.

Please see the vignette on normalization for an example of how these
functions are used to fix a wide variety of string inconsistencies and
make campaign finance data more consistent. In general, these functions
fix the following inconsistencies:

  - Capitalize with `str_to_upper()`
  - Replace hyphens and underscores with `str_replace()`
  - Remove remaining punctuation with `str_remove()`
  - Remove either numbers or letters (depending on data) with
    `str_remove()`
  - Remove excess white space with `str_trim()` and `str_squish()`
  - Replace abbreviations with `expand_abbrev()` (and
    `str_replace_all()`)
  - Remove invalid values with `na_out()` (and `str_which()`)

## Data

``` r
library(campfin)
library(stringr)
library(zipcode)
library(dplyr)
#> 
#> Attaching package: 'dplyr'
#> The following objects are masked from 'package:stats':
#> 
#>     filter, lag
#> The following objects are masked from 'package:base':
#> 
#>     intersect, setdiff, setequal, union
```

The campfin package contains a number of built in data frames and
strings used to help wrangle campaign finance data.

``` r
data(package = "campfin")$results[, "Item"]
#>  [1] "invalid_city" "rx_state"     "rx_zip"       "usps_city"    "usps_state"   "usps_street" 
#>  [7] "valid_city"   "valid_name"   "valid_state"  "valid_zip"    "vt_contribs"  "zipcodes"
```

The `/data-raw` directory contains the code used to create the objects.

### `zipcodes`

The `zipcodes` (plural) data frame is a normalized version of the
`zipcode` (singular) data frame from the
[`zipcode`](https://cran.r-project.org/web/packages/zipcode/) R package,
which itself is a version of the [CivicSpace US ZIP Code
Database](https://boutell.com/zipcodes/):

> This database was composed using ZIP code gazetteers from the US
> Census Bureau from 1999 and 2000, augmented with additional ZIP code
> information The database is believed to contain over 98% of the ZIP
> Codes in current use in the United States. The remaining ZIP Codes
> absent from this database are entirely PO Box or Firm ZIP codes added
> in the last five years, which are no longer published by the Census
> Bureau, but in any event serve a very small minority of the population
> (probably on the order of .1% or less). Although every attempt has
> been made to filter them out, this data set may contain up to .5%
> false positives, that is, ZIP codes that do not exist or are no longer
> in use but are included due to erroneous data sources.

The included `valid_city` and `valid_zip` vectors are sorted, unique
columns from the `zipcodes` data frame (although `valid_city` is being
updated to include more common neighborhoods and census-designated
places)

``` r
# zipcode version
data("zipcode")
sample_n(zipcode, 5)
#>     zip        city state latitude longitude
#> 1 73538       Elgin    OK 34.74738 -98.27805
#> 2 43947   Shadyside    OH 39.96455 -80.76013
#> 3 06117  W Hartford    CT 41.79140 -72.74853
#> 4 74466 Tullahassee    OK 35.96357 -95.51386
#> 5 41410       Cisco    KY 37.69064 -83.07459
class(zipcode)
#> [1] "data.frame"

# campfin version
sample_n(zipcodes, 5)
#> # A tibble: 5 x 3
#>   city        state zip  
#>   <chr>       <chr> <chr>
#> 1 SEVIERVILLE TN    37864
#> 2 EL PASO     TX    88579
#> 3 EUSTIS      ME    04936
#> 4 OKTAHA      OK    74450
#> 5 NEW HOLLAND OH    43145
class(zipcodes)
#> [1] "tbl_df"     "tbl"        "data.frame"
```

### `usps_*` and `valid_*`

The `usps_*` data frames were scraped from the official United States
Postal Service (USPS) [Postal Addressing
Standards](https://pe.usps.com/text/pub28/28apc_002.htm). These data
frames are designed to work with the abbreviation functionality of
`normal_address()` and `normal_city()` to replace common abbreviations
with their full equivalent.

`usps_city` is a curated subset of `usps_state`, whose full version
appear at least once in the `valid_city` vector from `zipcodes`. The
`valid_state` and `valid_name` vectors contain the columns from
`usps_state` and include territories not found in R’s build in
`state.abb` and `state.name` vectors.

``` r
sample_n(usps_street, 5)
#> # A tibble: 5 x 2
#>   abb   full   
#>   <chr> <chr>  
#> 1 VLG   VILLAGE
#> 2 RDGE  RIDGE  
#> 3 VL    VILLE  
#> 4 HT    HEIGHTS
#> 5 RM    ROOM
sample_n(usps_city, 5)
#> # A tibble: 5 x 2
#>   abb    full    
#>   <chr>  <chr>   
#> 1 JCTION JUNCTION
#> 2 ISLES  ISLE    
#> 3 GTWAY  GATEWAY 
#> 4 GATWAY GATEWAY 
#> 5 FT     FORT
sample_n(usps_state, 5)
#> # A tibble: 5 x 2
#>   abb   full                
#>   <chr> <chr>               
#> 1 VA    VIRGINIA            
#> 2 DC    DISTRICT OF COLUMBIA
#> 3 TN    TENNESSEE           
#> 4 LA    LOUISIANA           
#> 5 MS    MISSISSIPPI
setdiff(valid_state, state.abb)
#>  [1] "AS" "AA" "AE" "AP" "DC" "FM" "GU" "MH" "MP" "PW" "PR" "VI"
setdiff(str_to_title(valid_name), state.name)
#>  [1] "American Samoa"                 "Armed Forces Americas"         
#>  [3] "Armed Forces Europe"            "Armed Forces Pacific"          
#>  [5] "District Of Columbia"           "Federated States Of Micronesia"
#>  [7] "Guam"                           "Marshall Islands"              
#>  [9] "Northern Mariana Islands"       "Palau"                         
#> [11] "Puerto Rico"                    "Virgin Islands"
```

### Other

The `invalid_city` vector contains, appropriately, common invalid city
names, which can be passed to `normal_city()`.

``` r
sample(invalid_city, 5)
#> [1] "ON LINE"   "XXX"       "NONE GIVE" "ONLINE"    "WEB"
```

The `rx_zip` and `rx_state` character strings are useful regular
expressions for extracting geographic data from a single string address,
data which can then be passed to `normal_zip()` and `normal_state()`.

``` r
print(rx_zip)
#> [1] "[:digit:]{5}(?:-[:digit:]{4})?$"
print(rx_state)
#> [1] "[:alpha:]+(?=[:space:]+[:digit:]{5}(?:-[:digit:]{4})?$)"
```

``` r
white_house <- "1600 Pennsylvania Ave NW, Washington, DC 20500-0003"
str_extract(white_house, pattern = rx_zip)
#> [1] "20500-0003"
str_extract(white_house, pattern = rx_state)
#> [1] "DC"
```

The `vt_contribs` data frame contains example campaign contribution data
from a fictional election in Vermont. The data is used in the
normalization vignette.
