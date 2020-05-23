## Comments from Maintainer

This is a very minor correction to our just-accepted 0.4.10 release - we missed a file change in the merge for the release, apologies in advance.

Fixed tests based on input from Barret Schloerke in preparation for the next release of shiny to CRAN next week.

---  
    
## Test Environments
    

RStudio Server Pro (Ubuntu 18.04.2)  

* R 3.5.3  
* R 3.6.3
* R 4.0.0

Travis-CI (Ubuntu 16.04.6)

* R 3.5.3
* R 3.6.3
* R devel (2020-05-04 r78358)

WinBuilder

* devtools::check_win_devel()  
* devtools::check_win_release()  
* devtools::check_win_oldrelease()  

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

