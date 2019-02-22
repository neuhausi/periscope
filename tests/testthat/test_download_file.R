context("periscope - download file")

test_that("downloadFileButton", {

    result <- downloadFileButton(id = "myid", downloadtypes = c("csv"), hovertext = "myhovertext")

    expect_equal(result$name, "span")
    expect_equal(result$attribs, list())

    result.children <- result$children
    expect_equal(length(result.children), 2)

    expect_equal(result.children[[1]]$name, "a")
    expect_equal(result.children[[1]]$attribs$id, "myid-csv")
    expect_equal(result.children[[1]]$attribs$class, "btn btn-default shiny-download-link periscope-download-btn")
    expect_equal(result.children[[1]]$attribs$target, "_blank")
    expect_equal(result.children[[1]]$attribs$download, NA)

    expect_equal(result.children[[2]]$name, "script")
    expect_equal(result.children[[2]]$attribs, list())
    expect_equal(length(result.children[[2]]$children), 1)
    expect_equal(result$children[[2]]$children[[1]], shiny::HTML("$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('myid-csv', 'tooltip', {'placement': 'top', 'trigger': 'hover', 'title': 'myhovertext'})}, 500)});"))
})

test_that("downloadFileButton multiple types", {

    result <- downloadFileButton(id = "myid", downloadtypes = c("csv", "tsv"), hovertext = "myhovertext")

    expect_equal(result$name, "span")
    expect_equal(result$attribs, list(class = "btn-group"))

    result.children <- result$children
    expect_equal(length(result.children), 3)

    expect_equal(result.children[[1]]$name, "button")
    expect_equal(result.children[[1]]$attribs$id, "myid-downloadFileList")
    expect_equal(result.children[[1]]$attribs$type, "button")
    expect_equal(result.children[[1]]$attribs$class, "btn btn-default action-button")
    expect_equal(result.children[[1]]$attribs$'data-toggle', "dropdown")
    expect_equal(result.children[[1]]$attribs$'aria-haspopup', "true")
    expect_equal(result.children[[1]]$attribs$'aria-expanded', "false")

    expect_equal(result.children[[2]]$name, "ul")
    expect_equal(result.children[[2]]$attribs$class, "dropdown-menu")
    expect_equal(result.children[[2]]$attribs$id, "myid-testList")

    result.subchilds <- result$children[[2]]$children
    expect_equal(length(result.subchilds), 1)

    result.subsubchilds <- result.subchilds[[1]][[1]]
    expect_equal(length(result.subsubchilds), 2)

    expect_equal(length(result.subsubchilds[[1]]), 2)
    expect_equal(result.subsubchilds[[1]][[1]], list())

    expect_equal(result.subsubchilds[[1]][[2]]$name, "li")
    expect_equal(result.subsubchilds[[1]][[2]]$attribs, list())
    result.subsubsubchilds <- result.subsubchilds[[1]][[2]]$children
    expect_equal(length(result.subsubsubchilds), 1)

    expect_equal(result.subsubsubchilds[[1]]$name, "a")
    expect_equal(result.subsubsubchilds[[1]]$attribs$id, "myid-csv")
    expect_equal(result.subsubsubchilds[[1]]$attribs$class, "shiny-download-link periscope-download-choice")
    expect_equal(result.subsubsubchilds[[1]]$attribs$href, "")
    expect_equal(result.subsubsubchilds[[1]]$attribs$target, "_blank")
    expect_equal(result.subsubsubchilds[[1]]$attribs$download, NA)
    expect_equal(result.subsubsubchilds[[1]]$children[[1]], "csv")

    expect_equal(result.children[[3]]$name, "script")
    expect_equal(result.children[[3]]$attribs, list())
    expect_equal(length(result.children[[3]]$children), 1)
    expect_equal(result$children[[3]]$children[[1]], shiny::HTML("$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('myid-downloadFileList', 'tooltip', {'placement': 'top', 'trigger': 'hover', 'title': 'myhovertext'})}, 500)});"))
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
