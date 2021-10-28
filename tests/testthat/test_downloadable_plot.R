context("periscope - downloadablePlot")

test_that("downloadablePlotUI btn_overlap=true btn_halign=left btn_valign=bottom", {
    local_edition(3)
    expect_snapshot_output(downloadablePlotUI(id = "myid",
                                              downloadtypes      = c("png"),
                                              download_hovertext = "myhovertext",
                                              width              = "80%",
                                              height             = "300px",
                                              btn_halign         = "left",
                                              btn_valign         = "bottom",
                                              btn_overlap        = TRUE,
                                              clickOpts          = NULL,
                                              hoverOpts          = NULL,
                                              brushOpts          = NULL))
})

test_that("downloadablePlotUI btn_overlap=false btn_halign=center btn_valign=top", {
    local_edition(3)
    expect_snapshot_output(downloadablePlotUI(id = "myid",
                                 downloadtypes      = c("png"),
                                 download_hovertext = "myhovertext",
                                 width              = "80%",
                                 height             = "300px",
                                 btn_halign         = "center",
                                 btn_valign         = "top",
                                 btn_overlap        = FALSE,
                                 clickOpts          = NULL,
                                 hoverOpts          = NULL,
                                 brushOpts          = NULL))
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

test_that("downloadablePlot", {
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
    
    expect_silent(shiny::callModule(downloadablePlot,
                                   "download",
                                   input = list(),
                                   output = list(), 
                                   session = MockShinySession$new(),
                                   logger = periscope:::fw_get_user_log(),
                                   filenameroot = "mydownload1",
                                   aspectratio  = 2,
                                   downloadfxns = list(png  = download_plot,
                                                       tiff = download_plot,
                                                       txt  = download_data,
                                                       tsv  = download_data),
                                   visibleplot = download_plot))
})
