## Comments from Maintainer

This is the initial release for this package to CRAN, and due to this there is a package build NOTE on rhub and win-builder builds about this being a new package release.

Update the package per initial crann comments:

* single-quoted proper names in Title & Description
* added executables to the man (Rd) documentation
* updated tests vignettes and examples to use tempdir() when creating new applications and running tests

---  
    
## Test Environments
    

RStudio Server Pro (ubuntu 16.04.5)  

* R 3.3.3  
* R 3.4.4  
* R 3.5.2  

Travis-CI (ubuntu 14.04.5)

* R 3.4.4
* R 3.5.2
* R devel - 2019-02-22 r76149

win-builder  

  * oldrelease
  * release
  * devel

devtools::check_rhub()  

  * Ubuntu Linux 16.04 LTS, R-release
  * Windows Server 2008 R2 SP1, R-devel, 32/64 bit
  * Fedora Linux, R-devel, clang, gfortran

---  
    
## R CMD check results
    
    
```
devtools::check()  

0 errors ✔ | 0 warnings ✔ | 0 notes ✔
```

---  
    
## Reverse dependencies
    
**NONE**
    
```
pdb <- available.packages()
tools::package_dependencies(packages = c('periscope'),
                            db = pdb, reverse = TRUE)

$periscope  
NULL
```
