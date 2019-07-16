
<!-- README.md is generated from README.Rmd. Please edit that file -->

# campfin

[![CRAN
status](https://www.r-pkg.org/badges/version/whatr)](https://cran.r-project.org/package=campfin)

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

<p align="center">

<img src="https://investigativereportingworkshop.org/wp-content/uploads/2019/07/ap-logo-400x132.png">

</p>

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
#>      zip          city state latitude  longitude
#> 1  79187      Amarillo    TX 35.40147 -101.89509
#> 2  95502        Eureka    CA 40.81459 -124.08052
#> 3  51523       Blencoe    IA 41.91340  -96.08500
#> 4  02143    Somerville    MA 42.38193  -71.09908
#> 5  64661        Mercer    MO 40.52240  -93.54965
#> 6  65727          Polk    MO 37.78991  -93.27802
#> 7  25687         Nolan    WV 37.74306  -82.10801
#> 8  38043 Hickory Withe    TN 35.19926  -89.41411
#> 9  53066    Oconomowoc    WI 43.10824  -88.48935
#> 10 92123     San Diego    CA 32.80380 -117.13595

# normal cities in a better order
sample_n(campfin::geo, 10)
#> # A tibble: 10 x 3
#>    city             state zip  
#>    <chr>            <chr> <chr>
#>  1 MCINTOSH         NM    87032
#>  2 MELBOURNE        FL    32901
#>  3 CANASTOTA        NY    13032
#>  4 MONTGOMERY       IN    47558
#>  5 CHESTERVILLE     OH    43317
#>  6 FORT HALL        ID    83203
#>  7 INTERLACHEN      FL    32148
#>  8 NORTH BONNEVILLE WA    98639
#>  9 FLYNN            TX    77855
#> 10 PHOENIX          AZ    85042

# more US states than the built in state.abb
setdiff(geo$state, datasets::state.abb)
#>  [1] "PR" "VI" "AE" "DC" "AA" "AP" "AS" "GU" "PW" "FM" "MP" "MH"
```

The package also contains a useful list of common invalid values.

``` r
sample(campfin::na_city, 10)
#>  [1] "NO ADDRESS"           "N A"                  "TO FIND OUT"         
#>  [4] "NO INFORMATION GIVEN" "UNKNOWN"              "NULL"                
#>  [7] "UNKOWN"               "XXX"                  "NOTAPPLICABLE"       
#> [10] "NOT REQUIRED"
```

## Example

| address             | city         | state   | zip   |
| :------------------ | :----------- | :------ | :---- |
| 744 Cape Cod Rd.    | Stowe, VT    | VT      | 05672 |
| N/A                 | N/A          | N/A     | N/A   |
| 149\_Church\_Street | Burlington   | Vermont | 05401 |
| 51 depot square     | st johnsbury | vt      | 5819  |
| XXXXXXX             | UNKNOWN      | XX      | 00000 |

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
