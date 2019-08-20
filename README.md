
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
#>      zip         city state latitude  longitude
#> 1  18921     Ferndale    PA 40.32865  -75.10278
#> 2  71950        Kirby    AR 34.25111  -93.76005
#> 3  67057     Hardtner    KS 37.04173  -98.67631
#> 4  31995 Fort Benning    GA 32.49584  -84.96398
#> 5  05823  Beebe Plain    VT 45.00578  -72.13835
#> 6  12148      Rexford    NY 42.84213  -73.86828
#> 7  90097  Los Angeles    CA 33.78659 -118.29866
#> 8  47226     Clifford    IN 39.28249  -85.86852
#> 9  64671         Polo    MO 39.54190  -94.05158
#> 10 37246    Nashville    TN 36.15861  -86.79000

# normal cities in a better order
sample_n(campfin::geo, 10)
#> # A tibble: 10 x 3
#>    city         state zip  
#>    <chr>        <chr> <chr>
#>  1 ACWORTH      GA    30101
#>  2 ROCKFORD     OH    45882
#>  3 STETSONVILLE WI    54480
#>  4 NEW HAVEN    IL    62867
#>  5 SENECA       NE    69161
#>  6 SAN ANTONIO  TX    78203
#>  7 CALHAN       CO    80808
#>  8 AURORA       CO    80046
#>  9 SCOTTS MILLS OR    97375
#> 10 CAPE CORAL   FL    33915

# more US states than the built in state.abb
setdiff(geo$state, datasets::state.abb)
#>  [1] "PR" "VI" "AE" "DC" "AA" "AP" "AS" "GU" "PW" "FM" "MP" "MH" "AB" "BC"
#> [15] "MB" "NB" "NL" "NS" "ON" "PE" "QC" "SK"
```

The `na_city` vector contains common invalid city names, which can be
passed to `normal_city()`.

``` r
sample(na_city, 10)
#>  [1] "NONE GIVEN"            "NO ADDRESS"           
#>  [3] "NONE GIVE"             "TEST"                 
#>  [5] "UK"                    "ONLINE SERVICE"       
#>  [7] "NOT REQUIRED"          "NON REPORTABLE"       
#>  [9] "REQUESTED INFORMATION" "INTERNET"
```

The `usps` (and `usps_city`) data frames can be used with `normal_*()`
to expand the [official USPS C-1
abbreviations](https://pe.usps.com/text/pub28/28apc_002.htm).

``` r
sample_n(usps, 10)
#> # A tibble: 10 x 2
#>    abb   rep    
#>    <chr> <chr>  
#>  1 ARC   ARCADE 
#>  2 HT    HEIGHTS
#>  3 IS    ISLAND 
#>  4 VIA   VIADUCT
#>  5 FORG  FORGE  
#>  6 MDW   MEADOWS
#>  7 KYS   KEYS   
#>  8 PKWY  PARKWAY
#>  9 BYPA  BYPASS 
#> 10 CT    COURT
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
