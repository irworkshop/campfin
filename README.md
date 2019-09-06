
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
if (!require("pacman")) install.packages("pacman")
#> Loading required package: pacman
pacman::p_load_current_gh("kiernann/campfin")
pacman::p_load(tidyverse, knitr, zipcode)
```

## Normalize

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

In this example, we can see how the `normal_*()` function work with the
built in data to turn messy data into a single normalized format.

| address              | city         | state     | zip        |
| :------------------- | :----------- | :-------- | :--------- |
| 744 Cape Cod Rd.     | Stowe, VT    | VT        | 05672-5563 |
| EVERYWHERE           | Morrisville  | REQUESTED | N/A        |
| 149-church-st p-o-14 | Burlington   | Vermont   | 05401      |
| 51 depot square      | st johnsbury | vt        | 5819       |
| XXXXXXX              | UNKNOWN      | DC        | 00000      |

``` r
vt <- vt %>% mutate(
  address = normal_address(
    address = address,
    # expand street abbs
    add_abbs = usps_street,
    # remove invalid strings
    na = invalid_city,
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
    na = invalid_city,
    na_rep = TRUE
  ),
  state = normal_state(
    state = state,
    abbreviate = TRUE,
    # remove all not in geo
    valid = valid_state
  ),
  zip = normal_zip(
    zip = zip,
    na = invalid_city,
    na_rep = TRUE
  )
)
```

| address                 | city            | state | zip   |
| :---------------------- | :-------------- | :---- | :---- |
| 744 CAPE COD ROAD       | STOWE           | VT    | 05672 |
|                         | MORRISVILLE     |       |       |
| 149 CHURCH STREET PO 14 | BURLINGTON      | VT    | 05401 |
| 51 DEPOT SQUARE         | SAINT JOHNSBURY | VT    | 05819 |
|                         |                 | DC    |       |

## Data

The campfin package contains a number of built in data frames and
strings used to help wrangle campaign finance data.

``` r
cat(data(package = "campfin")$results[, "Item"], sep = "\n")
#> invalid_city
#> rx_state
#> rx_zip
#> usps_city
#> usps_state
#> usps_street
#> valid_city
#> valid_name
#> valid_state
#> valid_zip
#> zipcodes
```

The `geo` [tibble](https://tibble.tidyverse.org/ "tibble") is a
normalized version of the `zipcodes` data frame from the
[`zipcodes`](https://cran.r-project.org/web/packages/zipcode/ "zip_pkg")
R package, which itself is a version of the [CivicSpace US ZIP Code
Database](https://boutell.com/zipcodes/ "civic_space").

The `valid_city`, `valid_state`, and `valid_zip` are the unique, sorted
columns of thr `geo` data frame.

``` r
# zipcode version
data("zipcode")
sample_n(zipcode, 5)
#>     zip          city state latitude  longitude
#> 1 44168        Dalton    OH 40.80066  -81.69968
#> 2 40216    Louisville    KY 38.18889  -85.83137
#> 3 05825      Coventry    VT 44.86335  -72.26649
#> 4 92837     Fullerton    CA 33.64030 -117.76944
#> 5 48230 Grosse Pointe    MI 42.38609  -82.92426
class(zipcode)
#> [1] "data.frame"

# campfin version
sample_n(zipcodes, 5)
#> # A tibble: 5 x 3
#>   city             state zip  
#>   <chr>            <chr> <chr>
#> 1 COLERAIN         NC    27924
#> 2 NEW BRITAIN      CT    06052
#> 3 HERNDON          VA    20172
#> 4 GREAT BARRINGTON MA    01230
#> 5 MONTCLAIR        NJ    07043
class(zipcodes)
#> [1] "tbl_df"     "tbl"        "data.frame"

# more US states than the built in state.abb
setdiff(valid_state, state.abb)
#>  [1] "AS" "AA" "AE" "AP" "DC" "FM" "GU" "MH" "MP" "PW" "PR" "VI"
```

The `na_city` vector contains common invalid city names, which can be
passed to `normal_city()`.

``` r
sample(invalid_city, 5)
#> [1] "ONLINE SERVICE"        "SOMEWHERE"             "INFORMATION REQUESTED"
#> [4] "IR"                    "NULL"
```

The `usps_*` data frames can be used with `normal_*()` to expand the
[official USPS
abbreviations](https://pe.usps.com/text/pub28/28apc_002.htm).

``` r
sample_n(usps_city, 5)
#> # A tibble: 5 x 2
#>   abb     full    
#>   <chr>   <chr>   
#> 1 CIR     CIRCLE  
#> 2 FT      FORT    
#> 3 PT      POINT   
#> 4 JUNCTON JUNCTION
#> 5 GRN     GREEN
sample_n(usps_state, 5)
#> # A tibble: 5 x 2
#>   abb   full                    
#>   <chr> <chr>                   
#> 1 SD    SOUTH DAKOTA            
#> 2 TX    TEXAS                   
#> 3 MP    NORTHERN MARIANA ISLANDS
#> 4 AS    AMERICAN SAMOA          
#> 5 IA    IOWA
sample_n(usps_street, 5)
#> # A tibble: 5 x 2
#>   abb    full      
#>   <chr>  <chr>     
#> 1 HLS    HILLS     
#> 2 PKY    PARKWAY   
#> 3 EXPR   EXPRESSWAY
#> 4 GATEWY GATEWAY   
#> 5 JCTION JUNCTION
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
str_extract(white_house, pattern = rx_zip)
#> [1] "20500-0003"
str_extract(white_house, pattern = rx_state)
#> [1] "DC"
```

Work is being done to incorperate regular expressions for addresses and
city names, although the immense possibility for variation makes these
elements harder to generalize.

## Other

There are other functions designed to either facilitate normalization or
help with data loading, exploration, or cleaning. Many are just simple
wrapper functions to speed up data wrangling.

``` r
abbrev_state(full = "VERMONT")
#> [1] "VT"
all_files_new("data/", glob = "*.rda")
#> [1] FALSE
read_csv(file = "x\n11/09/2016", col_types = readr::cols(x = col_date_usa()))
#> # A tibble: 1 x 1
#>   x         
#>   <date>    
#> 1 2016-11-09
count_na(x = storms$ts_diameter)
#> [1] 6528
expand_abbrev(x = "LK SHORE", abb = c("LK" = "LAKE"))
#> [1] "LAKE SHORE"
expand_state(abb = "VT")
#> [1] "VERMONT"
flag_dupes(band_members, everything())
#> # A tibble: 3 x 3
#>   name  band    dupe_flag
#>   <chr> <chr>   <lgl>    
#> 1 Mick  Stones  FALSE    
#> 2 John  Beatles FALSE    
#> 3 Paul  Beatles FALSE
flag_na(band_members, everything())
#> # A tibble: 3 x 3
#>   name  band    na_flag
#>   <chr> <chr>   <lgl>  
#> 1 Mick  Stones  FALSE  
#> 2 John  Beatles FALSE  
#> 3 Paul  Beatles FALSE
glimpse_fun(data = band_members, fun = n_distinct)
#> # A tibble: 2 x 4
#>   col   type      n     p
#>   <chr> <chr> <dbl> <dbl>
#> 1 name  chr       3 1    
#> 2 band  chr       2 0.667
is_abbrev(abb = "VT", full = "Vermont")
#> [1] TRUE
is_binary(x = c("Y", "N"))
#> [1] TRUE
is_even(x = 2012)
#> [1] TRUE
most_common(x = iris$Species, n = 1)
#> [1] "setosa"
na_out(x = c("VT", "CA", "DC"), y = state.abb)
#> [1] "VT" "CA" NA
prop_in(x = c("VT", "CA", "DC"), y = state.abb)
#> [1] 0.6666667
prop_na(x = storms$hu_diameter)
#> [1] 0.6521479
prop_out(x = c("VT", "CA", "DC"), y = state.abb)
#> [1] 0.3333333
url_file_size("https://projects.fivethirtyeight.com/polls-page/senate_polls.csv", format = TRUE)
#> [1] "654 Kb"
"DC" %out% state.abb
#> [1] TRUE
```
