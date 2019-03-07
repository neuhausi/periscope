# DownloadableTable Shiny Module --


#' DownloadableTable UI
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
#'     \item DownloadFile module button functionality built-in to the table
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
#' button will be hidden as there is nothing to download.  The linked
#' downloaddatafxns are set in the paired callModule (see the \strong{Shiny Usage}
#' section)
#'
#' @section Shiny Usage:
#' Call this function at the place in ui.R where the table should be placed.
#'
#' Paired with a call to \code{shiny::callModule(downloadableTable, id, ...)}
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
            style = "display:none",
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


#' DownloadableTable Module
#'
#' Server-side function for the DownloadableTableUI.  This is a custom
#' high-functionality table paired with a linked downloadFile
#' button.
#'
#' @param input provided by \code{shiny::callModule}
#' @param output provided by \code{shiny::callModule}
#' @param session provided by \code{shiny::callModule}
#' \cr \cr
#' @param logger \link[logging:logging-package]{logging} logger to use
#' @param filenameroot the base text used for user-downloaded file - can be
#' either a character string or a reactive expression returning a character
#' string
#' @param downloaddatafxns a \strong{named} list of functions providing the data as
#' return values.  The names for the list should be the same names that were used
#' when the table UI was created.
#' @param tabledata function or reactive expression providing the table display
#' data as a return value.  This function should require no input parameters.
#' @param rownames whether or not to show the rownames in the table
#' @param caption table caption
#'
#' @return Reactive expression containing the currently selected rows in the
#' display table
#'
#' @section Notes:
#' When there are no rows to download in any of the linked downloaddatafxns the
#' button will be hidden as there is nothing to download.
#'
#' @section Shiny Usage:
#' This function is not called directly by consumers - it is accessed in
#' server.R using the same id provided in \code{downloadableTableUI}:
#'
#' \strong{\code{callModule(downloadableTable, id, logger, filenameroot,
#' downloaddatafxns, tabledata, rownames, caption)}}
#'
#' \emph{Note}: callModule returns the reactive expression containing the
#' currently selected rows in the display table.
#'
#' @seealso \link[periscope]{downloadableTableUI}
#' @seealso \link[shiny]{callModule}
#' @seealso \link[logging:logging-package]{logging}
#'
#' @examples 
#' # Inside server_local.R
#' 
#' # selectedrows <- callModule(downloadableTable, 
#' #                            "object_id1", 
#' #                            logger = ss_userAction.Log,
#' #                            filenameroot = "mydownload1",
#' #                            downloaddatafxns = list(csv = mydatafxn1, tsv = mydatafxn2),
#' #                            tabledata = mydatafxn3,
#' #                            rownames = FALSE,
#' #                            caption = "This is a great table!  By: Me" )
#' 
#' # selectedrows is the reactive return value, captured for later use
#' 
#' @export
downloadableTable <- function(input, output, session, logger,
                              filenameroot, downloaddatafxns = list(),
                              tabledata, rownames = TRUE, caption = NULL) {

    shiny::callModule(downloadFile,  "dtableButtonID",
                      logger, filenameroot, downloaddatafxns)

    dtInfo <- shiny::reactiveValues(selected  = NULL,
                                    tabledata = NULL,
                                    downloaddatafxns = NULL)

    shiny::observe({
        dtInfo$selected <- input$dtableOutputID_rows_selected
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
            DT_RowId <- paste0("rowid_", seq(1:nrow(sourcedata)))
            sourcedata <- cbind(DT_RowId, sourcedata)
        }
        sourcedata
    },
        options = list(
            deferRender     = FALSE,
            scrollY         = input$dtableOutputHeight,
            paging          = FALSE,
            scrollX         = TRUE,
            dom             = '<"periscope-downloadable-table-header"f>tr',
            processing      = TRUE,
            rowId           = 1,
            columnDefs      = list(list(targets = 0,
                                        visible = FALSE,
                                        searchable = FALSE)),
            searchHighlight = TRUE ),
        class = paste("periscope-downloadable-table table-condensed",
                      "table-striped table-responsive"),
        rownames = rownames,
        selection = ifelse(input$dtableSingleSelect == "TRUE", "single", "multi"),
        caption = caption,
        escape = FALSE,
        style = "bootstrap"
    )


    selectedrows <- shiny::reactive({
        return(shiny::isolate(dtInfo$tabledata)[dtInfo$selected, ])
    })

    return(selectedrows)
}
