
<!-- README.md is generated from README.Rmd. Please edit that file -->

# campfin

[![CRAN
status](https://www.r-pkg.org/badges/version/whatr)](https://cran.r-project.org/package=campfin)

## Overview

The `campfin` package was created to facilitate the work being done by
[The Accountability
Project](https://www.publicaccountability.org/ "tap"), a journalism too
created by The Investigative Reporting Workshop. The Accountability
Project curates, cleans and indexes public data to give journalists,
researchers and others a simple way to search across otherwise siloed
records.

<p align="center">

<img src="https://investigativereportingworkshop.org/wp-content/uploads/2019/07/ap-logo-400x132.png">

</p>

The data focuses on people, organizations and locations. This package
was created to facilitate the wrangling of state-level **camp**aign
**fin**ance data.

## Installation

The package is not on CRAN and must be installed from GitHub.

``` r
# install.packages("devtools")
devtools::install_github("kiernann/campfin")
```

## Functions

The most important functions are the in the `normal_*()` family. These
functions take geographic data and return [normalized
text](https://en.wikipedia.org/wiki/Text_normalization "text_normal")
that is more searchable.

  - `normal_zip()` takes [ZIP
    Codes](https://en.wikipedia.org/wiki/ZIP_Code "zip_code") and
    returns a 5 digit character string
  - `normal_state()` takes US states and returns a [2 digit
    abbreviation](https://en.wikipedia.org/wiki/List_of_U.S._state_abbreviations "state_abbs")
  - `normal_address()` takes a *street* address and reduces
    inconsistencies
  - `normal_city()` takes city names and reduces inconsistencies, cross
    checks against normal ZIP codes, and performs [key collision cluster
    and n-gram
    merging](https://github.com/OpenRefine/OpenRefine/wiki/Clustering-In-Depth "open_refine")
    from the [`refinr`](https://github.com/ChrisMuir/refinr "refinr")
    package

There are other functions which help load, explore, and process campaign
finance data:

  - `all_files_new()` checks if all files in a directory have been
    recently downloaded
  - `glimpse_fun()` applies a function (like `dplyr::n_distinct()`) to
    every column in a data frame
  - `prop_in(x, y)` (and `prop_out()`) wrap around `mean(x %in% y)`
  - `count_na(x)` wraps around `sum(is.na(x))`

I intend to add more functions over time to automate even more of the
wrangling workflow.

## Data

The package also contains the `geo`
[tibble](https://tibble.tidyverse.org/ "tibble"), a normalized version
of the `zipcodes` data frame from the
[`zipcodes`](https://cran.r-project.org/web/packages/zipcode/ "zip_pkg")
R package, which itself is a version of the [CivicSpace US ZIP Code
Database](https://boutell.com/zipcodes/ "civic_space").

``` r
library(dplyr)
library(campfin)
library(zipcode)

data("zipcode")
sample_n(zipcode, 10)
#>      zip        city state latitude longitude
#> 1  12828 Fort Edward    NY 43.25312 -73.58549
#> 2  60074    Palatine    IL 42.14382 -88.02546
#> 3  33908  Fort Myers    FL 26.50268 -81.93052
#> 4  77549 Friendswood    TX 29.33050 -94.80024
#> 5  45250  Cincinnati    OH 39.16676 -84.53822
#> 6  31786    Shellman    GA 31.72952 -84.60173
#> 7  77090     Houston    TX 30.01271 -95.45132
#> 8  47165       Pekin    IN 38.49903 -86.01293
#> 9  41065 Muses Mills    KY 38.34810 -83.71863
#> 10 26269   Hambleton    WV 39.09754 -79.63848

# normal cities in a better order
sample_n(geo, 10)
#> # A tibble: 10 x 3
#>    city         state zip  
#>    <chr>        <chr> <chr>
#>  1 APO          AE    09393
#>  2 KITTERY      ME    03904
#>  3 VILLA PARK   CA    92861
#>  4 SALINE       LA    71070
#>  5 AKRON        OH    44322
#>  6 JACKSONVILLE FL    32258
#>  7 AVALON       MS    38912
#>  8 PORT LEYDEN  NY    13433
#>  9 HOFFMAN      NC    28347
#> 10 CARMEL       NY    10512

# more US states than the built in state.abb
setdiff(geo$state, datasets::state.abb)
#>  [1] "PR" "VI" "AE" "DC" "AA" "AP" "AS" "GU" "PW" "FM" "MP" "MH"
```

The package also contains a useful list of common invalid values.

``` r
sample(campfin::na_city, 10)
#>  [1] "UNK"           "NOT SURE"      "NONE"          "VIRTUAL"      
#>  [5] "NONE GIVEN"    "INFO PENDING"  "INTERNET"      "EVERYWHERE"   
#>  [9] "NOT PROVIDED"  "NOTAPPLICABLE"
```

## Example

``` r
library(tibble)
library(knitr)

vt <- tribble(
  ~address,             ~city,          ~state,    ~zip,
  "744 Cape Cod Rd.",    "Stowe, VT",    "VT",      "05672",
  "N/A",                "N/A",          "N/A",     "N/A",
  "149_Church_Street",  "Burlington",   "Vermont", "05401", 
  "51 depot   square",  "st johnsbury", "vt",      "5819",
  "XXXXXXX",            "UNKNOWN",      "XX",      "00000"
)

kable(vt)
```

| address             | city         | state   | zip   |
| :------------------ | :----------- | :------ | :---- |
| 744 Cape Cod Rd.    | Stowe, VT    | VT      | 05672 |
| N/A                 | N/A          | N/A     | N/A   |
| 149\_Church\_Street | Burlington   | Vermont | 05401 |
| 51 depot square     | st johnsbury | vt      | 5819  |
| XXXXXXX             | UNKNOWN      | XX      | 00000 |

``` r
library(campfin)

vt$address <- normal_address(
  address = vt$address,
  add_abbs = tibble(abb = "RD", rep = "ROAD"), 
  na = c("", "NA", "UNKNOWN"),
  na_rep = TRUE
)

vt$city <- normal_city(
  city = vt$city,
  geo_abbs = tibble(abb = "ST", rep = "SAINT"),
  st_abbs = c("VT"),
  na = c("", "NA", "UNKNOWN"),
  na_rep = TRUE
)

vt$state <- normal_state(
  state = vt$state,
  abbreviate = TRUE,
  na = c("", "NA", "UNKNOWN"),
  na_rep = TRUE,
  valid = state.abb
)

vt$zip <- normal_zip(
  zip = vt$zip,
  na = c("", "NA", "UNKNOWN"),
  na_rep = TRUE
)

kable(vt)
```

| address           | city            | state | zip   |
| :---------------- | :-------------- | :---- | :---- |
| 744 CAPE COD ROAD | STOWE           | VT    | 05672 |
| NA                | NA              | NA    | NA    |
| 149 CHURCH STREET | BURLINGTON      | VT    | 05401 |
| 51 DEPOT SQUARE   | SAINT JOHNSBURY | VT    | 05819 |
| NA                | NA              | NA    | NA    |
