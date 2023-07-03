require(testthat)
require(shiny)
require(periscope)
require(shinydashboardPlus)
require(ggplot2)

if (interactive()) {
    test_source_path <- "periscope/R"
    invisible(
        lapply(list.files(test_source_path), 
               FUN = function(x) source(file.path(test_source_path, x))))
    rm(test_source_path)
}

# indicator for shinydashboardPlus version
t_sdp_old <- utils::packageVersion('shinydashboardPlus') < "2"
