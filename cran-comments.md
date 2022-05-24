## Test environments

* local: ubuntu-release
* [github-actions](https://github.com/irworkshop/campfin/actions): 
  * windows-release
  * macos-release
  * ubuntu-release
  * ubuntu-devel
* r-hub:
  * [windows-x86_64-devel](https://builder.r-hub.io/status/campfin_1.0.8.tar.gz-ece1faf0093843d8b40b44a913e39a78)
  * [ubuntu-gcc-release](https://builder.r-hub.io/status/campfin_1.0.8.tar.gz-8df72fb330c146b4a5c6d6ae450f8427)
  * [fedora-clang-devel](https://builder.r-hub.io/status/campfin_1.0.8.tar.gz-1e71c4f5f39a411cbe08a106675b27d5)
  * **[solaris-x86-patched](https://builder.r-hub.io/status/campfin_1.0.8.tar.gz-96c11236b4354d03b1205e4cbc6c5022)**
* win-builder: 
  * [windows-x86_64-devel](https://win-builder.r-project.org/m37JFL0VAkA2/)

## R CMD check results

0 errors | 0 warnings | 0 note

## Comments

* Updated re-directed URLs with status 301.
* Remove `if()` conditions comparing `class()` to string, used `inherits()`.
