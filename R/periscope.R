#' Periscope Shiny Application Framework
#'
#' This package supports a ui-standardized environment as well as
#' a variety of convenience functions for shiny applications.  Base
#' reusable functionality as well as UI paradigms are included to ensure a
#' consistent user experience regardless of application or developer.
#' 
#' A gallery of example apps is hosted at \href{http://periscopeapps.org:3838}{http://periscopeapps.org}
#'
#' @section Function Overview:
#'
#' \emph{Create a new framework application instance:\cr}
#' \link[periscope]{create_new_application}\cr
#'
#' \emph{Set application parameters in program/global.R:\cr}
#' \link[periscope]{set_app_parameters}\cr
#'
#' \emph{Get any url parameters passed to the application:\cr}
#' \link[periscope]{get_url_parameters}\cr
#'
#' \emph{Register user-created UI objects to the requisite application locations:\cr}
#' \link[periscope]{add_ui_sidebar_basic}\cr
#' \link[periscope]{add_ui_sidebar_advanced}\cr
#' \link[periscope]{add_ui_sidebar_right}\cr
#' \link[periscope]{add_ui_body}
#'
#' \emph{Included shiny modules with a customized UI:\cr}
#' \link[periscope]{downloadFileButton}\cr
#' \link[periscope]{downloadableTableUI}\cr
#' \link[periscope]{downloadablePlotUI}
#'
#' \emph{High-functionality standardized tooltips:\cr}
#' \link[periscope]{ui_tooltip}
#'
#' @section More Information:
#' \code{browseVignettes(package = 'periscope')}
#'
#' @docType package
#'
#' @name periscope
NULL


.onLoad <- function(libname, pkgname) {
    #TBD
}
