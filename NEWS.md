# campfin 0.2.0

* The `normal_address` and `normal_city` functions now call `abbrev_full()`
instead of `expand_abbrev()`.
* The order of columns in `usps_street`, `usps_state`, and `usps_city` data
frames has been reversed accordingly.

# campfin 0.1.1.9000

* Added a `NEWS.md` file to track changes to the package.
* Deprecated `glimpse_fun()` for more simple `col_stats()`.
