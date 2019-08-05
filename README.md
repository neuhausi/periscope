---
title:  "Periscope Shiny Application Framework"
output: 
    html_document:
        self_contained: no
---
<!-- Badge Location -->
[![CRAN_Status_Badge](http://www.r-pkg.org/badges/version/periscope?color=9bc2cf)](https://cran.r-project.org/package=periscope)
[![CRAN_Downloads_Badge](https://cranlogs.r-pkg.org/badges/grand-total/periscope?color=9bc2cf)](https://cran.r-project.org/package=periscope)
[![Travis-CI Build Status](https://travis-ci.org/cb4ds/periscope.svg?branch=master)](https://travis-ci.org/cb4ds/periscope)
[![Coverage Status](https://img.shields.io/codecov/c/github/cb4ds/periscope/master.svg)](https://codecov.io/github/cb4ds/periscope?branch=master)
<!-- End Badges -->

***periscope*** was originally developed as the core Shiny component for bioinformatics and systems biology analysis applications. It provides a predefined but flexible template for new Shiny applications with a default dashboard layout, three locations for user alerts, a nice busy indicator and logging features. 

One of the most important features of the shiny applications created with this framework is the separation by file of functionality that exists in one of the three shiny scopes: global, server-global, and server-local. The framework forces application developers to consciously consider scoping in Shiny applications by making scoping distinctions very clear without interfering with normal application development. Scoping consideration is important for performance and scaling, which is critical when working with large datasets and/or across many users.  In addition to providing a template application, the framework also contains a number of convenient modules: a (multi)file download button module and a downloadable table module for example.

### Installation

periscope is available for installation from 
[CRAN](https://CRAN.R-project.org/package=periscope) or you can install the
latest version of ***periscope*** from GitHub as follows:

```r
devtools::install_github('cb4ds/periscope')
```

---



### Examples

These are included to get you started. You can either start with an empty application or an application that includes samples of the components that you can use within your application.

<br/>

#### Empty application

```r
library(periscope)
create_new_application('emptyapp', location = tempdir())
runApp('emptyapp')
```


#### Sample application

```r
library(periscope)
create_new_application("sampleapp", location = tempdir(), sampleapp = TRUE)
runApp('sampleapp')

```


#### downloadFile module

```r
# Inside ui_body.R or ui_sidebar.R

#single download type
downloadFileButton("object_id1", 
                   downloadtypes = c("csv"), 
                   hovertext = "Button 1 Tooltip")

#multiple download types
downloadFileButton("object_id2", 
                   downloadtypes = c("csv", "tsv"), 
                   hovertext = "Button 2 Tooltip")
                
# Inside server_local.R

#single download type
callModule(downloadFile, 
           "object_id1", 
           logger = ss_userAction.Log,
           filenameroot = "mydownload1",
           datafxns = list(csv = mydatafxn1))

#multiple download types
callModule(downloadFile, 
           "object_id2",
           logger = ss_userAction.Log,
           filenameroot = "mytype2",
           datafxns = list(csv = mydatafxn1, xlsx = mydatafxn2))   
                   
```

#### downloadableTable module

```r
# Inside ui_body.R or ui_sidebar.R

downloadableTableUI("object_id1", 
                    downloadtypes = c("csv", "tsv"), 
                    hovertext = "Download the data here!",
                    contentHeight = "300px",
                    singleSelect = FALSE)
                    
# Inside server_local.R

selectedrows <- callModule(downloadableTable, 
                           "object_id1", 
                           logger = ss_userAction.Log,
                           filenameroot = "mydownload1",
                           downloaddatafxns = list(csv = mydatafxn1, tsv = mydatafxn2),
                           tabledata = mydatafxn3,
                           rownames = FALSE,
                           caption = "This is a great table!  By: Me" )
```
