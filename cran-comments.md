## Test environments

* local: ubuntu-release
* [github-actions](https://github.com/irworkshop/campfin/actions): 
  * windows-release
  * macos-release
  * ubuntu-release
  * ubuntu-devel
* r-hub:
  * [windows-x86_64-devel](https://builder.r-hub.io/status/campfin_1.0.2.tar.gz-34604028283e49e19c24f990284406ab)
  * [ubuntu-gcc-release](https://builder.r-hub.io/status/campfin_1.0.2.tar.gz-c4767d2f041d4487bbf91ce561aefd40)
  * [fedora-clang-devel](https://builder.r-hub.io/status/campfin_1.0.2.tar.gz-e8861979d5134cd6bbb935f811805ef8)
  * **[solaris-x86-patched](https://builder.r-hub.io/status/campfin_1.0.2.tar.gz-a8be7190484f40608f75218e478cfdda)**
* win-builder: 
  * [windows-x86_64-devel](https://win-builder.r-project.org/4qDy2Slvc9QR)

## R CMD check results

0 errors | 0 warnings | 0 note

## Resubmission

* Add `skip_on_os("solaris")` to `file_encoding()` tests due to unreliability.
* Add `tryCatch()` to `file_encoding()` and fail on Solaris systems.

## Previous Submission

* Skip the `check_city()` and `fetch_city()` tests without key or on CRAN.
* Delete all of the temporary files _between_ `all_new_files()`, etc tests.
* Schuyler Erle added as copyright holder in DESCRIPTION.
* The string in the `col_date_usa()` example is not a file path, just a string.
* Package passes all Windows builds via `devtools::check_win_*()`.
