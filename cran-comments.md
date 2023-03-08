## Test environments

* local: ubuntu-release
* [github-actions](https://github.com/irworkshop/campfin/actions): 
  * windows-release
  * macos-release
  * ubuntu-release
  * ubuntu-devel
* r-hub:
  * [windows-x86_64-devel](https://builder.r-hub.io/status/campfin_1.0.9.9000.tar.gz-735aa9b3a1284fcab6d4910ec830a80f)
  * [ubuntu-gcc-release](https://builder.r-hub.io/status/campfin_1.0.9.9000.tar.gz-c158375ca06343f896ea8b7ae695b647)
  * [fedora-clang-devel](https://builder.r-hub.io/status/campfin_1.0.9.9000.tar.gz-575a81a4b1b6475ca863cf4e154ca919)
  * **[solaris-x86-patched](https://builder.r-hub.io/status/campfin_1.0.8.tar.gz-96c11236b4354d03b1205e4cbc6c5022)**
* win-builder: 
  * [windows-x86_64-devel](https://win-builder.r-project.org/m37JFL0VAkA2/)

## R CMD check results

0 errors | 0 warnings | 0 note

## Comments

* Removed the flawed character vector method for the `dplyr::count()` function.
