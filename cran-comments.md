## Comments from Maintainer

* 0.6.1 - our host had issues and we needed a few redirect fixes.  Solved!  Apologies.

* Updated the package to handle both the old and new releases of shinydashboardPlus
* Updated tests, fixed a few minor bugs

---  
    
## Test Environments
    

RStudio Server Pro (Ubuntu 18.04.2)  

* R 3.6.3
* R 4.0.4

Travis-CI (Ubuntu 16.04.6)

* R 3.6.3
* R 4.0.2
* R devel (2021-03-11 r80086)

WinBuilder

* devtools::check_win_devel()  
* devtools::check_win_release()  

RHub

* devtools::check_rhub(interactive = F)

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

