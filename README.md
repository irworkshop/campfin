
<!-- README.md is generated from README.Rmd. Please edit that file -->

# campfin <img src="man/figures/logo.png" align="right" width="120" />

[![CRAN\_Status\_Badge](http://www.r-pkg.org/badges/version/campfin)](https://cran.r-project.org/package=campfin)

## Overview

The `campfin` package was created to facilitate the work being done on
the [The Accountability Project](https://www.publicaccountability.org/),
a tool created by [The Investigative Reporting
Workshop](https://investigativereportingworkshop.org/) in Washington,
DC. The Accountability Project curates, cleans, and indexes public data
to give journalists, researchers and others a simple way to search
across otherwise siloed records.

The data focuses on people, organizations and locations. This package
was created specifically to help with state-level **camp**aign
**fin**ance data, although the tools included are useful in general
database exploration and normalization.

## Installation

The package is not yet on [CRAN](https://cran.r-project.org/) and must
be installed from GitHub.

``` r
if(!requireNamespace("remotes")) install.packages("remotes")
remotes::install_github("irworkshop/campfin")
```

Or you can install the development branch to get the latest features.

``` r
remotes::install_github("irworkshop/campfin", ref = "develop")
```

## Normalize

The package was originally built to normalize geographic data using the
`normal_*()` functions, which take the messy self-reported geographic
data of a contributor, vendor, candidate, or committee and return
[normalized text](https://en.wikipedia.org/wiki/Text_normalization) that
is more searchable. They are largely wrappers around the
[`stringr`](https://github.com/tidyverse/stringr) package, and can call
other sub-functions to streamline normalization.

  - `normal_address()` takes a *street* address and reduces
    inconsistencies.
  - `normal_zip()` takes [ZIP
    Codes](https://cran.r-project.org/web/packages/zipcode/) and aims to
    return a valid 5-digit code.
  - `normal_state()` takes US states and returns a [2 digit
    abbreviation](https://en.wikipedia.org/wiki/List_of_U.S._state_abbreviations).
  - `normal_city()` takes cities and reduces inconsistencies.
  - `normal_phone()` consistently fornats US telephone numbers.

Please see the vignette on normalization for an example of how these
functions are used to fix a wide variety of string inconsistencies and
make campaign finance data more consistent. In general, these functions
fix the following inconsistencies:

  - Capitalize with `str_to_upper()`
  - Replace hyphens and underscores with `str_replace()`
  - Remove remaining punctuation with `str_remove()`
  - Remove either numbers or letters (depending on data) with
    `str_remove()`
  - Remove excess white space with `str_trim()` and `str_squish()`
  - Replace abbreviations with `expand_abbrev()` (and
    `str_replace_all()`)
  - Remove invalid values with `na_out()` (and `str_which()`)

## Data

``` r
library(campfin)
library(zipcode)
library(tidyverse)
```

The campfin package contains a number of built in data frames and
strings used to help wrangle campaign finance data.

``` r
data(package = "campfin")$results[, "Item"]
#>  [1] "invalid_city" "rx_phone"     "rx_state"     "rx_zip"       "usps_city"    "usps_state"  
#>  [7] "usps_street"  "valid_city"   "valid_name"   "valid_state"  "valid_zip"    "vt_contribs" 
#> [13] "zipcodes"
```

The `/data-raw` directory contains the code used to create the objects.

### `zipcodes`

The `zipcodes` (plural) data frame is a normalized version of the
`zipcode` (singular) data frame from the
[`zipcode`](https://cran.r-project.org/web/packages/zipcode/) R package,
which itself is a version of the [CivicSpace US ZIP Code
Database](https://boutell.com/zipcodes/):

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
columns from the `zipcodes` data frame (although `valid_city` is being
updated to include more common neighborhoods and census-designated
places)

``` r
# zipcode version
data("zipcode")
sample_n(zipcode, 5)
#>     zip       city state latitude longitude
#> 1 17238   Needmore    PA 39.84793 -78.12821
#> 2 72760 Saint Paul    AR 35.82635 -93.73715
#> 3 38136    Memphis    TN 35.20174 -89.97154
#> 4 61741    Forrest    IL 40.75697 -88.40479
#> 5 37658    Hampton    TN 36.26916 -82.17558
class(zipcode)
#> [1] "data.frame"

# campfin version
sample_n(zipcodes, 5)
#> # A tibble: 5 x 3
#>   city            state zip  
#>   <chr>           <chr> <chr>
#> 1 CLANTON         AL    35045
#> 2 LAKE GENEVA     WI    53147
#> 3 NEWBERRY        FL    32699
#> 4 AJO             AZ    85321
#> 5 EAST WILLIAMSON NY    14449
class(zipcodes)
#> [1] "tbl_df"     "tbl"        "data.frame"
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
sample_n(usps_street, 5)
#> # A tibble: 5 x 2
#>   abb   full  
#>   <chr> <chr> 
#> 1 VW    VIEW  
#> 2 DIV   DIVIDE
#> 3 TRL   TRAIL 
#> 4 SPG   SPRING
#> 5 GRN   GREEN
sample_n(usps_city, 5)
#> # A tibble: 5 x 2
#>   abb   full   
#>   <chr> <chr>  
#> 1 E     EAST   
#> 2 GRDEN GARDEN 
#> 3 MDW   MEADOWS
#> 4 LODG  LODGE  
#> 5 VLG   VILLAGE
sample_n(usps_state, 5)
#> # A tibble: 5 x 2
#>   abb   full          
#>   <chr> <chr>         
#> 1 NV    NEVADA        
#> 2 MA    MASSACHUSETTS 
#> 3 GA    GEORGIA       
#> 4 VI    VIRGIN ISLANDS
#> 5 CT    CONNECTICUT
setdiff(valid_state, state.abb)
#>  [1] "AS" "AA" "AE" "AP" "DC" "FM" "GU" "MH" "MP" "PW" "PR" "VI"
setdiff(str_to_title(valid_name), state.name)
#>  [1] "American Samoa"                 "Armed Forces Americas"         
#>  [3] "Armed Forces Europe"            "Armed Forces Pacific"          
#>  [5] "District Of Columbia"           "Federated States Of Micronesia"
#>  [7] "Guam"                           "Marshall Islands"              
#>  [9] "Northern Mariana Islands"       "Palau"                         
#> [11] "Puerto Rico"                    "Virgin Islands"
```

### Other

The `invalid_city` vector contains, appropriately, common invalid city
names, which can be passed to `normal_city()`.

``` r
sample(invalid_city, 5)
#> [1] "NULL"         "INFO PENDING" "IR"           "ANYWHERE"     "UNKNOWN CITY"
```

The `rx_zip` and `rx_state` character strings are useful regular
expressions for extracting geographic data from a single string address,
data which can then be passed to `normal_zip()` and `normal_state()`.

``` r
print(rx_zip)
#> [1] "\\d{5}(?:-\\d{4})?$"
print(rx_state)
#> [:alpha:]+(?=\s+\d{5}(?:-\d{4})?$)
```

``` r
white_house <- "1600 Pennsylvania Ave NW, Washington, DC 20500-0003"
str_extract(white_house, pattern = rx_zip)
#> [1] "20500-0003"
str_extract(white_house, pattern = rx_state)
#> [1] "DC"
```

The `rx_phone` character string is another useful regular expression to
match US telephone numbers in a wide variety of common formats.

``` r
c(
  "867-5309",
  "2027621401",
  "(202) 456-1111",
  "1-800-273-8255",
  "800.288.8372",
  "(802) 555-1234 x567",
  "1-916-CALL-TUR",
  "Telephone"
) %>% 
  enframe(NULL) %>% 
  mutate(match = str_detect(value, rx_phone))
#> # A tibble: 8 x 2
#>   value               match
#>   <chr>               <lgl>
#> 1 867-5309            TRUE 
#> 2 2027621401          TRUE 
#> 3 (202) 456-1111      TRUE 
#> 4 1-800-273-8255      TRUE 
#> 5 800.288.8372        TRUE 
#> 6 (802) 555-1234 x567 TRUE 
#> 7 1-916-CALL-TUR      FALSE
#> 8 Telephone           FALSE
```

The `vt_contribs` data frame contains example campaign contribution data
from a fictional election in Vermont. The data is used in the
normalization vignette.

``` r
print(vt_contribs)
#> # A tibble: 10 x 10
#>    id    cand        date       amount first last    address          city         state  zip      
#>    <chr> <chr>       <chr>       <dbl> <chr> <chr>   <chr>            <chr>        <chr>  <chr>    
#>  1 01    Bill Miller 09/02/2019     10 Lisa  Miller  4 Sheffield Sq … Sheffield    VT     05866    
#>  2 02    Bill Miller 09/03/2009     20 Deb   Brown   Requested        Requested    RE     00000    
#>  3 03    Jake White  09/04/2019     25 <NA>  <NA>    "p.o. box 567  … Midlebury    Vermo… 05753-05…
#>  4 04    Jake White  09/05/2019    100 Josh  Jones   sugarhouse road  E Corinth    VT     5076     
#>  5 05    Bill Miller 09/02/2019     10 Lisa  Miller  4 Sheffield Sq … Sheffield    VT     05866    
#>  6 06    Jake White  09/06/2019   1000 Bob   Taylor  55 thisplace ave young ameri… mn     55555    
#>  7 07    Jake White  09/07/2019   -600 Alex  Johnson 11 Liberty ST    Bristol, VT  VT     05443-12…
#>  8 08    Beth Walsh  09/08/2019      0 Ruth  Smith   2 Burlington Sq  Brulington   VT     05401    
#>  9 09    Beth Walsh  09/09/2019     69 Joe   Garcia  770   5th-st-nw  Washington   DC     20001-26…
#> 10 10    Beth Walsh  09/11/2019    222 Dave  Wilson  XXXXXXXXXXXXXXX… SA           Texas  78202
```
