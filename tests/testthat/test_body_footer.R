context("periscope - Body footer")
# Helper functions
data <- function(){
    c("line 1", "line 2", "line 3")
}

data2 <- function(){
    NULL
}

# UI unit tests
test_that(".bodyFooterOutput", {
    local_edition(3)
    expect_snapshot_output(.bodyFooterOutput("myid"))
})


# Server unit tests
test_that(".bodyFooter", {
    footer <- shiny::callModule(.bodyFooter, "footer", input = list(),
                                output = list(), 
                                session = MockShinySession$new(),
                                logdata = data)
    expect_equal(class(footer)[[1]], "shiny.render.function")
})

test_that("body_footer ", {
    expect_silent(body_footer(input = list(),
                              output = list(), 
                              session = MockShinySession$new(),
                              logdata = data))
    
    expect_silent(body_footer(input = list(),
                              output = list(), 
                              session = MockShinySession$new(),
                              logdata = data2))
})
