## Comments from Maintainer

Added functionality, testing and resolved the use of the archived logging package.

---  
    
## Test Environments
    

RStudio Server Pro (Ubuntu 18.04.2)  

* R 3.5.3  
* R 3.6.3
* R 4.0.1

Travis-CI (Ubuntu 16.04.6)

* R 3.6.3
* R 4.0.0
* R devel (2020-07-03 r78773)

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

