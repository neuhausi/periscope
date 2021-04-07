## Comments from Maintainer

* LazyData removed from Description to fix Note on CRAN check page

* Bugfix for situation where the user wants to generate an app but does not have shinydashboardPlus installed and does not need a right sidebar (which requires sdp)

* There may be a NOTE due to the short time between submissions, this is an important bugfix release and I kindly ask for your exception to allow this release.

---  
    
## Test Environments
    

RStudio Server Pro (Ubuntu 18.04.2)  

* R 3.6.3
* R 4.0.4

Travis-CI (Ubuntu 16.04.6)

* R 3.6.3
* R 4.0.2
* R devel (2021-03-29 r80130)

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

