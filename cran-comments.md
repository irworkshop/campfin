## Test environments

* local: linux-gnu-3.6.2
* travis: 3.1, 3.2, 3.3, oldrel, release, devel
* r-hub: windows-x86_64-devel, ubuntu-gcc-release, fedora-clang-devel
* win-builder: windows-x86_64-devel

## R CMD check results

0 errors | 0 warnings | 1 note

* This is a new release.

## Resubmission

* Skip the `check_city()` and `fetch_city()` tests without key or on CRAN.
* Delete all of the temporary files _between_ `all_new_files()` tests.

## Previous Submission

* Schuyler Erle added as copyright holder in DESCRIPTION.
* The string in the `col_date_usa()` example is not a file path and should be
just a string, not a file.
* Package passes all Windows builds via `devtools::check_win_*()`.
