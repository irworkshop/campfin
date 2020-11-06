## Test environments

* local: ubuntu-release
* github-actions: windows-release, macos-release, ubuntu-release, ubuntu-devel
* r-hub: windows-x86_64-devel, ubuntu-gcc-release, fedora-clang-devel
* win-builder: windows-x86_64-devel

## R CMD check results

0 errors | 0 warnings | 0 notes

## Resubmission

* Skip the `check_city()` and `fetch_city()` tests without key or on CRAN.
* Delete all of the temporary files _between_ `all_new_files()` tests.

## Previous Submission

* Schuyler Erle added as copyright holder in DESCRIPTION.
* The string in the `col_date_usa()` example is not a file path, just a string.
* Package passes all Windows builds via `devtools::check_win_*()`.
