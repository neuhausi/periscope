## Comments from Maintainer

UPDATE 9/20: removed .git from DESCRIPTION file to resolve note appearing on some servers

Moved openxlsx to suggested and added tests.

There is a NOTE on some servers 'unable to verify current time' while checking for future file timestamps (a devtools check).  There seems to be an issue with the world time server which is not something I can resolve in this package and I prefer not to silence the check in the package.  WinBuilder check did not have the issue but R-Hub Ubuntu reports this, and it appears to have happened before.  Pls. see references below:

* https://stat.ethz.ch/pipermail/r-package-devel/2019q1/003577.html
* https://stackoverflow.com/questions/63613301/r-cmd-check-note-unable-to-verify-current-time

---  
    
## Test Environments
    

RStudio Server Pro (Ubuntu 18.04.2)  

* R 3.5.3  
* R 3.6.3
* R 4.0.2

Travis-CI (Ubuntu 16.04.6)

* R 3.6.3
* R 4.0.2
* R devel (2020-09-16 r79221)

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

