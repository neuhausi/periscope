## Comments from Maintainer

Resubmission Comments:
* permanent redirect for CircleCI was not caught, corrected the URL in the readme

Original Comments:
Minor bugfix release to update icons, templated examples

---  
    
## Test Environments
    

RStudio Server Pro (Ubuntu 18.04.2)  

* R 3.6.3
* R 4.0.5
* R 4.1.1

CircleCI

* R 4.0.5
* R 4.1.2

WinBuilder

* devtools::check_win_devel()  
* devtools::check_win_release()  

RHub

* devtools::check_rhub(interactive = F, env_vars = c("R_CHECK_FORCE_SUGGESTS" = "false"))

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
tools::package_dependencies(packages = c('periscope'),
                            db       = available.packages(), 
                            reverse  = TRUE)

$periscope  
character(0)
```

