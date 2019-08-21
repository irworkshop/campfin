
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

  - `abrev_state()` returns the 2 letter state abbreviation for a full
    state name
  - `all_files_new()` checks if all files in a directory have been
    recently downloaded
  - `count_na(x)` wraps around `sum(is.na(x))` (useful with
    `glimpse_fun()`)
  - `explore_plot()` wraps around `ggplot2::geom_col()` to create
    exploratory bar plots
  - `flag_dupes()` wraps around `duplicated(dplyr::select())` to create
    a new logical column
  - `flag_na()` wraps around `complete.cases(dplyr::select())`to create
    a new logical column
  - `glimpse_fun()` applies a function (like `dplyr::n_distinct()`) to
    every column in a data frame
  - `is_even(x)` wraps around `x %% 2 == 0` (useful for selecting
    election years)
  - `most_common()` return the `n` most common values of a vector
  - `na_out(x, y)` returns `x` with `NA` for any value *not* in `y`
  - `prop_in(x, y)` (and `prop_out()`) wraps around `mean(x %in% y)`
  - `prop_na(x)` wraps around `mean(is.na(x))`
  - `read_mdb()` pass `mbt-export` to `readr::read_csv()`
  - `x %out% y` wraps around `!(x %in% y)`
  - `url_file_size()` calls `httr::HEAD()` to return a formated file
    size

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
#> [1] "geo"         "na_city"     "rx_state"    "rx_zip"      "usps"       
#> [6] "usps_city"   "valid_city"  "valid_state" "valid_zip"
```

The `geo` [tibble](https://tibble.tidyverse.org/ "tibble") is a
normalized version of the `zipcodes` data frame from the
[`zipcodes`](https://cran.r-project.org/web/packages/zipcode/ "zip_pkg")
R package, which itself is a version of the [CivicSpace US ZIP Code
Database](https://boutell.com/zipcodes/ "civic_space").

The `valid_city`, `valid_state`, and `valid_zip` are the unique, sorted
columns of thr `geo` data frame.

``` r
data("zipcode")
sample_n(zipcode, 10)
#>      zip           city state latitude  longitude
#> 1  02861      Pawtucket    RI 41.88163  -71.35583
#> 2  59084         Teigen    MT 47.17364 -108.28117
#> 3  13808         Morris    NY 42.53297  -75.25536
#> 4  92403 San Bernardino    CA 34.83996 -115.96705
#> 5  15765       Penn Run    PA 40.59285  -78.98412
#> 6  29520         Cheraw    SC 34.68862  -79.92315
#> 7  23154         Schley    VA 37.41824  -76.50840
#> 8  70761        Norwood    LA 30.97229  -91.07895
#> 9  28520   Cedar Island    NC 34.98461  -76.19880
#> 10 75209         Dallas    TX 32.84598  -96.82552

# normal cities in a better order
sample_n(geo, 10)
#> # A tibble: 10 x 3
#>    city         state zip  
#>    <chr>        <chr> <chr>
#>  1 EMLENTON     PA    16373
#>  2 PRAIRIE HOME MO    65068
#>  3 OLATON       KY    42361
#>  4 MAGEE        MS    39111
#>  5 LEXINGTON    KY    40536
#>  6 ELKO         GA    31025
#>  7 SLOATSBURG   NY    10974
#>  8 MUNCIE       IN    47302
#>  9 LINDSEY      OH    43442
#> 10 GARDINER     ME    04345

# more US states than the built in state.abb
setdiff(valid_state, state.abb)
#>  [1] "AA" "AB" "AE" "AP" "AS" "BC" "DC" "FM" "GU" "MB" "MH" "MP" "NB" "NL"
#> [15] "NS" "ON" "PE" "PR" "PW" "QC" "SK" "VI"
```

The `na_city` vector contains common invalid city names, which can be
passed to `normal_city()`.

``` r
sample(na_city, 10)
#>  [1] "UNKOWN"                "VIRTUAL"              
#>  [3] "PO BOX"                "REQUESTED"            
#>  [5] "INFO REQUESTED"        "NOT PROVIDED"         
#>  [7] "XXXX"                  "INFORMATION REQUESTED"
#>  [9] "UNKNOWN CITY"          "PENDING"
```

The `usps` (and `usps_city`) data frames can be used with `normal_*()`
to expand the [official USPS C-1
abbreviations](https://pe.usps.com/text/pub28/28apc_002.htm).

``` r
sample_n(usps, 10)
#> # A tibble: 10 x 2
#>    abb     rep      
#>    <chr>   <chr>    
#>  1 GROV    GROVE    
#>  2 ANNX    ANEX     
#>  3 HIGHWY  HIGHWAY  
#>  4 EXTN    EXTENSION
#>  5 AV      AVENUE   
#>  6 LDG     LODGE    
#>  7 LNDNG   LANDING  
#>  8 FRT     FORT     
#>  9 STRAVEN STRAVENUE
#> 10 ALY     ALLEY
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
