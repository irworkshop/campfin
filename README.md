
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

![tap](https://investigativereportingworkshop.org/wp-content/uploads/2019/07/ap-logo-400x132.png)

The data focuses on people, organizations and locations. This package
was created to facilitate the wrangling of state-level **camp**aign
**fin**ance data.

## Installation

The package is not on CRAN and must be installed from GitHub.

``` r
# install.packages("devtools")
devtools::install_github("kiernann/campfin")
```

    #> Installing package into '/home/ubuntu/R/x86_64-pc-linux-gnu-library/3.6'
    #> (as 'lib' is unspecified)

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
  - `prop_in()` (and `prop_out()`) wrap around `mean(x %in% y)`

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
#>      zip       city state latitude  longitude
#> 1  69210  Ainsworth    NE 42.53038  -99.88206
#> 2  80292     Denver    CO 39.74739 -104.99284
#> 3  77294    Houston    TX 29.86000  -95.24000
#> 4  18962 Silverdale    PA 40.34602  -75.26953
#> 5  59452     Hobson    MT 46.88305 -110.09673
#> 6  89445 Winnemucca    NV 41.02951 -117.94402
#> 7  70053     Gretna    LA 29.91536  -90.05335
#> 8  77260    Houston    TX 29.67000  -95.24000
#> 9  67452     Hunter    KS 39.22920  -98.38455
#> 10 79948    El Paso    TX 31.69484 -106.29999

geo <- zipcode %>%
  as_tibble() %>% 
  mutate(city= normal_city(city)) %>%
  select(city, state, zip)

# normal cities in a better order
sample_n(geo, 10)
#> # A tibble: 10 x 3
#>    city          state zip  
#>    <chr>         <chr> <chr>
#>  1 SUGAR GROVE   OH    43155
#>  2 HANOVER PARK  IL    60133
#>  3 OKLAHOMA CITY OK    73151
#>  4 WESTPHALIA    MO    65085
#>  5 LUCIEN        OK    73757
#>  6 CAMPBELLTOWN  PA    17010
#>  7 VICTORIA      MS    38679
#>  8 BIRDS         IL    62415
#>  9 ELLSWORTH     NE    69340
#> 10 HALLETTSVILLE TX    77964

# more US states than the built in state.abb
setdiff(geo$state, datasets::state.abb)
#>  [1] "PR" "VI" "AE" "DC" "AA" "AP" "AS" "GU" "PW" "FM" "MP" "MH"
```

The package also contains a useful list of common invalid values.
