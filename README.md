
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
#>      zip             city state latitude  longitude
#> 1  48303 Bloomfield Hills    MI 42.66009  -83.38630
#> 2  61038   Garden Prairie    IL 42.25562  -88.74344
#> 3  54229      New Franken    WI 44.56000  -87.81553
#> 4  64022            Dover    MO 39.19255  -93.68661
#> 5  79903          El Paso    TX 31.78622 -106.44583
#> 6  16950        Westfield    PA 41.89584  -77.52164
#> 7  78279      San Antonio    TX 29.43753  -98.46158
#> 8  35072        Goodwater    AL 33.08934  -86.04682
#> 9  93943         Monterey    CA 36.35433 -121.13293
#> 10 95297         Stockton    CA 37.88985 -121.25387

# normal cities in a better order
sample_n(campfin::geo, 10)
#> # A tibble: 10 x 3
#>    city        state zip  
#>    <chr>       <chr> <chr>
#>  1 BENGE       WA    99105
#>  2 LOUISVILLE  IL    62858
#>  3 CALHOUN     GA    30703
#>  4 BRANCHDALE  PA    17923
#>  5 EUDORA      MO    65645
#>  6 ALTO        MI    49302
#>  7 PITTSBURGH  PA    15298
#>  8 LONOKE      AR    72086
#>  9 HONEY CREEK WI    53138
#> 10 HINKLEY     CA    92347

# more US states than the built in state.abb
setdiff(geo$state, datasets::state.abb)
#>  [1] "PR" "VI" "AE" "DC" "AA" "AP" "AS" "GU" "PW" "FM" "MP" "MH"
```

The package also contains a useful list of common invalid values.

``` r
sample(campfin::na_city, 10)
#>  [1] "TEST"           "WEBSITE"        "NOT PROVIDED"   "TO FIND OUT"   
#>  [5] "IR"             "INFO REQUESTED" "INFO PENDING"   "VARIOUS"       
#>  [9] "N A"            "XXXX"
```

## Example

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
