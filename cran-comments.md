## Comments from Maintainer

* Merging test updates from Carson Sievert (RStudio) to resolve minor issues with expectations of UI layout properties that will cause failing tests in Shiny 1.6 which is due to be released next week.

* We were asked by Carson to make this update ASAP, rather than waiting, so there is a NOTE about the time since last submission (5d) - this is necessary as we were just notified a few days ago of the need for this update.

---  
    
## Test Environments
    

RStudio Server Pro (Ubuntu 18.04.2)  

* R 3.6.3
* R 4.0.3

Travis-CI (Ubuntu 16.04.6)

* R 3.6.3
* R 4.0.2
* R devel (2021-01-09 r79815)

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

