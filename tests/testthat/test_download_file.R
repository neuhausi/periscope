context("periscope - download file")

# helper functions
download_plot <- function() {
    ggplot2::ggplot(data = mtcars, aes(x = wt, y = mpg)) +
        geom_point(aes(color = cyl)) +
        theme(legend.justification = c(1, 1),
              legend.position = c(1, 1),
              legend.title = element_blank()) +
        ggtitle("GGPlot Example w/Hover") +
        xlab("wt") +
        ylab("mpg")
}

download_data <- function() {
    mtcars
}

download_data_show_row_names <- function() {
    attr(mtcars, "show_rownames") <-  TRUE
    mtcars
}

download_string_list <- function() {
    c("test1", "test2", "tests")
}

# UI Testing
test_that("downloadFileButton", {
    local_edition(3)
    expect_snapshot_output(downloadFileButton(id = "myid",
                                              downloadtypes = c("csv"),
                                              hovertext = "myhovertext"))
})

test_that("downloadFileButton multiple types", {
    local_edition(3)
    expect_snapshot_output(downloadFileButton(id = "myid",
                                              downloadtypes = c("csv", "tsv"), 
                                              hovertext = "myhovertext"))
})

# Server Testing
test_that("downloadFile_ValidateTypes invalid", {
    result <- downloadFile_ValidateTypes(types = "csv")

    expect_equal(result, "csv")
})

test_that("downloadFile_ValidateTypes invalid", {
    expect_warning(downloadFile_ValidateTypes(types = "csv_invalid"), "file download list contains an invalid type <csv_invalid>")
})

test_that("downloadFile_AvailableTypes", {
    result <- downloadFile_AvailableTypes()

    expect_equal(result, c("csv", "xlsx", "tsv", "txt", "png", "jpeg", "tiff", "bmp"))
})

test_that("download_file", {
    session <- MockShinySession$new()
    session$env$filenameroot <-  "mydownload1"
    expect_silent(
        periscope:::download_file(
            input = list(),
            output = list(), 
            session = session,
            logger = periscope:::fw_get_user_log(),
            filenameroot = "mydownload1",
            datafxns = list(csv   = download_data,
                            xlsx  = download_data,
                            tsv   = download_data,
                            txt   = download_data,
                            png   = download_plot,
                            jpeg  = download_plot,
                            tiff  = download_plot,
                            bmp   = download_plot))
    )
    
})

test_that("downloadFile_callModule", {
    session <- MockShinySession$new()
    session$env$filenameroot <-  "mydownload1"
    session$env$datafxns = list(csv   = download_data,
                                 xlsx  = download_data,
                                 tsv   = download_data,
                                 txt   = download_data,
                                 png   = download_plot,
                                 jpeg  = download_plot,
                                 tiff  = download_plot,
                                 bmp   = download_plot)
    expect_silent(shiny::callModule(downloadFile,
                                    "download",
                                    input = list(),
                                    output = list(), 
                                    session = session,
                                    logger = periscope:::fw_get_user_log(),
                                    filenameroot = "mydownload1",
                                    datafxns = list(csv   = download_data,
                                                    xlsx  = download_data,
                                                    tsv   = download_data,
                                                    txt   = download_data,
                                                    png   = download_plot,
                                                    jpeg  = download_plot,
                                                    tiff  = download_plot,
                                                    bmp   = download_plot)))
})
