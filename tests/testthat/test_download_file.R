context("periscope - download file")


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

test_that("downloadFile", {
    expect_silent(downloadFile(input = list(),
                               output = list(), 
                               session = MockShinySession$new(),
                               logger = periscope:::fw_get_user_log(),
                               filenameroot = "mydownload1"))
})
