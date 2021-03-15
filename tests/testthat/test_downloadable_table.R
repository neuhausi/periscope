context("periscope - downloadable table")


test_that("downloadableTableUI", {
    local_edition(3)
    expect_snapshot_output(downloadableTableUI(id = "myid", 
                                               downloadtypes = c("csv"), 
                                               hovertext = "myHoverText"))
})

test_that("downloadableTable", {
    expect_error(downloadableTable(input = list(),
                                   output = list(), 
                                   session = MockShinySession$new(),
                                   logger = periscope:::fw_get_user_log(),
                                   filenameroot = "mydownload1",
                                   tabledata = NULL))
})
