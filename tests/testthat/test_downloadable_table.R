context("periscope - downloadable table")

test_that("downloadableTable", {

    result <- downloadableTableUI(id = "myid", downloadtypes = c("csv"), hovertext = "myHoverText")

    expect_equal(class(result) , "list")
    expect_equal(length(result), 4)

    expect_equal(result[[1]]$name, "span")
    expect_equal(result[[1]]$attribs$id, "myid-dtableButtonDiv")
    expect_equal(result[[1]]$attribs$class, "periscope-downloadable-table-button")
    expect_equal(result[[1]]$attribs$style, "display:none")

    expect_equal(result[[2]][[1]]$name, "div")
    expect_equal(result[[2]][[1]]$attribs$id, "myid-dtableOutputID")
    expect_equal(result[[2]][[1]]$attribs$style, "width:100%; height:auto; ")
    expect_equal(result[[2]][[1]]$attribs$class, "datatables html-widget html-widget-output")

    expect_equal(result[[3]]$name, "input")
    expect_equal(result[[3]]$attribs$id, "myid-dtableOutputHeight")
    expect_equal(result[[3]]$attribs$type, "text")
    expect_equal(result[[3]]$attribs$class, "shiny-input-container hidden")
    expect_equal(result[[3]]$attribs$value, "200px")

    expect_equal(result[[4]]$name, "input")
    expect_equal(result[[4]]$attribs$id, "myid-dtableSingleSelect")
    expect_equal(result[[4]]$attribs$type, "text")
    expect_equal(result[[4]]$attribs$class, "shiny-input-container hidden")
    expect_equal(result[[4]]$attribs$value, FALSE)
})

