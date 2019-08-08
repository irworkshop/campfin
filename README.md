
<!-- README.md is generated from README.Rmd. Please edit that file -->

# campfin <img src="man/figures/logo.png" align="right" width="120" />

[![CRAN\_Status\_Badge](http://www.r-pkg.org/badges/version/campfin)](https://cran.r-project.org/package=campfin)

## Overview

The `campfin` package was created to facilitate the work being done by
[The Accountability
Project](https://www.publicaccountability.org/ "tap"), a tool created by
[The Investigative Reporting
Workshop](https://investigativereportingworkshop.org/ "irw"). The
Accountability Project curates, cleans and indexes public data to give
journalists, researchers and others a simple way to search across
otherwise siloed records. The data focuses on people, organizations and
locations. This package was created specifically to helo with
state-level **camp**aign **fin**ance data.

## Installation

The package is not on CRAN and must be installed from GitHub.

``` r
# install.packages("remotes")
remotes::install_github("kiernann/campfin")
```

## Functions

The most important functions are the in the `normal_*()` family. These
functions take geographic data and return [normalized
text](https://en.wikipedia.org/wiki/Text_normalization "text_normal")
that is more searchable. They are largely wrappers around the [`stringr`
package](https://github.com/tidyverse/stringr "stringr").

  - `normal_zip()` takes [ZIP
    Codes](https://en.wikipedia.org/wiki/ZIP_Code "zip_code") and
    returns a 5 digit character string
  - `normal_state()` takes US states and returns a [2 digit
    abbreviation](https://en.wikipedia.org/wiki/List_of_U.S._state_abbreviations "state_abbs")
  - `normal_address()` takes a *street* address and reduces
    inconsistencies
  - `normal_city()` takes cities and reduces inconsistencies (to help
    with [cluster and
    merging](https://github.com/OpenRefine/OpenRefine/wiki/Clustering-In-Depth "open_refine"))

There are other functions which help load, explore, and process campaign
finance data:

  - `all_files_new()` checks if all files in a directory have been
    recently downloaded
  - `glimpse_fun()` applies a function (like `dplyr::n_distinct()`) to
    every column in a data frame
  - `count_na(x)` wraps around `sum(is.na(x))` (useful with
    `glimpse_fun()`)
  - `flag_dupes()` wraps around `duplicated(dplyr::select())` to create
    a new logical column
  - `flag_na()` wraps around `complete.cases(dplyr::select())`to create
    a new logical column
  - `prop_in(x, y)` (and `prop_out()`) wraps around `mean(x %in% y)`
  - `x %out% y` wraps around `!(x %in% y)`
  - `is_even(x)` wraps around `x %% 2 == 0` (useful for selecting
    election years)
  - `abrev_state()` returns the 2 letter state abbreviation for a full
    name(s)

More functions will be added over time to automate even more of the
wrangling workflow.

## Data

``` r
library(dplyr)
library(stringr)
library(campfin)
library(zipcode)
```

The campfin package contains a number of built in data frames and
strings used to help wrangle campaign finance data.

``` r
data(package = "campfin")$results[, "Item"]
#> [1] "geo"       "na_city"   "rx_state"  "rx_zip"    "usps"      "usps_city"
```

The `geo` [tibble](https://tibble.tidyverse.org/ "tibble") is a
normalized version of the `zipcodes` data frame from the
[`zipcodes`](https://cran.r-project.org/web/packages/zipcode/ "zip_pkg")
R package, which itself is a version of the [CivicSpace US ZIP Code
Database](https://boutell.com/zipcodes/ "civic_space").

``` r
data("zipcode")
sample_n(zipcode, 10)
#>      zip        city state latitude  longitude
#> 1  57375    Stickney    SD 43.55629  -98.46986
#> 2  27326      Ruffin    NC 36.47835  -79.55518
#> 3  57569    Reliance    SD 43.84000  -99.57459
#> 4  96137    Westwood    CA 40.29001 -121.05272
#> 5  31648 Statenville    GA 30.70318  -83.02568
#> 6  52639    Montrose    IA 40.54740  -91.43864
#> 7  84715    Bicknell    UT 38.33879 -111.54921
#> 8  48017     Clawson    MI 42.53553  -83.15112
#> 9  78567  Los Indios    TX 26.04167  -97.69374
#> 10 71428       Flora    LA 31.61244  -93.09796

# normal cities in a better order
sample_n(campfin::geo, 10)
#> # A tibble: 10 x 3
#>    city          state zip  
#>    <chr>         <chr> <chr>
#>  1 HOLLY GROVE   AR    72069
#>  2 ISABELLA      MO    65676
#>  3 TRENTON       NJ    08604
#>  4 DEERFIELD     VA    24432
#>  5 ROCHESTER     WA    98579
#>  6 BELVIDERE     SD    57521
#>  7 HALLETTSVILLE TX    77965
#>  8 TYRONE        OK    73951
#>  9 LOS ANGELES   CA    90014
#> 10 COLLINS       NY    14034

# more US states than the built in state.abb
setdiff(geo$state, datasets::state.abb)
#>  [1] "PR" "VI" "AE" "DC" "AA" "AP" "AS" "GU" "PW" "FM" "MP" "MH" "AB" "BC"
#> [15] "MB" "NB" "NL" "NS" "ON" "PE" "QC" "SK"
```

The `na_city` vector contains common invalid city names, which can be
passed to `normal_city()`.

``` r
sample(na_city, 10)
#>  [1] "WEBSITE"               "REQUESTED INFO"       
#>  [3] "NOTAPPLICABLE"         "PENDING"              
#>  [5] "INFORMATION REQUESTED" "INFO REQUESTED"       
#>  [7] "NON REPORTABLE"        "VARIOUS"              
#>  [9] "P O BOX"               "ONLINE COMPANY"
```

The `usps` (and `usps_city`) data frames can be used with `normal_*()`
to expand the [official USPS C-1
abbreviations](https://pe.usps.com/text/pub28/28apc_002.htm).

``` r
sample_n(usps, 10)
#> # A tibble: 10 x 2
#>    abb      rep     
#>    <chr>    <chr>   
#>  1 CANYN    CANYON  
#>  2 VILLIAGE VILLAGE 
#>  3 EST      ESTATE  
#>  4 CRK      CREEK   
#>  5 RAD      RADIAL  
#>  6 GRDN     GARDEN  
#>  7 VIADCT   VIADUCT 
#>  8 RST      REST    
#>  9 VIST     VISTA   
#> 10 CRSENT   CRESCENT
```

The `rx_zip` and `rx_state` character strings are useful regular
expressions for extracting data from a single string address, which can
then be passed to `normal_zip()` and `normal_state()`.

``` r
print(rx_zip)
#> [1] "[:digit:]{5}(?:-[:digit:]{4})?$"
print(rx_state)
#> [1] "[:alpha:]+(?=[:space:]+[:digit:]{5}(?:-[:digit:]{4})?$)"
```

``` r
white_house <- "1600 Pennsylvania Ave NW, Washington, DC 20500-0003"
str_extract(string = white_house, pattern = rx_zip)
#> [1] "20500-0003"
str_extract(string = white_house, pattern = rx_state)
#> [1] "DC"
```

Work is being done to incorperate regular expressions for addresses and
city names, although the immense possibility for variation makes these
elements harder to generalize.

## Example

In this example, we can see how the `normal_*()` function work with the
built in data to turn messy data into a single normalized format.

| address             | city         | state   | zip        |
| :------------------ | :----------- | :------ | :--------- |
| 744 Cape Cod Rd.    | Stowe, VT    | VT      | 05672-5563 |
| N/A                 | N/A          | N/A     | N/A        |
| 149\_Church\_Street | Burlington   | Vermont | 05401      |
| 51 depot square     | st johnsbury | vt      | 5819       |
| XXXXXXX             | UNKNOWN      | XX      | 00000      |

``` r
vt2 <- vt %>% mutate(
  address = normal_address(
    address = address,
    # expand street abbs
    add_abbs = usps,
    # remove invalid strings
    na = na_city,
    # remove single repeating chars
    na_rep = TRUE
  ),
  city = normal_city(
    city = city,
    # expand city abbs
    geo_abbs = usps_city,
    # remove state abbs
    st_abbs = c("VT"),
    # remove invalid cities
    na = na_city,
    na_rep = TRUE
  ),
  state = normal_state(
    state = state,
    abbreviate = TRUE,
    # remove all not in geo
    valid = geo$state
  ),
  zip = normal_zip(
    zip = zip,
    na = na_city,
    na_rep = TRUE
  )
)
```

| address           | city            | state | zip   |
| :---------------- | :-------------- | :---- | :---- |
| 744 CAPE COD ROAD | STOWE           | VT    | 05672 |
| NA                | NA              | NA    | NA    |
| 149 CHURCH STREET | BURLINGTON      | VT    | 05401 |
| 51 DEPOT SQUARE   | SAINT JOHNSBURY | VT    | 05819 |
| NA                | NA              | NA    | NA    |
