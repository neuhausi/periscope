context("periscope create new application")

appTemp.dir  <- tempdir()
appTemp.name <- 'testThatApp'
appTemp      <- paste(appTemp.dir, appTemp.name, sep = .Platform$file.sep)

expect_cleanup_create_new_application <- function(sampleapp = FALSE) {

    expect_true(dir.exists(appTemp))
    expect_true(file.exists(paste0(appTemp, "/global.R")))
    expect_true(file.exists(paste0(appTemp, "/server.R")))
    expect_true(file.exists(paste0(appTemp, "/ui.R")))
    expect_true(dir.exists(paste0(appTemp, "/www")))
    expect_true(dir.exists(paste0(appTemp, "/www/css")))
    expect_true(dir.exists(paste0(appTemp, "/www/js")))
    expect_true(dir.exists(paste0(appTemp, "/www/img")))
    expect_true(file.exists(paste0(appTemp, "/www/img/loader.gif")))
    expect_true(file.exists(paste0(appTemp, "/www/img/tooltip.png")))
    expect_true(dir.exists(paste0(appTemp, "/program")))
    expect_true(file.exists(paste0(appTemp, "/program/global.R")))
    expect_true(file.exists(paste0(appTemp, "/program/server_global.R")))
    expect_true(file.exists(paste0(appTemp, "/program/server_local.R")))
    expect_true(file.exists(paste0(appTemp, "/program/ui_body.R")))
    expect_true(file.exists(paste0(appTemp, "/program/ui_sidebar.R")))
    expect_true(dir.exists(paste0(appTemp, "/program/data")))
    expect_true(dir.exists(paste0(appTemp, "/program/fxn")))
    expect_true(dir.exists(paste0(appTemp, "/log")))

    if (sampleapp) {
        expect_true(file.exists(paste0(appTemp, "/program/data/example.csv")))
        expect_true(file.exists(paste0(appTemp, "/program/fxn/program_helpers.R")))
        expect_true(file.exists(paste0(appTemp, "/program/fxn/plots.R")))
    }

    # clean up
    unlink(appTemp, TRUE)
}

test_that("create_new_application", {

    expect_message(create_new_application(name = appTemp.name, location = appTemp.dir, sampleapp = FALSE), "Framework creation was successful.")

    expect_cleanup_create_new_application()
})

test_that("create_new_application sample", {

    expect_message(create_new_application(name = appTemp.name, location = appTemp.dir, sampleapp = TRUE), "Framework creation was successful.")

    expect_cleanup_create_new_application(sampleapp = TRUE)
})

test_that("create_new_application invalid location", {
    expect_warning(create_new_application(name = appTemp.name, location = "invalid", sampleapp = FALSE),
                   "Framework creation could not proceed, location=<invalid> does not exist!")
})

test_that("create_new_application existing location", {
    create_new_application(name = appTemp.name, location = appTemp.dir, sampleapp = FALSE)
    expect_warning(create_new_application(name = appTemp.name, location = appTemp.dir, sampleapp = FALSE),
                   paste0("Framework creation could not proceed, path=<", appTemp, "> already exists!"))
    expect_cleanup_create_new_application()
})
