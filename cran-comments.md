## Comments from Maintainer

Removed unused import httr that causes build notes
Documentation updates

---  
    
## Test Environments
    

RStudio Server Pro (ubuntu 16.04.5)  

* R 3.3.3  
* R 3.4.4  
* R 3.5.3  
* R 3.6.0

Travis-CI (ubuntu 14.04.5)

* R 3.5.3
* R 3.6.0
* R devel (2019-04-29 r76439)

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
character(0)
```
