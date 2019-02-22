# helper functions for tests
library(shiny)

source_path <- "periscope/R"

if (interactive()) {
    library(testthat)
    library(periscope)

    invisible(lapply(list.files(source_path), FUN = function(x) source(file.path(source_path, x))))
}
