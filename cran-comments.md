## Comments from Maintainer

Enhancements, bug fixes and additional functionality as detailed in News

Fixed typo in one url in the README file.  

NOTE: I'm seeing URLs occasionally giving 'could not resolve' notes on urls that are valid, I think it is likely an internet connectivity/slowdown issue where not enough time is given to the request to check the URL.  The https://www.canvasxpress.org url is valid, the certificate matches, and the site is up and accessible.  If you know of a way to deal with this on my end I'm happy to resolve it but will need some additional input on what to set/etc.

---  
    
## Test Environments
    

RStudio Server Pro (Ubuntu 18.04.2)  

* R 3.4.4  
* R 3.5.3  
* R 3.6.2

Travis-CI (Ubuntu 16.04.6)

* R 3.5.3
* R 3.6.2
* R devel (2020-03-13 r77948)

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

