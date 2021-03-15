context("periscope - App reset")

test_that(".appResetButton", {
    local_edition(3)
    expect_snapshot_output(.appResetButton("myid"))
})

test_that(".appReset - no reset button", {
    # there is no reset button on the UI for the app
    testServer(.appReset,
               {session$setInputs(resetPending = NULL)
                expect_silent(.appReset)})
})

test_that(".appReset - reset button - no pending", {
    # there is no reset button on the UI for the app
    suppressWarnings(testServer(.appReset,
               {session$setInputs(resetButton = TRUE, resetPending = FALSE)
                expect_silent(.appReset)}))
})

test_that(".appReset - no reset button - with pending", {
    # there is no reset button on the UI for the app
    suppressWarnings(testServer(.appReset,
               {session$setInputs(resetButton = FALSE, resetPending = TRUE)
                expect_silent(.appReset)}))
})

test_that(".appReset - reset button - with pending", {
    suppressWarnings(testServer(.appReset,
                                {session$setInputs(resetButton = TRUE, resetPending = TRUE)
                                 expect_silent(.appReset)}))
})

test_that(".appReset", {
    expect_silent(.appReset(input = list(resetButton = TRUE, resetPending = FALSE),
                            output = list(), 
                            session = MockShinySession$setInputs(resetButton = TRUE,
                                                                 resetPending = FALSE),
                            logger = periscope:::fw_get_user_log()))
})
