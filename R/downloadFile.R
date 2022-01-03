# downloadFile Shiny Module -----


#' downloadFileButton UI
#'
#' Creates a custom high-functionality button for file downloads with two
#' states - single download type or multiple-download types.  The button image
#' and pop-up menu (if needed) are set accordingly.  A tooltip can also be set
#' for the button.
#'
#' @param id character id for the object
#' @param downloadtypes vector of values for data download types
#' @param hovertext tooltip hover text
#'
#' @section Button Features:
#' \itemize{
#'     \item Consistent styling of the button, including a hover tooltip
#'     \item Single or multiple types of downloads
#'     \item Ability to download different data for each type of download
#' }
#'
#' @section Example:
#' \code{downloadFileUI("mybuttonID1", c("csv", "tsv"), "Click Here")}
#' \code{downloadFileUI("mybuttonID2", "csv", "Click to download")}
#'
#' @section Shiny Usage:
#' Call this function at the place in ui.R where the button should be placed.
#'
#' It is paired with a call to \code{downloadFile(id, ...)}
#' in server.R
#'
#' @seealso \link[periscope]{downloadFile}
#' @seealso \link[periscope]{downloadFile_ValidateTypes}
#' @seealso \link[periscope]{downloadFile_AvailableTypes}
#'
#' @examples 
#' # Inside ui_body.R or ui_sidebar.R
#' 
#' #single download type
#' downloadFileButton("object_id1", 
#'                    downloadtypes = c("csv"), 
#'                    hovertext = "Button 1 Tooltip")
#' 
#' #multiple download types
#' downloadFileButton("object_id2", 
#'                    downloadtypes = c("csv", "tsv"), 
#'                    hovertext = "Button 2 Tooltip")
#' 
#' @export
downloadFileButton <- function(id,
                               downloadtypes = c("csv"),
                               hovertext = NULL) {
    ns <- shiny::NS(id)
    output <- ""
    
    if (length(downloadtypes) > 1) {
        # create dropdown list
        dropdown <- list()
        for (item in downloadtypes) {
            dropdown <- list(dropdown,
                             shiny::tags$li(
                                 shiny::downloadLink(
                                     ns(item),
                                     label = item,
                                     class = "periscope-download-choice")))
        }
        dropdown <- shiny::tagList(dropdown)
        
        # button with dropdown list
        output <- shiny::span(
            class = "btn-group",
            shinyBS::bsButton(
                inputId = ns("downloadFileList"),
                label = NULL,
                icon = shiny::icon("copy", lib = "font-awesome"),
                type  = "action",
                class = "dropdown-toggle periscope-download-btn",
                `data-toggle` = "dropdown",
                `aria-haspopup` = "true",
                `aria-expanded` = "false"),
            shiny::tags$ul(class = "dropdown-menu",
                           id = ns("testList"),
                           dropdown),
            shinyBS::bsTooltip(id = ns("downloadFileList"),
                               hovertext,
                               placement = "top"))
    }
    else {
        # single button - no dropdown
        output <- shiny::span(shiny::downloadButton(ns(downloadtypes[1]),
                                                    label = NULL,
                                                    class = "periscope-download-btn"),
                              shinyBS::bsTooltip(id = ns(downloadtypes[1]),
                                                 hovertext,
                                                 placement = "top"))
    }
    output
}


#' downloadFile Module
#'
#' Server-side function for the downloadFileButton.  This is a custom
#' high-functionality button for file downloads supporting single or multiple
#' download types.  The server function is used to provide the data for download.
#' @param ... free parameters list for shiny to pass session variables based on the module call(session, input, output)
#'  variables. \emph{Note}: The first argument of this function must be the ID of the Module's UI element
#' @param logger logger to use
#' @param filenameroot the base text used for user-downloaded file - can be
#' either a character string or a reactive expression that returns a character
#' string
#' @param datafxns a \strong{named} list of functions providing the data as
#' return values.  The names for the list should be the same names that were used
#' when the button UI was created.
#' @param aspectratio the downloaded chart image width:height ratio (ex:
#' 1 = square, 1.3 = 4:3, 0.5 = 1:2). Where not applicable for a download type
#' it is ignored (e.g. data downloads).
#'
#' @section Shiny Usage:
#' This function is not called directly by consumers - it is accessed in
#' server.R using the same id provided in \code{downloadFileButton}:
#'
#' \strong{\code{downloadFile(id, logger, filenameroot, datafxns)}}
#'
#' @seealso \link[periscope]{downloadFileButton}
#' @seealso \link[periscope]{downloadFile_ValidateTypes}
#' @seealso \link[periscope]{downloadFile_AvailableTypes}
#'
#' @examples 
#' # Inside server_local.R
#' 
#' #single download type
#' # downloadFile("object_id1", 
#' #              logger = ss_userAction.Log,
#' #              filenameroot = "mydownload1",
#' #              datafxns = list(csv = mydatafxn1),
#' #              aspectratio = 1)
#' 
#' #multiple download types
#' # downloadFile("object_id2",
#' #              logger = ss_userAction.Log,
#' #              filenameroot = "mytype2",
#' #              datafxns = list(csv = mydatafxn1, xlsx = mydatafxn2),
#' #              aspectratio = 1)
#' 
#' @export
downloadFile <- function(...,
                         logger,
                         filenameroot, 
                         datafxns = list(),
                         aspectratio = 1) {
    call <- match.call()
    params <- list(...)
    param_index <- 1
    params_length <- length(params)
    old_style_call <- call[[1]] == "module" || "periscope" %in% as.character(call[[1]])
    
    if (old_style_call) {
        input   <- params[[param_index]]
        param_index <- param_index + 1
        output  <- params[[param_index]]
        param_index <- param_index + 1
        session <- params[[param_index]]
        param_index <- param_index + 1
    } else {
        id <- params[[param_index]]
        param_index <- param_index + 1
    }
    
    if (missing(logger) && params_length >= param_index) {
        logger <- params[[param_index]]
        param_index <- param_index + 1
    }
    
    if (missing(filenameroot) && params_length >= param_index) {
        filenameroot <- params[[param_index]]
        param_index <- param_index + 1
    }
    
    if (missing(datafxns) && params_length >= param_index) {
        datafxns <- params[[param_index]]
        param_index <- param_index + 1
    }
    
    if (missing(aspectratio) && params_length >= param_index) {
        aspectratio <- params[[param_index]]
        param_index <- param_index + 1
    }
    
    if (old_style_call) {
        download_file(input, 
                      output, 
                      session,
                      logger,
                      filenameroot, 
                      datafxns,
                      aspectratio)
    } 
    else {
        shiny::moduleServer(
            id,
            function(input, output, session) {
                download_file(input, 
                              output, 
                              session,
                              logger,
                              filenameroot, 
                              datafxns,
                              aspectratio)
            })   
    }
}

download_file <- function(input, 
                          output, 
                          session,
                          logger,
                          filenameroot, 
                          datafxns = list(),
                          aspectratio = 1) {
    rootname <- filenameroot
    if ("character" %in% class(filenameroot)) {
        rootname <- shiny::reactive({filenameroot})
    }
    
    # --- DATA processing
    
    output$csv  <- shiny::downloadHandler(
        filename = shiny::reactive({paste(rootname(), "csv", sep = ".")}),
        content  = function(file) {
            writeFile("csv", datafxns$csv(), file, logger,
                      shiny::reactive({paste(rootname(), "csv", sep = ".")}))
        })
    
    output$xlsx <- shiny::downloadHandler(
        filename = shiny::reactive({paste(rootname(), "xlsx", sep = ".")}),
        content  = function(file) {
            writeFile("xlsx", datafxns$xlsx(), file, logger,
                      shiny::reactive({paste(rootname(), "xlsx", sep = ".")}))
        })
    
    output$tsv  <- shiny::downloadHandler(
        filename = shiny::reactive({paste(rootname(), "tsv", sep = ".")}),
        content = function(file) {
            writeFile("tsv", datafxns$tsv(), file, logger,
                      shiny::reactive({paste(rootname(), "tsv", sep = ".")}))
        })
    
    output$txt  <- shiny::downloadHandler(
        filename = shiny::reactive({paste(rootname(), "txt", sep = ".")}),
        content = function(file) {
            writeFile("txt", datafxns$txt(), file, logger,
                      shiny::reactive({paste(rootname(), "txt", sep = ".")}))
        })
    
    # filename is expected to be a reactive expression
    writeFile <- function(type, data, file, logger, filename) {
        # tabular values
        if ((type == "csv") | (type == "tsv")) {
            show_rownames <- attr(data, "show_rownames")
            show_rownames <- !is.null(show_rownames) && show_rownames
            show_colnames <- TRUE
            if (show_rownames) {
                show_colnames <- NA
            }
            
            utils::write.table(data, file,
                               sep = ifelse(type == "tsv", "\t", ","),
                               dec = ".",
                               qmethod = "double",
                               col.names = show_colnames,
                               row.names = show_rownames)
        }
        # excel file
        else if (type == "xlsx") {
            if ("openxlsx" %in% utils::installed.packages()) {
                if ((class(data) == "Workbook") && ("openxlsx" %in% attributes(class(data)))) {
                    openxlsx::saveWorkbook(data, file)
                } else {
                    show_rownames <- attr(data, "show_rownames")
                    openxlsx::write.xlsx(data, file, 
                                         asTable   = TRUE, 
                                         row.names = !is.null(show_rownames) && show_rownames)
                }
            } else {
                writexl::write_xlsx(data, file)
            }
        }
        # text file processing
        else if (type == "txt") {
            if (class(data) == "character") {
                writeLines(data, file)
            }
            else if (is.data.frame(data) || is.matrix(data)) {
                utils::write.table(data, file)
            }
            else {
                msg <- paste(type, "could not be processed")
                logwarn(msg)
                warning(msg)
            }
        }
        # error - type not handled
        else {
            msg <- paste(type, "not implemented as a download type")
            logwarn(msg)
            warning(msg)
        }
        loginfo(paste("File downloaded in browser: <",
                      filename(), ">"), logger = logger)
    }
    
    # --- IMAGE processing
    
    output$png <- shiny::downloadHandler(
        filename = shiny::reactive({paste(rootname(), "png", sep = ".")}),
        content = function(file) {
            writeImage("png", datafxns$png(), file, aspectratio, logger,
                       shiny::reactive({paste(rootname(), "png", sep = ".")}))
        })
    
    output$jpeg <- shiny::downloadHandler(
        filename = shiny::reactive({paste(rootname(), "jpeg", sep = ".")}),
        content = function(file) {
            writeImage("jpeg", datafxns$jpeg(), file, aspectratio, logger,
                       shiny::reactive({paste(rootname(), "jpeg", sep = ".")}))
        })
    
    output$tiff <- shiny::downloadHandler(
        filename = shiny::reactive({paste(rootname(), "tiff", sep = ".")}),
        content = function(file) {
            writeImage("tiff", datafxns$tiff(), file, aspectratio, logger,
                       shiny::reactive({paste(rootname(), "tiff", sep = ".")}))
        })
    
    output$bmp <- shiny::downloadHandler(
        filename = shiny::reactive({paste(rootname(), "bmp", sep = ".")}),
        content = function(file) {
            writeImage("bmp", datafxns$bmp(), file, aspectratio, logger,
                       shiny::reactive({paste(rootname(), "bmp", sep = ".")}))
        })
    
    writeImage <- function(type, data, file, aspectratio, logger, filename) {
        dim <- list(width = 7, height = 7/aspectratio, units = "in")
        
        #ggplot processing
        if (inherits(data, c("ggplot", "ggmatrix", "grob"))) {
            if (type %in% c("png", "jpeg", "tiff", "bmp")) {
                ggplot2::ggsave(filename = file,
                                plot     = data,
                                width    = dim$width,
                                height   = dim$height,
                                units    = dim$units,
                                scale    = 2)
            }
            else {
                msg <- paste("Unsupported plot type for ggplot download - ",
                             "must be in: <png, jpeg, tiff, bmp>")
                logwarn(msg)
                warning(msg)
            }
        }
        #lattice processing
        else if (inherits(data, "trellis")) {
            if (type %in% c("png", "jpeg", "tiff", "bmp")) {
                do.call(type, list(filename = file,
                                   width    = dim$width,
                                   height   = dim$height,
                                   units    = dim$units,
                                   res      = 600))
                print(data)
                grDevices::dev.off()
            }
            else {
                msg <- paste("Unsupported plot type for lattice download - ",
                             "must be in: <png, jpeg, tiff, bmp>")
                logwarn(msg)
                warning(msg)
            }
        }
        # error - type not handled
        # ------- should really never be hit
        else {
            msg <- paste(type, "not implemented as a download type")
            logwarn(msg)
            warning(msg)
        }
        loginfo(paste("File downloaded in browser: <",
                      filename(), ">"), logger = logger)
    }
}


#' downloadFile Helper
#'
#' Checks a given list of file types and warns if an invalid type is included
#'
#' @param types list of types to test
#'
#' @return the list input given in types
#'
#' @section Example:
#' \code{downloadFile_ValidateTypes(c("csv", "tsv"))}
#'
#' @seealso \link[periscope]{downloadFileButton}
#' @seealso \link[periscope]{downloadFile}
#'
#' @export
downloadFile_ValidateTypes <- function(types) {
    for (type in types) {
        if ( !(type %in% shiny::isolate(.g_opts$data_download_types)) &&
             !(type %in% shiny::isolate(.g_opts$plot_download_types)) ) {
            warning(paste0("file download list contains an invalid type <",
                           type, ">"))
        }
    }
    types
}


#' downloadFile Helper
#'
#' Returns a list of all supported types
#'
#' @return a vector of all supported types
#'
#' @seealso \link[periscope]{downloadFileButton}
#' @seealso \link[periscope]{downloadFile}
#'
#' @export
downloadFile_AvailableTypes <- function() {
    types <- c(shiny::isolate(.g_opts$data_download_types),
               shiny::isolate(.g_opts$plot_download_types))
    return(types)
}
