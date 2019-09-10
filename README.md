
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
pacman::p_load(tidyverse, knitr, stringdist, zipcode)
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
  - `normal_city()` takes cities and reduces inconsistencies

The `vt_contribs` built-in example data set contains many of the
problems these functions are designed to help with.

``` r
vt_contribs
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

What are some of the problems we can see in this data?

  - The `date` column is not parsed as an R date.
  - There is one negative `amount` value and another that’s zero.
  - One record is missing both the contributor’s `first` and `last`
    name.
  - In `address` we see:
      - Inconsisten capitalization,
      - A mix of full and abbreviatied suffixes,
      - Invalid text in the place of `NA`,
      - Uneccesary and inconsistent punctuation,
      - Excess trailing white space,
      - Excess internal white space,
      - Hyphens instead of spaces,
      - Repeating character strings used as `NA`.
  - In `city` we see many of the same problems, plus:
      - Geographic abbreviations,
      - Repeated `state` information,
      - Misspellings,
      - Colloquial city abbreviations.
  - In `state` we see a mix of full and abbreviated state names.
  - In `zip`,
      - Repeated digits used for `NA`
      - Uneccesary and inconsistent
        [ZIP+4](https://en.wikipedia.org/wiki/ZIP_Code#ZIP+4 "zip4")
        usage
      - Leading zeroes [dropped by
        Excel](https://support.office.com/en-us/article/display-numbers-as-postal-codes-61b55c9f-6fe3-4e54-96ca-9e85c38a5a1d "excel")
        or some other program

We can use the `normal_*()` family functions to clean this data into a
much more consitent format. First, we’ll read the file with
`readr::read_csv()`. Most American campaign finance data uses the
mm/dd/yyyy format. We can parse this as a proper R date with the
`col_date_usa` function, which is a shortcut for `readr::col_date(format
= "%m/%d/%Y")`.

``` r
vt <- read_csv(
  file = "data-raw/vt_contribs.csv",
  trim_ws = FALSE,
  col_types = cols(
    amount = col_number(),
    date = col_date_usa()
  )
)
```

Next, we should try to normalize our data as much as possible. We can
use some simple counting functions and built in vectors to check our
progress.

``` r
vt <- vt %>% 
  mutate(
    address = normal_address(
      address = address,
      add_abbs = usps_street,
      na = invalid_city,
      na_rep = TRUE
    ),
    city = normal_city(
      city = city,
      geo_abbs = usps_city,
      st_abbs = "VT",
      na = invalid_city,
      na_rep = TRUE
    ),
    state = normal_state(
      state = state,
      abbreviate = TRUE,
      na_rep = TRUE,
      valid = valid_state
    ),
    zip = normal_zip(
      zip = zip,
      na_rep = TRUE
    )
  )
```

We can see how these functions and our built in data was used to
normalize the geographic contributor data and remove anything that
didn’t present real information. This format is much more explorable
and searchable.

    #> # A tibble: 10 x 10
    #>    id    cand        date       amount first last    address               city         state zip  
    #>    <chr> <chr>       <date>      <dbl> <chr> <chr>   <chr>                 <chr>        <chr> <chr>
    #>  1 01    Bill Miller 2019-09-02     10 Lisa  Miller  4 SHEFFIELD SQUARE R… SHEFFIELD    VT    05866
    #>  2 02    Bill Miller 2009-09-03     20 Deb   Brown   <NA>                  <NA>         <NA>  <NA> 
    #>  3 03    Jake White  2019-09-04     25 <NA>  <NA>    PO BOX 567            MIDLEBURY    VT    05753
    #>  4 04    Jake White  2019-09-05    100 Josh  Jones   SUGARHOUSE ROAD       EAST CORINTH VT    05076
    #>  5 05    Bill Miller 2019-09-02     10 Lisa  Miller  4 SHEFFIELD SQUARE R… SHEFFIELD    VT    05866
    #>  6 06    Jake White  2019-09-06   1000 Bob   Taylor  55 THISPLACE AVENUE   YOUNG AMERI… MN    55555
    #>  7 07    Jake White  2019-09-07   -600 Alex  Johnson 11 LIBERTY STREET     BRISTOL      VT    05443
    #>  8 08    Beth Walsh  2019-09-08      0 Ruth  Smith   2 BURLINGTON SQUARE   BRULINGTON   VT    05401
    #>  9 09    Beth Walsh  2019-09-09     69 Joe   Garcia  770 5TH STREET NORTH… WASHINGTON   DC    20001
    #> 10 10    Beth Walsh  2019-09-11    222 Dave  Wilson  <NA>                  SA           TX    78202

However, we can see now every problem has been solved. Most troublesome
are the city names.

    #> # A tibble: 3 x 5
    #>   id    city       state zip   valid
    #>   <chr> <chr>      <chr> <chr> <lgl>
    #> 1 03    MIDLEBURY  VT    05753 FALSE
    #> 2 08    BRULINGTON VT    05401 FALSE
    #> 3 10    SA         TX    78202 FALSE

There is some built in data and a regular process we use to fix as much
of these problems as possible. Checking against the *expected* city for
a given ZIP code is a fast, easy, and confident way to fix incorrect
`city` values. The `is_abbrev()` and `stringdist::stringdist()`
functions are great for this.

``` r
vt <- vt %>%
  rename(city_raw = city) %>% 
  left_join(zipcodes) %>% 
  rename(city_match = city) %>% 
  mutate(
    match_dist = stringdist(city_raw, city_match),
    match_abb = is_abbrev(city_raw, city_match),
    city = if_else(match_abb | match_dist == 1, city_match, city_raw)
  ) %>% 
  select(-city_raw, -city_match, -match_dist, -match_abb)
#> Joining, by = c("state", "zip")
```

    #> # A tibble: 9 x 5
    #>   id    state zip   city          valid
    #>   <chr> <chr> <chr> <chr>         <lgl>
    #> 1 01    VT    05866 SHEFFIELD     TRUE 
    #> 2 03    VT    05753 MIDDLEBURY    TRUE 
    #> 3 04    VT    05076 EAST CORINTH  TRUE 
    #> 4 05    VT    05866 SHEFFIELD     TRUE 
    #> 5 06    MN    55555 YOUNG AMERICA TRUE 
    #> 6 07    VT    05443 BRISTOL       TRUE 
    #> 7 08    VT    05401 BURLINGTON    TRUE 
    #> 8 09    DC    20001 WASHINGTON    TRUE 
    #> 9 10    TX    78202 SAN ANTONIO   TRUE

Once our data is as normal as we can confidently make it, we can begind
to explore. First, we’ll explore the data for missing values with
`flag_na`, which takes a
[tidyselct](https://github.com/r-lib/tidyselect "tidyselect") number of
key columns to check (or something like `dplyr::everything()`).

``` r
flag_na(vt, last)
#> # A tibble: 10 x 11
#>    id    cand      date       amount first last    address           state zip   city       na_flag
#>    <chr> <chr>     <date>      <dbl> <chr> <chr>   <chr>             <chr> <chr> <chr>      <lgl>  
#>  1 01    Bill Mil… 2019-09-02     10 Lisa  Miller  4 SHEFFIELD SQUA… VT    05866 SHEFFIELD  FALSE  
#>  2 02    Bill Mil… 2009-09-03     20 Deb   Brown   <NA>              <NA>  <NA>  <NA>       FALSE  
#>  3 03    Jake Whi… 2019-09-04     25 <NA>  <NA>    PO BOX 567        VT    05753 MIDDLEBURY TRUE   
#>  4 04    Jake Whi… 2019-09-05    100 Josh  Jones   SUGARHOUSE ROAD   VT    05076 EAST CORI… FALSE  
#>  5 05    Bill Mil… 2019-09-02     10 Lisa  Miller  4 SHEFFIELD SQUA… VT    05866 SHEFFIELD  FALSE  
#>  6 06    Jake Whi… 2019-09-06   1000 Bob   Taylor  55 THISPLACE AVE… MN    55555 YOUNG AME… FALSE  
#>  7 07    Jake Whi… 2019-09-07   -600 Alex  Johnson 11 LIBERTY STREET VT    05443 BRISTOL    FALSE  
#>  8 08    Beth Wal… 2019-09-08      0 Ruth  Smith   2 BURLINGTON SQU… VT    05401 BURLINGTON FALSE  
#>  9 09    Beth Wal… 2019-09-09     69 Joe   Garcia  770 5TH STREET N… DC    20001 WASHINGTON FALSE  
#> 10 10    Beth Wal… 2019-09-11    222 Dave  Wilson  <NA>              TX    78202 SAN ANTON… FALSE
```

Next, we’ll want to check for duplicate rows using `flag_dupes`, which
takes the same kind of arguments. Here, we can ignore the supposedly
unique `id` variable. It’s possible for a person to make the same
contribution on the same date, but we should flag them nonetheless.

``` r
flag_dupes(vt, -id)
#> # A tibble: 10 x 11
#>    id    cand      date       amount first last    address          state zip   city      dupe_flag
#>    <chr> <chr>     <date>      <dbl> <chr> <chr>   <chr>            <chr> <chr> <chr>     <lgl>    
#>  1 01    Bill Mil… 2019-09-02     10 Lisa  Miller  4 SHEFFIELD SQU… VT    05866 SHEFFIELD FALSE    
#>  2 02    Bill Mil… 2009-09-03     20 Deb   Brown   <NA>             <NA>  <NA>  <NA>      FALSE    
#>  3 03    Jake Whi… 2019-09-04     25 <NA>  <NA>    PO BOX 567       VT    05753 MIDDLEBU… FALSE    
#>  4 04    Jake Whi… 2019-09-05    100 Josh  Jones   SUGARHOUSE ROAD  VT    05076 EAST COR… FALSE    
#>  5 05    Bill Mil… 2019-09-02     10 Lisa  Miller  4 SHEFFIELD SQU… VT    05866 SHEFFIELD TRUE     
#>  6 06    Jake Whi… 2019-09-06   1000 Bob   Taylor  55 THISPLACE AV… MN    55555 YOUNG AM… FALSE    
#>  7 07    Jake Whi… 2019-09-07   -600 Alex  Johnson 11 LIBERTY STRE… VT    05443 BRISTOL   FALSE    
#>  8 08    Beth Wal… 2019-09-08      0 Ruth  Smith   2 BURLINGTON SQ… VT    05401 BURLINGT… FALSE    
#>  9 09    Beth Wal… 2019-09-09     69 Joe   Garcia  770 5TH STREET … DC    20001 WASHINGT… FALSE    
#> 10 10    Beth Wal… 2019-09-11    222 Dave  Wilson  <NA>             TX    78202 SAN ANTO… FALSE
```

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
#> vt_contribs
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
#>     zip      city state latitude  longitude
#> 1 13636 Ellisburg    NY 43.75965  -76.15251
#> 2 04079 Harpswell    ME 43.79740  -69.95217
#> 3 88553   El Paso    TX 31.69484 -106.29999
#> 4 89028  Laughlin    NV 35.01398 -114.64470
#> 5 88513   El Paso    TX 31.69484 -106.29999
class(zipcode)
#> [1] "data.frame"

# campfin version
sample_n(zipcodes, 5)
#> # A tibble: 5 x 3
#>   city        state zip  
#>   <chr>       <chr> <chr>
#> 1 DEPEW       NY    14043
#> 2 PROBERTA    CA    96078
#> 3 UNIONVILLE  NY    10988
#> 4 HONEY CREEK WI    53138
#> 5 SAND FORK   WV    26430
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
#> [1] "INFO REQUESTED"        "NONE GIVE"             "XXXXX"                 "REQUESTED INFORMATION"
#> [5] "VIRTUAL"
```

The `usps_*` data frames can be used with `normal_*()` to expand the
[official USPS
abbreviations](https://pe.usps.com/text/pub28/28apc_002.htm).

``` r
sample_n(usps_city, 5)
#> # A tibble: 5 x 2
#>   abb    full     
#>   <chr>  <chr>    
#> 1 SUMITT SUMMIT   
#> 2 SHLS   SHOALS   
#> 3 LODG   LODGE    
#> 4 DVD    DIVIDE   
#> 5 SE     SOUTHEAST
sample_n(usps_state, 5)
#> # A tibble: 5 x 2
#>   abb   full       
#>   <chr> <chr>      
#> 1 KY    KENTUCKY   
#> 2 UT    UTAH       
#> 3 ME    MAINE      
#> 4 VA    VIRGINIA   
#> 5 MS    MISSISSIPPI
sample_n(usps_street, 5)
#> # A tibble: 5 x 2
#>   abb     full      
#>   <chr>   <chr>     
#> 1 SHL     SHOAL     
#> 2 BOUL    BOULEVARD 
#> 3 EXPRESS EXPRESSWAY
#> 4 UPPR    UPPER     
#> 5 HNGR    HANGER
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
