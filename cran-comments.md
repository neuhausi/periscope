## Comments from Maintainer

Updated package documentation per issue instructions

---  
    
## Test Environments
    

RStudio Server Pro (Ubuntu 20.04)
* R 4.0.5
* R 4.2.3
* R 4.3.1

CircleCI

* R 4.0.5
* R latest

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

