#Revisions and Change Log


### v1.0.1
* Minor bugfixes - updated font awesome icons (to v5 compatible)
* Updated example templated applications

### v1.0.0 **major version release**
* Updated to the latest shiny modules paradigm from the old one
* Support for downloadableTable DT options
* Styling changed to use the fresh package
* Updated example applications, documentation, vignettes, etc.
* Ensured apps created with the older version of this package will work when the package is upgraded

---

### v0.6.3
* Bugfix for the framework to not require shinydashboardPlus unless a right sidebar is in use
* Bugfixes for the sample applications
* Refined package installation and version checking in onload/onattach
* Removed lazydata designation to resolve CRAN check note

### v0.6.2
* Bugfix for the right sidebar when using shinydashboardPlus 2.0 - first tab was disappearing

### v0.6.1
* Updated to provide handling for shinydashboardPlus old (<= 0.7.5) and new versions (2.X)
* Removed import less-than requirement designation for shinydashboardPlus
* Ensured shiny 1.6 compatibility
* Updated tests and fixed a few minor bugs
* The shinydashboardPlus package was moved to a suggests scope as it is not utilized directly by this package, just in some of the generated apps.

### v0.5.4
* Updated tests in preparation for Shiny 1.6 release - no functional changes

### v0.5.3
* Updated dependencies for shinydashboardPlus - 2.x will be a breaking release
* Cleaned up logging documentation and exports

### v0.5.2
* Moved openxlsx to suggested
* Added tests

### v0.5.1  
* Added support for other color schemes in the dashboard
* Replaced CRAN-archived logging package functionality


### v0.4.10-1  
* Fixed tests for compatibility with the next release of shiny


### v0.4.9-1  
* Fixed url typo in readme link


### v0.4.9
* Added functionality to remove the left sidebar
* Bugfixes for corner cases
* Updated tests, documentation


### v0.4.8
* Added functionality to add or remove the reset button from an existing application
* Added functionality to add the right sidebar to an existing application
* Added ability to disable row.names in csv/tsv downloadFile
* Update to allow only the Advanced tab to be used in the sidebar
* Tested shiny 1.4 functionality - compatible

### v0.4.7
* Added shinydashboard plus functionality for a right-hand sidebar as an option
* Updated documentation and examples for shinydashboardPlus functionality
* Added a preference to turn off the reset application button

### v0.4.6
* Bugfix - hide downloadable table button if there are no download functions defined
* Updated tests to be compatible with the next release of htmltools (0.4, schloerke)

### v0.4.5
* Bugfix - downloadable table button was not appearing when created in a reactive block

### v0.4.4
* Supporting openxlsx workbook format for xlsx downloads in addition to data tables
* Documentation updates

### v0.4.2
* Removed unused import httr
* Documentation updates (grammatical, consistency)

### v0.4.1
* Initial CRAN release
