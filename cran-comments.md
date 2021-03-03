## Test environments

* local: ubuntu-release
* [github-actions](https://github.com/irworkshop/campfin/actions): 
  * windows-release
  * macos-release
  * ubuntu-release
  * ubuntu-devel
* r-hub:
  * [windows-x86_64-devel](https://builder.r-hub.io/status/campfin_1.0.6.tar.gz-8ddc43ee8c3248dba2175dbb7ce13b64)
  * [ubuntu-gcc-release](https://builder.r-hub.io/status/campfin_1.0.6.tar.gz-c86a250c59324e4999c7803bfe81e4ca)
  * [fedora-clang-devel](https://builder.r-hub.io/status/campfin_1.0.6.tar.gz-0ecee02463d440908fed9294383c0536)
  * **[solaris-x86-patched](https://builder.r-hub.io/status/campfin_1.0.6.tar.gz-17450e6a752c4ac28463ed7fb47ec134)**
* win-builder: 
  * [windows-x86_64-devel](https://win-builder.r-project.org/m37JFL0VAkA2/)

## R CMD check results

0 errors | 0 warnings | 0 note

## Previous Submission (1.0.4)

* Remove `file_encoding()` example for OS unreliability.
* Add `skip_on_os("solaris")` to `file_encoding()` tests due to unreliability.
* Add `tryCatch()` to `file_encoding()` and fail on Solaris systems.
