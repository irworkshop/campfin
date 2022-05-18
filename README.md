
<!-- README.md is generated from README.Rmd. Please edit that file -->

# campfin <img src="man/figures/logo.png" align="right" width="120" />

<!-- badges: start -->

[![Lifecycle:
maturing](https://img.shields.io/badge/lifecycle-maturing-blue.svg)](https://lifecycle.r-lib.org/articles/stages.html)
[![CRAN
status](https://www.r-pkg.org/badges/version/campfin)](https://CRAN.R-project.org/package=campfin)
![Downloads](https://cranlogs.r-pkg.org/badges/grand-total/campfin)
[![Codecov test
coverage](https://img.shields.io/codecov/c/github/irworkshop/campfin/master.svg)](https://app.codecov.io/gh/irworkshop/campfin?branch=master)
[![R build
status](https://github.com/irworkshop/campfin/workflows/R-CMD-check/badge.svg)](https://github.com/irworkshop/campfin/actions)
<!-- badges: end -->

The campfin package was created to facilitate the work being done on the
[The Accountability Project](https://www.publicaccountability.org/), a
tool created by [The Investigative Reporting
Workshop](https://investigativereportingworkshop.org/) in Washington,
DC. The Accountability Project curates, cleans, and indexes public data
to give journalists, researchers and others a simple way to search
across otherwise siloed records.

The data focuses on people, organizations and locations. This package
was created specifically to help with state-level campaign finance data,
although the tools included are useful in general database exploration
and normalization.

## Installation

You can install the released version of campfin from
[CRAN](https://cran.r-project.org/package=campfin) with:

``` r
install.packages("campfin")
```

The development version can be installed from
[GitHub](https://github.com/irworkshop/campfin) with:

``` r
# install.packages("remotes")
remotes::install_github("irworkshop/campfin")
```

## Normalize

The package was originally built to normalize geographic data using the
`normal_*()` functions, which take the messy self-reported geographic
data of a contributor, vendor, candidate, or committee and return
[normalized text](https://en.wikipedia.org/wiki/Text_normalization) that
is more searchable. They are largely wrappers around the
[stringr](https://github.com/tidyverse/stringr) package, and can call
other sub-functions to streamline normalization.

-   `normal_address()` takes a *street* address and reduces
    inconsistencies.
-   `normal_zip()` takes [ZIP
    Codes](https://en.wikipedia.org/wiki/ZIP_Code) and aims to return a
    valid 5-digit code.
-   `normal_state()` takes US states and returns a [2 digit
    abbreviation](https://en.wikipedia.org/wiki/List_of_U.S._state_abbreviations).
-   `normal_city()` takes cities and reduces inconsistencies.
-   `normal_phone()` consistently formats US telephone numbers.

Please see the vignette on normalization for an example of how these
functions are used to fix a wide variety of string inconsistencies and
make campaign finance data more consistent.

## Data

``` r
library(campfin)
library(tidyverse)
```

The campfin package contains a number of built in data frames and
strings used to help wrangle campaign finance data.

The `/data-raw` directory contains the code used to create the objects.

### zipcodes

The `zipcodes` (plural) table is a new version of the `zipcode`
(singular) table from the archived
[zipcode](https://cran.r-project.org/src/contrib/Archive/zipcode/) R
package.

> This database was composed using ZIP code gazetteers from the US
> Census Bureau from 1999 and 2000, augmented with additional ZIP code
> information The database is believed to contain over 98% of the ZIP
> Codes in current use in the United States. The remaining ZIP Codes
> absent from this database are entirely PO Box or Firm ZIP codes added
> in the last five years, which are no longer published by the Census
> Bureau, but in any event serve a very small minority of the population
> (probably on the order of .1% or less). Although every attempt has
> been made to filter them out, this data set may contain up to .5%
> false positives, that is, ZIP codes that do not exist or are no longer
> in use but are included due to erroneous data sources.

The included `valid_city` and `valid_zip` vectors are sorted, unique
columns from the `zipcodes` data frame.

``` r
sample_frac(zipcodes)
#> # A tibble: 44,336 × 3
#>    city       state zip  
#>    <chr>      <chr> <chr>
#>  1 SAN JUAN   PR    00914
#>  2 BRANCHDALE PA    17923
#>  3 ATHENS     IL    62613
#>  4 ALBANY     GA    31706
#>  5 HULL       IA    51239
#>  6 CHICAGO    IL    60640
#>  7 WASHINGTON DC    20380
#>  8 LA HONDA   CA    94020
#>  9 POMONA     CA    91767
#> 10 OSHKOSH    NE    69190
#> # … with 44,326 more rows
```

### `usps_*` and `valid_*`

The `usps_*` data frames were scraped from the official United States
Postal Service (USPS) [Postal Addressing
Standards](https://pe.usps.com/text/pub28/28apc_002.htm). These data
frames are designed to work with the abbreviation functionality of
`normal_address()` and `normal_city()` to replace common abbreviations
with their full equivalent.

`usps_city` is a curated subset of `usps_state`, whose full version
appear at least once in the `valid_city` vector from `zipcodes`. The
`valid_state` and `valid_name` vectors contain the columns from
`usps_state` and include territories not found in R’s build in
`state.abb` and `state.name` vectors.

``` r
sample_n(usps_street, 3)
#> # A tibble: 3 × 2
#>   full   abb  
#>   <chr>  <chr>
#> 1 PLAIN  PLN  
#> 2 COVE   CV   
#> 3 ARCADE ARC
sample_n(usps_state, 3)
#> # A tibble: 3 × 2
#>   full      abb  
#>   <chr>     <chr>
#> 1 UTAH      UT   
#> 2 ALABAMA   AL   
#> 3 WISCONSIN WI
setdiff(valid_state, state.abb)
#>  [1] "AS" "AA" "AE" "AP" "DC" "FM" "GU" "MH" "MP" "PW" "PR" "VI"
```

------------------------------------------------------------------------

The campfin project is released with a [Contributor Code of
Conduct](https://www.contributor-covenant.org/version/2/0/code_of_conduct.html).
By contributing, you agree to abide by its terms.

<!-- refs: start -->
<!-- refs: end -->
