
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
across otherwise siloed records. The data focuses on people,
organizations and locations. This package was created specifically to
help with state-level **camp**aign **fin**ance data, although the tools
included are useful in general database exploration and normalization.

Campaign finance is comprised of two types of financial transactions:
**contributions** made *to* the campaign and **expenditures** made *by*
the campaign (money paid to lobbyists is sometimes considered separate
from regular expenditures).

American politics requires campaign finance on the federal, state, and
municipal elections. As of now, this package contains tools used to
process state-level data, which is typically reported *by* the
campaigns, which can often result in a disparity in data quality. The
`campfin` package can be used to reduce this disparity in a consistent,
confident, and programmatic manner.

## Installation

The package is not yet on [CRAN](https://cran.r-project.org/) and must
be installed from GitHub. As of now, the package lives on the GitHub
page of it’s original developer.

``` r
if (!require("pacman")) install.packages("pacman")
pacman::p_load_current_gh("kiernann/campfin")
pacman::p_load(tidyverse, zipcode)
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
make campaign finance data more consistent.

## Data

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
#>     zip          city state latitude  longitude
#> 1 49913       Calumet    MI 47.23908  -88.46121
#> 2 37029         Burns    TN 36.04774  -87.28938
#> 3 93150 Santa Barbara    CA 34.26283 -119.84856
#> 4 47018     Dillsboro    IN 38.99247  -85.06601
#> 5 68950      Holstein    NE 40.46582  -98.65405
class(zipcode)
#> [1] "data.frame"

# campfin version
sample_n(zipcodes, 5)
#> # A tibble: 5 x 3
#>   city           state zip  
#>   <chr>          <chr> <chr>
#> 1 BARIUM SPRINGS NC    28010
#> 2 ENFIELD        IL    62835
#> 3 WASHINGTON     DC    20380
#> 4 LONGDALE       OK    73755
#> 5 STERLING       VA    20163
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
#> 1 AVEN  AVENUE   
#> 2 HVN   HAVEN    
#> 3 LDGE  LODGE    
#> 4 STRA  STRAVENUE
#> 5 CRCLE CIRCLE
sample_n(usps_city, 5)
#> # A tibble: 5 x 2
#>   abb    full   
#>   <chr>  <chr>  
#> 1 UN     UNION  
#> 2 SPGS   SPRINGS
#> 3 GATEWY GATEWAY
#> 4 FRD    FORD   
#> 5 ISLES  ISLE
sample_n(usps_state, 5)
#> # A tibble: 5 x 2
#>   abb   full               
#>   <chr> <chr>              
#> 1 OK    OKLAHOMA           
#> 2 WV    WEST VIRGINIA      
#> 3 VA    VIRGINIA           
#> 4 AE    ARMED FORCES EUROPE
#> 5 LA    LOUISIANA
setdiff(valid_state, state.abb)
#>  [1] "AS" "AA" "AE" "AP" "DC" "FM" "GU" "MH" "MP" "PW" "PR" "VI"
setdiff(valid_name, str_to_upper(state.name))
#>  [1] "AMERICAN SAMOA"                 "ARMED FORCES AMERICAS"         
#>  [3] "ARMED FORCES EUROPE"            "ARMED FORCES PACIFIC"          
#>  [5] "DISTRICT OF COLUMBIA"           "FEDERATED STATES OF MICRONESIA"
#>  [7] "GUAM"                           "MARSHALL ISLANDS"              
#>  [9] "NORTHERN MARIANA ISLANDS"       "PALAU"                         
#> [11] "PUERTO RICO"                    "VIRGIN ISLANDS"
```

### Other

The `invalid_city` vector contains, appropriately, common invalid city
names, which can be passed to `normal_city()`.

``` r
sample(invalid_city, 5)
#> [1] "INFO REQUESTED" "UNKOWN"         "N/A"            "NOT REQUIRED"   "MISSING"
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
