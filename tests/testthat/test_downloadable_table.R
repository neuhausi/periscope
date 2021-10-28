context("periscope - downloadable table")


test_that("downloadableTableUI", {
    local_edition(3)
    expect_snapshot_output(downloadableTableUI(id = "myid", 
                                               downloadtypes = c("csv"), 
                                               hovertext = "myHoverText"))
})

# helper functions
data <- reactive({
    c(1,2)
})

mydataRowIds <- function(){
    rownames(mtcars)
}

test_that("downloadableTable - singleSelect_FALSE_selection_enabled", {
    suppressWarnings({
        session <- MockShinySession$new()
        session$setInputs(dtableSingleSelect = FALSE)
        session$env$filenameroot <-  "mydownload1"
        session$env$downloaddatafxns = list(csv = data, tsv = data)
        expect_silent(shiny::callModule(downloadableTable,
                                        "download",
                                        input = list(dtableSingleSelect = "FALSE"),
                                        output = list(), 
                                        session = session,
                                        logger = periscope:::fw_get_user_log(),
                                        filenameroot = "mydownload1",
                                        downloaddatafxns = list(csv = data, tsv = data),
                                        tabledata = data,
                                        selection = mydataRowIds))
    })
})

test_that("downloadableTable - free_parameters", {
    suppressWarnings({
        session <- MockShinySession$new()
        session$setInputs(dtableSingleSelect = FALSE)
        session$env$filenameroot <-  "mydownload1"
        session$env$downloaddatafxns = list(csv = data, tsv = data)
        expect_silent(shiny::callModule(downloadableTable,
                                        "download",
                                        input = list(dtableSingleSelect = "FALSE"),
                                        output = list(), 
                                        session = session,
                                        periscope:::fw_get_user_log(),
                                        "mydownload1",
                                        list(csv = data, tsv = data),
                                        data,
                                        selection = mydataRowIds))
    })
})

test_that("downloadableTable - new module call", {
    suppressWarnings({
        session <- MockShinySession$new()
        session$setInputs(dtableSingleSelect = FALSE)
        session$env$filenameroot <-  "mydownload1"
        session$env$downloaddatafxns = list(csv = data, tsv = data)
        expect_error(downloadableTable("download",
                                       input = list(dtableSingleSelect = "FALSE"),
                                       output = list(), 
                                       session = session,
                                       logger = periscope:::fw_get_user_log(),
                                       filenameroot = "mydownload1",
                                       downloaddatafxns = list(csv = data, tsv = data),
                                       tabledata = data,
                                       selection = mydataRowIds))
                                        
    })
})

test_that("downloadableTable - singleSelect_TRUE_selection_enabled", {
    suppressWarnings({
        session <- MockShinySession$new()
        session$setInputs(dtableSingleSelect = TRUE)
        session$env$filenameroot <-  "mydownload1"
        session$env$downloaddatafxns = list(csv = data, tsv = data)
        expect_silent(shiny::callModule(downloadableTable,
                                        "download",
                                        input = list(dtableSingleSelect = "FALSE"),
                                        output = list(), 
                                        session = session,
                                        logger = periscope:::fw_get_user_log(),
                                        filenameroot = "mydownload1",
                                        downloaddatafxns = list(csv = data, tsv = data),
                                        tabledata = data,
                                        selection = mydataRowIds))
    })
})

test_that("downloadableTable - singleSelect and selection disabled", {
    suppressWarnings({
        session <- MockShinySession$new()
        session$setInputs(dtableSingleSelect = TRUE)
        session$env$filenameroot <-  "mydownload1"
        session$env$downloaddatafxns = list(csv = data, tsv = data)
        expect_silent(shiny::callModule(downloadableTable,
                                        "download",
                                        input = list(dtableSingleSelect = "FALSE"),
                                        output = list(), 
                                        session = session,
                                        logger = periscope:::fw_get_user_log(),
                                        filenameroot = "mydownload1",
                                        downloaddatafxns = list(csv = data, tsv = data),
                                        tabledata = data))
    })
})

test_that("downloadableTable - invalid_selection", {
    suppressWarnings({
        session <- MockShinySession$new()
        session$setInputs(dtableSingleSelect = TRUE)
        session$env$filenameroot <-  "mydownload1"
        session$env$downloaddatafxns = list(csv = data, tsv = data)
        expect_message(shiny::callModule(downloadableTable,
                                        "download",
                                        input = list(dtableSingleSelect = "FALSE"),
                                        output = list(), 
                                        session = session,
                                        logger = periscope:::fw_get_user_log(),
                                        filenameroot = "mydownload1",
                                        downloaddatafxns = list(csv = data, tsv = data),
                                        tabledata = data,
                                        selection = "single"))
    })
})

test_that("build_datatable_arguments", {
    local_edition(3)
    table_options <- list(rownames = FALSE,
                          callback = "table.order([2, 'asc']).draw();",
                          caption = " Very Important Information",
                          colnames = c("Area", "Delta", "Increase"),
                          filter = "bottom",
                          width = "150px",
                          height = "50px",
                          extensions = 'Buttons',
                          plugins = 'natural',
                          editable = TRUE,
                          order = list(list(2, 'asc'), list(3, 'desc')))
    expect_snapshot(build_datatable_arguments(table_options))
})


test_that("format_columns", {
    local_edition(3)
    set.seed(123)
    dt <-  cbind(matrix(rnorm(60, 1e5, 1e6), 20), runif(20), rnorm(20, 100))
    dt[, 1:3] = round(dt[, 1:3])
    dt[, 4:5] = round(dt[, 4:5], 7)
    colnames(dt) = head(LETTERS, ncol(dt))
    expect_snapshot(format_columns(DT::datatable(dt), 
                                   list(formatCurrency = list(columns = c("A", "C")),
                                        formatPercentage = list(columns = c("D"), 2))))
})
