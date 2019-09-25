context("periscope - downloadablePlot")

check_common_downloadablePlotUI_properties <- function(result.children) {
    expect_equal(length(result.children), 1)

    expect_equal(result.children[[1]]$name, "span")
    expect_type(result.children[[1]]$attribs, "list")

    result.subchildren <- result.children[[1]]$children
    expect_equal(length(result.subchildren), 2)

    expect_equal(result.subchildren[[1]]$name, "a")
    expect_equal(result.subchildren[[1]]$attribs, list(id = "myid-dplotButtonID-png", class = "btn btn-default shiny-download-link periscope-download-btn", href = "", target = "_blank", download = NA))

    result.subsubchildren <- result.subchildren[[1]]$children
    expect_equal(length(result.subsubchildren), 2)

    expect_equal(result.subsubchildren[[1]]$name, "i")
    expect_equal(result.subsubchildren[[1]]$attribs, list(class = "fa fa-download"))
    expect_equal(result.subsubchildren[[1]]$children, list())

    expect_equal(result.subsubchildren[[2]], NULL)

    expect_equal(result.subchildren[[2]]$name, "script")
    expect_type(result.subchildren[[2]]$attribs, "list")

    result.subsubchildren <- result.subchildren[[2]]$children
    expect_equal(length(result.subsubchildren), 1)
    expect_equal(result.subsubchildren[[1]], shiny::HTML("$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('myid-dplotButtonID-png', 'tooltip', {'placement': 'top', 'trigger': 'hover', 'title': 'myhovertext'})}, 500)});"))
}

test_that("downloadablePlotUI btn_overlap=true btn_halign=left btn_valign=bottom", {

    result <- downloadablePlotUI(id = "myid",
                                 downloadtypes      = c("png"),
                                 download_hovertext = "myhovertext",
                                 width              = "80%",
                                 height             = "300px",
                                 btn_halign         = "left",
                                 btn_valign         = "bottom",
                                 btn_overlap        = TRUE,
                                 clickOpts          = NULL,
                                 hoverOpts          = NULL,
                                 brushOpts          = NULL)

    expect_equal(result[[1]]$children, list())
    expect_equal(result[[1]]$name, "div")
    expect_equal(result[[1]]$attribs$id, "myid-dplotOutputID")
    expect_equal(result[[1]]$attribs$class, "shiny-plot-output")
    expect_equal(result[[1]]$attribs$style, "width: 80% ; height: 300px")

    expect_equal(result[[2]]$name, "span")

    expect_equal(result[[2]]$attribs$id, "myid-dplotButtonDiv")
    expect_equal(result[[2]]$attribs$class, "periscope-downloadable-plot-button")
    expect_equal(result[[2]]$attribs$style, "display:none; padding: 5px;float:left;top: -50px")

    check_common_downloadablePlotUI_properties(result[[2]]$children)
})

test_that("downloadablePlotUI btn_overlap=false btn_halign=center btn_valign=top", {

    result <- downloadablePlotUI(id = "myid",
                                 downloadtypes      = c("png"),
                                 download_hovertext = "myhovertext",
                                 width              = "80%",
                                 height             = "300px",
                                 btn_halign         = "center",
                                 btn_valign         = "top",
                                 btn_overlap        = FALSE,
                                 clickOpts          = NULL,
                                 hoverOpts          = NULL,
                                 brushOpts          = NULL)

    expect_equal(result[[1]]$name, "span")
    expect_equal(result[[1]]$attribs$id, "myid-dplotButtonDiv")
    expect_equal(result[[1]]$attribs$class, "periscope-downloadable-plot-button")
    expect_equal(result[[1]]$attribs$style, "display:none; padding: 5px;float:none;margin-left:45%;top: -5px")

    check_common_downloadablePlotUI_properties(result[[1]]$children)

    expect_equal(result[[2]]$name, "div")
    expect_equal(result[[2]]$attribs$id, "myid-dplotOutputID")
    expect_equal(result[[2]]$attribs$class, "shiny-plot-output")
    expect_equal(result[[2]]$attribs$style, "width: 80% ; height: 300px")

    result.children <- result[[2]]$children
    expect_equal(result.children, list())
})

test_that("downloadablePlotUI invalid btn_halign", {

    expect_warning(downloadablePlotUI(id = "myid",
                                      downloadtypes      = c("png"),
                                      download_hovertext = "myhovertext",
                                      width              = "80%",
                                      height             = "300px",
                                      btn_halign         = "bottom",
                                      btn_valign         = "top",
                                      btn_overlap        = FALSE,
                                      clickOpts          = NULL,
                                      hoverOpts          = NULL,
                                      brushOpts          = NULL),
                   "bottom  is not a valid btn_halign input - using default value. Valid values: <'left', 'center', 'right'>")
})

test_that("downloadablePlotUI invalid btn_valign", {

    expect_warning(downloadablePlotUI(id = "myid",
                                      downloadtypes      = c("png"),
                                      download_hovertext = "myhovertext",
                                      width              = "80%",
                                      height             = "300px",
                                      btn_halign         = "bottom",
                                      btn_valign         = "center",
                                      btn_overlap        = FALSE,
                                      clickOpts          = NULL,
                                      hoverOpts          = NULL,
                                      brushOpts          = NULL),
                   "center  is not a valid btn_valign input - using default value. Valid values: <'top', 'bottom'>")
})
