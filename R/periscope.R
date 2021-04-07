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

.g_sdp_installed <- FALSE
.g_sdp_oldver    <- FALSE

.onLoad <- function(libname, pkgname) {
    if (length(find.package('shinydashboardPlus', quiet = T)) > 0) {
        if (utils::packageVersion('shinydashboardPlus') < 2) {
            .g_sdp_oldver <<- TRUE
        }
        .g_sdp_installed <<- TRUE
    }
}

.onAttach <- function(libname, pkgname) {
    current_location <- getwd()
    server_filename  <- "server.R"
    if (interactive() && file.exists(file.path(current_location, c(server_filename)))) {
        server_file    <- file(paste(current_location, server_filename, sep = .Platform$file.sep))
        server_content <- readLines(con = server_file)
        close(server_file)
        if (any(grepl("library\\(logging\\)", server_content))) {
            packageStartupMessage(paste("The logging package is not supported anymore. Please remove the line 'library(logging)' in", server_filename))
        }
    }
}
