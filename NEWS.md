# campfin (development version)

# campfin 1.0.4

* `file_encoding()` now fails on Solaris and tests are skipped.
    * The use of the command line `file` tool via `system2()` returns results
    on Solaris OS that are not the same as on a Unix-alike or Windows system
    and thus the results are unreliable for consistent replication.

# campfin 1.0.2

* Tests and examples run more confidently.

# campfin 1.0.0

* Improve the handling of internal data and vignette.
* Create `read_names()`.

# campfin 0.2.4

* `flag_dupes()` has an argument to flag both duplicates.
* Add encoding check to `use_diary().`
* Improve documentation examples.

# campfin 0.2.3

* `flag_dupes()` now also calls `duplicated(fromLast = TRUE)` to capture all.
* Separate address `[:digit:]` from `[:alpha:]` with space.
* Create `prop_distinct()`, `which_in()` and `which_out()`.
* Comment out examples for fetching and checking cities.
* Use 'fs' bytes and paths.
* Create `use_diary()` with template diary.
* Remove `print_all()`

# campfin 0.2.1

* The `normal_address()` now calls `abbrev_full()` instead of `expand_abbrev()`.
* Reverse order of columns in `usps_street`, `usps_state`, and `usps_city`.
* Update to version 2.0 of the `CODE_OF_CONDUCT.md` and URL.

# campfin 0.1.1

* Added a `NEWS.md` file to track changes to the package.
* Deprecated `glimpse_fun()` for more simple `col_stats()`.
