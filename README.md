
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
library(tidyverse)
library(campfin)
library(zipcode)
data("zipcode")

sample_n(zipcode, 10)
#>      zip         city state latitude  longitude
#> 1  70654       Mittie    LA 30.71056  -92.89081
#> 2  03077      Raymond    NH 43.03149  -71.19598
#> 3  54110     Brillion    WI 44.17950  -88.07449
#> 4  54490     Westboro    WI 45.32103  -90.40218
#> 5  96148  Tahoe Vista    CA 39.24388 -120.05437
#> 6  76401 Stephenville    TX 32.24282  -98.21058
#> 7  33609        Tampa    FL 27.94355  -82.50656
#> 8  55454  Minneapolis    MN 44.96946  -93.24327
#> 9  37927    Knoxville    TN 35.99014  -83.96218
#> 10 24981      Talcott    WV 37.65427  -80.72899

geo <- zipcode %>%
  as_tibble() %>% 
  mutate(city= normal_city(city)) %>%
  select(city, state, zip)

# normal cities in a better order
sample_n(geo, 10)
#> # A tibble: 10 x 3
#>    city             state zip  
#>    <chr>            <chr> <chr>
#>  1 ALMA             NE    68920
#>  2 FORESTVILLE      PA    16035
#>  3 WILMOT           WI    53192
#>  4 GURDON           AR    71743
#>  5 WILMINGTON       NC    28405
#>  6 DENBO            PA    15429
#>  7 CORPUS CHRISTI   TX    78417
#>  8 NORTH CARROLLTON MS    38947
#>  9 MOUNT VICTORIA   MD    20661
#> 10 ELLICOTTVILLE    NY    14731

# more US states than the built in state.abb
setdiff(geo$state, datasets::state.abb)
#>  [1] "PR" "VI" "AE" "DC" "AA" "AP" "AS" "GU" "PW" "FM" "MP" "MH"
```

The package also contains a useful list of common invalid values.
