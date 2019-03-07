#' Add UI Elements to the Sidebar (Basic Tab)
#'
#' This function registers UI elements to the primary (front-most) tab
#' on the dashboard sidebar.  The default name of the tab is \strong{Basic} but
#' can be renamed using the tabname argument.  This tab will be active on the
#' sidebar when the user first opens the shiny application.
#'
#' @param elementlist list of UI elements to add to the sidebar tab
#' @param append whether to append the \code{elementlist} to currently
#' registered elements or replace the currently registered elements.
#' @param tabname change the label on the UI tab (default = "Basic")
#'
#' @section Shiny Usage:
#' Call this function after creating elements in \code{ui_sidebar.R} to register
#' them to the application framework and show them on the Basic tab in the
#' dashboard sidebar
#'
#' @seealso \link[periscope]{add_ui_sidebar_advanced}
#' @seealso \link[periscope]{add_ui_body}
#'
#' @examples 
#' require(shiny)
#' 
#' s1 <- selectInput("sample1", "A Select", c("A", "B", "C"))
#' s2 <- radioButtons("sample2", NULL, c("A", "B", "C"))
#' 
#' add_ui_sidebar_basic(list(s1, s2), append = FALSE)
#' 
#' @export
add_ui_sidebar_basic <- function(elementlist = NULL,
                                 append = FALSE,
                                 tabname = "Basic") {
    if (append) {
        .g_opts$side_basic <- append(
            shiny::isolate(.g_opts$side_basic),
            elementlist)
    } else {
        .g_opts$side_basic <- list(
            shinyBS::bsAlert("sidebarBasicAlert"),
            elementlist)
    }
    .g_opts$side_basic_label <- tabname
    invisible(NULL)
}


#' Add UI Elements to the Sidebar (Advanced Tab)
#'
#' This function registers UI elements to the secondary (rear-most) tab
#' on the dashboard sidebar.  The default name of the tab is \strong{Advanced}
#' but can be renamed using the tabname argument.
#'
#' @param elementlist list of UI elements to add to the sidebar tab
#' @param append whether to append the \code{elementlist} to the currently
#' registered elements or replace the currently registered elements completely
#' @param tabname change the label on the UI tab (default = "Advanced")
#'
#' @section Shiny Usage:
#' Call this function after creating elements in \code{program/ui_sidebar.R} to register
#' them to the application framework and show them on the Advanced tab in the
#' dashboard sidebar
#'
#' @seealso \link[periscope]{add_ui_sidebar_basic}
#' @seealso \link[periscope]{add_ui_body}
#'
#' @examples 
#' require(shiny)
#' 
#' s1 <- selectInput("sample1", "A Select", c("A", "B", "C"))
#' s2 <- radioButtons("sample2", NULL, c("A", "B", "C"))
#' 
#' add_ui_sidebar_advanced(list(s1, s2), append = FALSE)
#' 
#' @export
add_ui_sidebar_advanced <- function(elementlist = NULL,
                                    append = FALSE,
                                    tabname = "Advanced") {
    if (append) {
        .g_opts$side_advanced <- append(
            shiny::isolate(.g_opts$side_advanced),
            elementlist,
            length(shiny::isolate(.g_opts$side_advanced)) - 1)
    } else {
        .g_opts$side_advanced <- list(
            shinyBS::bsAlert("sidebarAdvancedAlert"),
            elementlist)
    }
    .g_opts$side_advanced_label <- tabname
    invisible(NULL)
}


#' Add UI Elements to the Body area
#'
#' This function registers UI elements to the body of the application (the
#' right side).  Items are added in the order given.
#'
#' @param elementlist list of UI elements to add to the body
#' @param append whether to append the \code{elementlist} to the currently
#' registered elements or replace the currently registered elements completely
#'
#' @section Shiny Usage:
#' Call this function after creating elements in \code{program/ui_body.R} to
#' register them to the application framework and show them on the body area
#' of the dashboard application
#'
#' @seealso \link[periscope]{add_ui_sidebar_basic}
#' @seealso \link[periscope]{add_ui_sidebar_advanced}
#'
#' @examples 
#' require(shiny)
#' 
#' body1 <- htmlOutput("example1")
#' body2 <- actionButton("exButton", label = "Example")
#' 
#' add_ui_body(list(body1, body2))
#' 
#' @export
add_ui_body <- function(elementlist = NULL, append = FALSE) {
    if (append) {
        .g_opts$body_elements <- append(
            shiny::isolate(.g_opts$body_elements),
            elementlist,
            shiny::isolate(length(.g_opts$body_elements)) - 1)
    } else {
        .g_opts$body_elements <- list(
            shinyBS::bsAlert("bodyAlert"),
            elementlist)
    }
    invisible(NULL)
}


#' Insert a standardized tooltip
#'
#' This function inserts a standardized tooltip image, label (optional),
#' and hovertext into the application UI
#'
#' @param id character id for the tooltip object
#' @param label text label to appear to the left of the tooltip image
#' @param text tooltip text shown when the user hovers over the image
#'
#' @export
ui_tooltip <- function(id, label = "", text = "") {
    if (is.null(text) || is.na(text) || (text == "")) {
        warning("ui_tooltip() called without tooltip text.")
    }

    result <- shiny::span(
        class = "periscope-input-label-with-tt",
        label,
        shiny::img(id = id,
                   src =    shiny::isolate(.g_opts$tt_image),
                   height = shiny::isolate(.g_opts$tt_height),
                   width =  shiny::isolate(.g_opts$tt_width)),
        shinyBS::bsTooltip(id = id, text, placement = "top"))

    return(result)
}


#' Set Application Parameters
#'
#' This function sets global parameters customizing the shiny application.
#'
#' @param title application title text
#' @param titleinfo character string, HTML value or NULL
#' \itemize{
#' \item{A \strong{character} string will be used to set a link target.  This means the user
#' will be able to click on the application title and be redirected in a new
#' window to whatever value is given in the string.  Any valid URL, File, or
#' other script functionality that would normally be accepted in an <a href=...>
#' tag is allowed.}
#' \item{An \strong{HTML} value will be used to as the HTML content for a modal pop-up
#' window that will appear on-top of the application when the user clicks on the
#' application title.}
#' \item{Supplying \strong{NULL} will disable the title link functionality.}
#' }
#' @param loglevel character string designating the log level to use for
#' the userlog (default = 'DEBUG')
#' @param showlog enable or disable the visible userlog at the bottom of the
#' body on the application.  Logging will still take place, this disables the
#' visible functionality only.
#' @param app_version character string designating the application version (default = '1.0.0').
#'
#' @section Shiny Usage:
#' Call this function from \code{program/global.R} to set the application
#' parameters.
#'
#' @seealso \link[logging:logging-package]{logging}
#' 
#' @export
set_app_parameters <- function(title, titleinfo = NULL,
                               loglevel = "DEBUG",
                               showlog = TRUE,
                               app_version = "1.0.0") {
    .g_opts$app_title <- title
    .g_opts$app_info  <- titleinfo
    .g_opts$loglevel  <- loglevel
    .g_opts$show_userlog <- showlog
    .g_opts$app_version  <- app_version

    invisible(NULL)
}


#' Get URL Parameters
#'
#' This function returns any url parameters passed to the application as
#' a named list.  Keep in mind url parameters are always user-session scoped
#'
#' @param  session shiny session object
#' @return named list of url parameters and values.  List may be empty if
#' no URL parameters were passed when the application instance was launched.
#'
#' @export
get_url_parameters <- function(session) {
    parameters <- list()

    if (!is.null(session)) {
        raw <- shiny::isolate(session$clientData$url_search)
        parameters <- shiny::parseQueryString(raw)
    }

    return(parameters)
}
