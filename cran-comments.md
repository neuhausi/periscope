## Comments from Maintainer

* Right Sidebar Bug fix for ShinyDashboardPlus 2.0 compatibility

* There is a NOTE due to the short time between submissions, this is an important bugfix enabling right-sidebar applications to be generated for ShinyDashboardPlus 2.0 and I kindly ask for your exception to allow this release.

---  
    
## Test Environments
    

RStudio Server Pro (Ubuntu 18.04.2)  

* R 3.6.3
* R 4.0.4

Travis-CI (Ubuntu 16.04.6)

* R 3.6.3
* R 4.0.2
* R devel (2021-03-17 r80092)

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

