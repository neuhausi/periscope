context("periscope - misc functions")

log_directory <- tempdir()

test_that("set_app_parameters", {
    result <- set_app_parameters(title = "application title", titleinfo = NULL, loglevel = "DEBUG", showlog = TRUE, app_version = "2.1.0")
    expect_null(result, "set_app_parameters")
})

test_that("get_url_parameters - NULL", {
    result <- get_url_parameters(NULL)
    expect_equal(result, list(), "get_url_parameters")
})

test_that("get_url_parameters", {
    fake_session <- list(clientData = list(url_search = "&test1=ABC&test2=123"))
    result <- get_url_parameters(fake_session)
    expect_equal(result, list(test1 = "ABC", test2 = "123"), "get_url_parameters")
})

test_that("fw_get_loglevel", {
    result <- periscope:::fw_get_loglevel()
    expect_equal(result, "DEBUG")
})

test_that("fw_get_title", {
    result <- periscope:::fw_get_title()
    expect_equal(result, "application title")
})

test_that("fw_get_version", {
    result <- periscope:::fw_get_version()
    expect_equal(result, "2.1.0")
})

test_that("fw_get_user_log", {
    result <- periscope:::fw_get_user_log()
    expect_equal(class(result)[1], "Logger")
})

test_that("setup_logging", {
    result <- shiny::isolate(.setup_logging(NULL, periscope:::fw_get_user_log()))
    expect_true(shiny::is.reactive(result))
})

test_that("setup_logging existing log", {
    logger <- periscope:::fw_get_user_log()
    file.create(paste0(paste(log_directory, logger$name, sep = .Platform$file.sep), ".log"))

    result <- shiny::isolate(.setup_logging(NULL, logger))
    expect_true(shiny::is.reactive(result))
})

test_that("fw_reset_app_options", {
    result <- periscope:::fw_reset_app_options()
    expect_null(result, "fw_reset_app_options")
})

test_that("fw_server_setup", {
    expect_error(fw_server_setup(input = list(),
                                   output = list(), 
                                   session = MockShinySession$new(),
                                   logger = periscope:::fw_get_user_log()))
})

# clean up
unlink("log", TRUE)
