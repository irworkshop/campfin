
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
# install.packages("devtools")
devtools::install_github("kiernann/campfin")
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
  - `prop_in(x, y)` (and `prop_out()`) wraps around `mean(x %in% y)`
  - `count_na(x)` wraps around `sum(is.na(x))`

More functions will be added over time to automate even more of the
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
#>      zip         city state latitude  longitude
#> 1  01342    Deerfield    MA 42.54232  -72.60910
#> 2  76855       Lowake    TX 31.33361  -99.85837
#> 3  90808   Long Beach    CA 33.82332 -118.11329
#> 4  93527     Inyokern    CA 35.73442 -117.89313
#> 5  99345     Paterson    WA 45.92202 -119.67687
#> 6  97375 Scotts Mills    OR 45.00422 -122.59658
#> 7  41426       Falcon    KY 37.78492  -82.99783
#> 8  95687    Vacaville    CA 38.34401 -121.95333
#> 9  70371      Kraemer    LA 29.86520  -90.59616
#> 10 14855       Jasper    NY 42.13594  -77.50780

# normal cities in a better order
sample_n(campfin::geo, 10)
#> # A tibble: 10 x 3
#>    city           state zip  
#>    <chr>          <chr> <chr>
#>  1 WASHBURN       WI    54891
#>  2 CUMBERLAND     VA    23040
#>  3 SANDY HOOK     VA    23153
#>  4 LINCOLN        NE    68528
#>  5 SALT LAKE CITY UT    84153
#>  6 BELOIT         WI    53512
#>  7 MARK           IL    61340
#>  8 APO            AE    09751
#>  9 LILBOURN       MO    63862
#> 10 HERMANN        MO    65041

# more US states than the built in state.abb
setdiff(geo$state, datasets::state.abb)
#>  [1] "PR" "VI" "AE" "DC" "AA" "AP" "AS" "GU" "PW" "FM" "MP" "MH"
```

The package also contains a useful list of common invalid values.

``` r
sample(campfin::na_city, 10)
#>  [1] "WEB"          "NOT STATED"   "NOT GIVEN"    "TEST"        
#>  [5] "XXXXX"        "INFO PENDING" "NONE"         "NO ADDRESS"  
#>  [9] "N/A"          "UNK"
```

## Example

In this example, we can see how the `normal_*()` functions turn messy
data into a single format.

| address             | city         | state   | zip        |
| :------------------ | :----------- | :------ | :--------- |
| 744 Cape Cod Rd.    | Stowe, VT    | VT      | 05672-5563 |
| N/A                 | N/A          | N/A     | N/A        |
| 149\_Church\_Street | Burlington   | Vermont | 05401      |
| 51 depot square     | st johnsbury | vt      | 5819       |
| XXXXXXX             | UNKNOWN      | XX      | 00000      |

``` r
vt_na <- c("", "NA", "UNKNOWN")
vt2 <- vt %>% mutate(
  address = normal_address(
    address = address,
    add_abbs = tibble(abb = "RD", rep = "ROAD"), 
    na = vt_na,
    na_rep = TRUE
  ),
  city = normal_city(
    city = city,
    geo_abbs = tibble(abb = "ST", rep = "SAINT"),
    st_abbs = c("VT"),
    na = vt_na,
    na_rep = TRUE
  ),
  state = normal_state(
    state = state,
    abbreviate = TRUE,
    na = ,
    na_rep = TRUE,
    valid = state.abb
  ),
  zip = normal_zip(
    zip = zip,
    na = vt_na,
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
