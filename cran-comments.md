## Comments from Maintainer

Enhancements and added functionality as detailed in News

---  
    
## Test Environments
    

RStudio Server Pro (Ubuntu 18.04.2)  

* R 3.4.4  
* R 3.5.3  
* R 3.6.2

Travis-CI (Ubuntu 16.04.6)

* R 3.5.3
* R 3.6.2
* R devel (2020-02-12 r77798)

WinBuilder

* devtools::check_win_devel()  
* devtools::check_win_release()  
* devtools::check_win_oldrelease()  

RHub

* devtools::check_rhub(interactive = F)  
  * Ubuntu Linux 16.04 LTS, R-release, GCC
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

