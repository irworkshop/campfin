
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
#>      zip             city state latitude  longitude
#> 1  47041           Sunman    IN 39.24068  -85.08587
#> 2  81141          Manassa    CO 37.14494 -105.90161
#> 3  46409             Gary    IN 41.54474  -87.32716
#> 4  90091      Los Angeles    CA 33.78659 -118.29866
#> 5  34984 Port Saint Lucie    FL 27.27327  -80.34727
#> 6  70469          Slidell    LA 30.42551  -89.88126
#> 7  38849          Guntown    MS 34.44392  -88.67217
#> 8  54624          De Soto    WI 43.43389  -91.15949
#> 9  13220         Syracuse    NY 43.12342  -76.12823
#> 10 67361            Sedan    KS 37.10787  -96.22087

# normal cities in a better order
sample_n(campfin::geo, 10)
#> # A tibble: 10 x 3
#>    city         state zip  
#>    <chr>        <chr> <chr>
#>  1 MONTICELLO   MN    55590
#>  2 SICKLERVILLE NJ    08081
#>  3 OAKLAND      OR    97462
#>  4 VANDERPOOL   TX    78885
#>  5 HOUSTON      TX    77284
#>  6 SARDINIA     SC    29143
#>  7 OLD BRIDGE   NJ    08857
#>  8 MORICHES     NY    11955
#>  9 POWHATAN     LA    71066
#> 10 HIGHLANDS    TX    77562

# more US states than the built in state.abb
setdiff(geo$state, datasets::state.abb)
#>  [1] "PR" "VI" "AE" "DC" "AA" "AP" "AS" "GU" "PW" "FM" "MP" "MH" "AB" "BC"
#> [15] "MB" "NB" "NL" "NS" "ON" "PE" "QC" "SK"
```

The `na_city` vector contains common invalid city names, which can be
passed to `normal_city()`.

``` r
sample(na_city, 10)
#>  [1] "WEB"       "IR"        "XXXXXX"    "VARIOUS"   "NA"       
#>  [6] "NOT KNOWN" "REQUESTED" "TEST"      "N A"       "XXX"
```

The `usps` (and `usps_city`) data frames can be used with `normal_*()`
to expand the [official USPS C-1
abbreviations](https://pe.usps.com/text/pub28/28apc_002.htm).

``` r
sample_n(usps, 10)
#> # A tibble: 10 x 2
#>    abb    rep      
#>    <chr>  <chr>    
#>  1 HTS    HEIGHTS  
#>  2 JCT    JUNCTION 
#>  3 PR     PRAIRIE  
#>  4 CORS   CORNERS  
#>  5 DL     DALE     
#>  6 MTN    MOUNTAIN 
#>  7 SPGS   SPRINGS  
#>  8 SHL    SHOAL    
#>  9 TRAILS TRAIL    
#> 10 STRAV  STRAVENUE
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
