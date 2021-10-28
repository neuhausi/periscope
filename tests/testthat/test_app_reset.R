context("periscope - App reset")

test_that(".appResetButton", {
    local_edition(3)
    expect_snapshot_output(.appResetButton("myid"))
})

test_that("app_reset - no reset button", {
    testServer(app_reset,
               expr = {
                   session$setInputs(resetPending = NULL, logger = periscope:::fw_get_user_log())
                   expect_null(session$getReturned())
               })
})

test_that("app_reset - reset button - no pending", {
    expect_silent(app_reset(input = list(resetButton = TRUE, resetPending = FALSE),
                            output = list(),
                            session = MockShinySession$setInputs(resetButton = TRUE,
                                                                 resetPending = FALSE),
                            logger = periscope:::fw_get_user_log()))
})

test_that("app_reset - no reset button - with pending", {
    expect_silent(app_reset(input = list(resetButton = FALSE, resetPending = TRUE),
                            output = list(),
                            session = MockShinySession$setInputs(resetButton = TRUE,
                                                                 resetPending = FALSE),
                            logger = periscope:::fw_get_user_log()))
})

test_that("app_reset - reset button - with pending", {
    expect_silent(app_reset(input = list(resetButton = TRUE, resetPending = TRUE),
                            output = list(),
                            session = MockShinySession$setInputs(resetButton = TRUE,
                                                                 resetPending = FALSE),
                            logger = periscope:::fw_get_user_log()))
})

test_that("app_reset", {
    expect_silent(app_reset(input = list(resetButton = FALSE, resetPending = FALSE),
                            output = list(),
                            session = MockShinySession$setInputs(resetButton = TRUE,
                                                                 resetPending = FALSE),
                            logger = periscope:::fw_get_user_log()))
})

test_that(".appReset", {
    reset <- shiny::callModule(.appReset, 
                               "reset", 
                               input = list(),
                               output = list(), 
                               session = MockShinySession$new(),
                               periscope:::fw_get_user_log())
    expect_equal(class(reset)[[1]], "Observer")
    expect_equal(class(reset)[[2]], "R6")
})

test_that(".appReset - new call", {
    expect_error(.appReset("reset", 
                           input = list(),
                           output = list(), 
                           session = MockShinySession$new(),
                           logger = periscope:::fw_get_user_log()))
})
