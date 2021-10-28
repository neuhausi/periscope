## Comments from Maintainer

Resubmission comments:
Updated travis link in Readme file

Initial comments: 
This is a major functionality update including changing the shiny module paradigm, supporting additional DT options in downloadableTables and updating the styling paradigm to allow more flexibility when customizing periscope applications.  This release is compatible with apps created with the 0.x version of the package and
documentation including the sample applications, examples, vignettes, tests, etc. were also updated.

---  
    
## Test Environments
    

RStudio Server Pro (Ubuntu 18.04.2)  

* R 3.6.3
* R 4.0.5
* R 4.1.1

Travis-CI (Ubuntu 16.04.6)

* R 3.6.3
* R 4.0.2
* R devel (2021-09-29 r80990)

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

