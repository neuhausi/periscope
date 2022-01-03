# downloadableTable Shiny Module --


#' downloadableTable UI
#'
#' Creates a custom high-functionality table paired with a linked downloadFile
#' button.  The table has search and highlight functionality, infinite scrolling,
#' sorting by columns and returns a reactive dataset of selected items.
#'
#' @param id character id for the object
#' @param downloadtypes vector of values for data download types
#' @param hovertext download button tooltip hover text
#' @param contentHeight viewable height of the table (any valid css size value)
#' @param singleSelect whether the table should only allow a single row to be
#' selected at a time (FALSE by default allows multi-select).
#'
#' @section Table Features:
#' \itemize{
#'     \item Consistent styling of the table
#'     \item downloadFile module button functionality built-in to the table
#'     \item Ability to show different data from the download data
#'     \item Table is automatically fit to the window size with infinite
#'     y-scrolling
#'     \item Table search functionality including highlighting built-in
#'     \item Multi-select built in, including reactive feedback on which table
#'     items are selected
#' }
#'
#' @section Example:
#' \code{downloadableTableUI("mytableID", c("csv", "tsv"),
#' "Click Here", "300px")}
#'
#' @section Notes:
#' When there are no rows to download in any of the linked downloaddatafxns the
#' button will be hidden as there is nothing to download. 
#'
#' @section Shiny Usage:
#' Call this function at the place in ui.R where the table should be placed.
#'
#' Paired with a call to \code{downloadableTable(id, ...)}
#' in server.R
#'
#' @seealso \link[periscope]{downloadableTable}
#' @seealso \link[periscope]{downloadFileButton}
#'
#' @examples 
#' # Inside ui_body.R or ui_sidebar.R
#' downloadableTableUI("object_id1", 
#'                     downloadtypes = c("csv", "tsv"), 
#'                     hovertext = "Download the data here!",
#'                     contentHeight = "300px",
#'                     singleSelect = FALSE)
#' 
#' @export
downloadableTableUI <- function(id,
                                downloadtypes = c("csv"),
                                hovertext     = NULL,
                                contentHeight = "200px",
                                singleSelect  = FALSE) {
    ns <- shiny::NS(id)

    list(
        shiny::span(
            id = ns("dtableButtonDiv"),
            class = "periscope-downloadable-table-button",
            style = ifelse(length(downloadtypes) > 0, "", "display:none"),
            downloadFileButton(ns("dtableButtonID"),
                               downloadtypes,
                               hovertext)),
        DT::dataTableOutput(ns("dtableOutputID")),
        shiny::tags$input(
            id = ns("dtableOutputHeight"),
            type = "text",
            class = "shiny-input-container hidden",
            value = contentHeight),
        shiny::tags$input(
            id = ns("dtableSingleSelect"),
            type = "text",
            class = "shiny-input-container hidden",
            value = singleSelect)
    )
}


#' downloadableTable Module
#'
#' Server-side function for the downloadableTableUI.  This is a custom
#' high-functionality table paired with a linked downloadFile
#' button.
#' 
#' Generated table can highly customized using function \code{?DT::datatable} same arguments
#'  except for `options` and `selection` parameters. 
#'  
#' For `options` user can pass the same \code{?DT::datatable} options using the same names and 
#' values one by one separated by comma.
#'  
#' For `selection` parameter it can be either a function or reactive expression providing the row_ids of the
#' rows that should be selected.
#' 
#' Also, user can apply the same provided \code{?DT::formatCurrency} columns formats on passed
#' dataset using format functions names as keys and their options as a list.
#'  
#'
#' @param ... free parameters list to pass table customization options. See example below.
#'            \emph{Note}: The first argument of this function must be the ID of the Module's UI element
#' @param logger logger to use
#' @param filenameroot the base text used for user-downloaded file - can be
#' either a character string or a reactive expression returning a character
#' string
#' @param downloaddatafxns a \strong{named} list of functions providing the data as
#' return values.  The names for the list should be the same names that were used
#' when the table UI was created.
#' @param tabledata function or reactive expression providing the table display
#' data as a return value. This function should require no input parameters.
#' @param selection function or reactive expression providing the row_ids of the
#' rows that should be selected
#'
#' @return Reactive expression containing the currently selected rows in the
#' display table
#'
#' @section Notes:
#'  \itemize{
#'   \item When there are no rows to download in any of the linked downloaddatafxns 
#'   the button will be hidden as there is nothing to download.
#'   \item \code{selection} parameter has different usage than DT::datatable \code{selection} option. 
#'   See parameters usage section.
#'   \item DT::datatable options \code{editable}, \code{width} and \code{height} are not supported
#' }
#'
#' @section Shiny Usage:
#' This function is not called directly by consumers - it is accessed in
#' server.R using the same id provided in \code{downloadableTableUI}:
#'
#' \strong{\code{downloadableTable(id, logger, filenameroot,
#' downloaddatafxns, tabledata, rownames, caption, selection)}}
#'
#' \emph{Note}: calling module server returns the reactive expression containing the
#' currently selected rows in the display table.
#'
#' @seealso \link[periscope]{downloadableTableUI}
#'
#' @examples 
#' # Inside server_local.R
#' 
#' # selectedrows <- downloadableTable(
#' #     "object_id1", 
#' #     logger = ss_userAction.Log,
#' #     filenameroot = "mydownload1",
#' #     downloaddatafxns = list(csv = mydatafxn1, tsv = mydatafxn2),
#' #     tabledata = mydatafxn3,
#' #     rownames = FALSE,
#' #     caption = "This is a great table!  By: Me",
#' #     selection = mydataRowIds,
#' #     colnames = c("Area", "Delta", "Increase"),
#' #     filter = "bottom",
#' #     width = "150px",
#' #     height = "50px",
#' #     extensions = 'Buttons',
#' #     plugins = 'natural',
#' #     editable = TRUE, 
#' #     dom = 'Bfrtip', 
#' #     buttons = c('copy', 'csv', 'excel', 'pdf', 'print'),
#' #     formatStyle = list(columns = c('Area'),  color = 'red'),
#' #     formatStyle = list(columns = c('Increase'), color = DT::styleInterval(0, c('red', 'green'))), 
#' #     formatCurrency = list(columns = c('Delta')))
#' 
#' # selectedrows is the reactive return value, captured for later use
#' 
#' @export
downloadableTable <- function(...,
                              logger,
                              filenameroot, 
                              downloaddatafxns = list(),
                              tabledata,
                              selection = NULL) {
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
    } 
    else {
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
    
    if (missing(downloaddatafxns) && params_length >= param_index) {
        downloaddatafxns <- params[[param_index]]
        param_index <- param_index + 1
    }
    
    if (missing(tabledata) && params_length >= param_index) {
        tabledata <- params[[param_index]]
        param_index <- param_index + 1
    }
    
    if (missing(selection)) {
        selection <- params[["selection"]]
        params[["selection"]] <- NULL
    }
    
    if (old_style_call) {
        download_table(input, output, session, 
                       logger,
                       filenameroot, 
                       downloaddatafxns,
                       tabledata, 
                       selection,
                       params[param_index:params_length])
    }
    else {
        shiny::moduleServer(id = params[[1]], 
                     function(input, output, session) {
                         download_table(input, output, session, 
                                        logger,
                                        filenameroot, 
                                        downloaddatafxns,
                                        tabledata,
                                        selection,
                                        params[param_index:params_length])
                     })
    }
}

download_table <- function(input, output, session, 
                           logger,
                           filenameroot, 
                           downloaddatafxns = list(),
                           tabledata, 
                           selection,
                           table_options) {
    if (all(!is.null(selection),
            is.character(selection))) {
        message("'selection' parameter must be a function or reactive expression. Setting default value NULL.")
        selection <- NULL
    }
    
    downloadFile("dtableButtonID", logger, filenameroot, downloaddatafxns)
    
    session$sendCustomMessage("downloadbutton_toggle",
                              message = list(btn  = session$ns("dtableButtonDiv"),
                                             rows = -1))
    
    dtInfo <- shiny::reactiveValues(selection        = NULL,
                                    selected         = NULL,
                                    tabledata        = NULL,
                                    downloaddatafxns = NULL)
    
    shiny::observe({
        result <- list(mode = ifelse(input$dtableSingleSelect == "TRUE", "single", "multiple"))
        if (!is.null(selection)) {
            selection_value <- selection()
            if (result[["mode"]] == "single" && length(selection_value) > 1) {
                selection_value <- selection_value[1]
            }
            result[["selected"]] <- selection_value
            dtInfo$selection <- NULL
        }
        dtInfo$selection <- result
    })
    
    shiny::observe({
        dtInfo$selected  <- input$dtableOutputID_rows_selected
    })
    
    shiny::observe({
        dtInfo$tabledata <- tabledata()
    })
    
    shiny::observe({
        dtInfo$downloaddatafxns <- lapply(downloaddatafxns, do.call, list())
        
        rowct <- lapply(dtInfo$downloaddatafxns, nrow)
        session$sendCustomMessage("downloadbutton_toggle",
                                  message = list(btn  = session$ns("dtableButtonDiv"),
                                                 rows = sum(unlist(rowct))))
    })
    
    output$dtableOutputID <- DT::renderDataTable({
        sourcedata <- dtInfo$tabledata
        
        if (!is.null(sourcedata) && nrow(sourcedata) > 0) {
            row.names <- rownames(sourcedata)
            row.ids   <- as.character(seq(1:nrow(sourcedata)))
            if (is.null(row.names) || identical(row.names, row.ids)) {
                DT_RowId <- paste0("rowid_", row.ids)
                rownames(sourcedata) <- DT_RowId
            }
        }
        
        if (is.null(table_options[["scrollY"]])) {
            table_options[["scrollY"]] <- input$dtableOutputHeight
        }
        
        table_options[["selection"]] <- dtInfo$selection
        
        if (is.null(table_options[["escape"]])) {
            table_options[["escape"]] <- FALSE
        }
        
        if (is.null(table_options[["rownames"]])) {
            table_options[["rownames"]] <- FALSE
        }
        
        # get format functions
        format_options_idx <- which(startsWith(names(table_options), "format"))
        format_options <- table_options[format_options_idx]
        if (length(format_options_idx) > 0) {
            dt_args <- build_datatable_arguments(table_options[-format_options_idx])
        } else {
            dt_args <- build_datatable_arguments(table_options)
        }
        
        if (is.null(sourcedata)) {
            sourcedata <- data.frame()
        }
        
        dt_args[["data"]] <- sourcedata
        
        tryCatch({
            dt <- do.call(DT::datatable, dt_args)
            
            if ((length(format_options) > 0) && (NROW(dt_args$data) > 0)) {
                dt <- format_columns(dt, format_options)
            }
            dt
        },
        error = function(e) {
            message("Could not apply DT options due to: ", e$message)
            DT::datatable(sourcedata)
        })
    })
    
    
    shiny::reactive({
        return(shiny::isolate(dtInfo$tabledata)[dtInfo$selected, ])
    })  
}

build_datatable_arguments <- function(table_options) {
    dt_args <- list()
    formal_dt_args <- methods::formalArgs(DT::datatable)
    dt_args[["rownames"]] <- TRUE
    dt_args[["class"]] <- paste("periscope-downloadable-table table-condensed",
                               "table-striped table-responsive")
    options <- list()
    for (option in names(table_options)) {
        if (option %in% c("editable", "width", "height")) {
            message("DT option '", option ,"' is not supported. Ignoring it.")
            next
        }
        
        if (option %in% formal_dt_args) {
            dt_args[[option]] <- table_options[[option]]
        } else {
            options[[option]] <- table_options[[option]]
        }
    }
    
    if (is.null(options[["deferRender"]])) {
        options[["deferRender"]] <- FALSE
    }
    
    if (is.null(options[["paging"]]) && is.null(table_options[["pageLength"]])) {
        options[["paging"]] <- FALSE
    }
    
    if (is.null(options[["scrollX"]])) {
        options[["scrollX"]] <- TRUE
    }
    
    if (is.null(options[["dom"]]) && is.null(table_options[["pageLength"]])) {
        options[["dom"]] <- '<"periscope-downloadable-table-header"f>tr'
    }
    
    if (is.null(options[["processing"]])) {
        options[["processing"]] <- TRUE
    }
    
    if (is.null(options[["rowId"]])) {
        options[["rowId"]] <- 1
    }
    
    if (is.null(options[["searchHighlight"]])) {
        options[["searchHighlight"]] <- TRUE
    }
    dt_args[["options"]] <- options
    dt_args
}

format_columns <- function(dt, format_options) {
    for (format_idx in 1:length(format_options)) {
        format_args <- format_options[[format_idx]]
        format_args[["table"]] <- dt
        format <- tolower(names(format_options)[format_idx])
        dt <- switch(format,
                     "formatstyle" = do.call(DT::formatStyle, format_args),
                     "formatdate" = do.call(DT::formatDate, format_args),
                     "formatsignif" = do.call(DT::formatSignif, format_args),
                     "formatround" = do.call(DT::formatRound, format_args),
                     "formatpercentage" = do.call(DT::formatPercentage, format_args),
                     "formatstring" = do.call(DT::formatString, format_args),
                     "formatcurrency" = do.call(DT::formatCurrency, format_args))
    }
    dt
}
