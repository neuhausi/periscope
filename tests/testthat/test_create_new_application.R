context("periscope create new application")


expect_cleanup_create_new_application <- function(sampleapp = FALSE) {

    expect_true(dir.exists("myname"))
    expect_true(file.exists("myname/global.R"))
    expect_true(file.exists("myname/server.R"))
    expect_true(file.exists("myname/ui.R"))
    expect_true(dir.exists("myname/www"))
    expect_true(dir.exists("myname/www/css"))
    expect_true(dir.exists("myname/www/js"))
    expect_true(dir.exists("myname/www/img"))
    expect_true(file.exists("myname/www/img/loader.gif"))
    expect_true(file.exists("myname/www/img/tooltip.png"))
    expect_true(dir.exists("myname/program"))
    expect_true(file.exists("myname/program/global.R"))
    expect_true(file.exists("myname/program/server_global.R"))
    expect_true(file.exists("myname/program/server_local.R"))
    expect_true(file.exists("myname/program/ui_body.R"))
    expect_true(file.exists("myname/program/ui_sidebar.R"))
    expect_true(dir.exists("myname/program/data"))
    expect_true(dir.exists("myname/program/fxn"))
    expect_true(dir.exists("myname/log"))

    if (sampleapp) {
        expect_true(file.exists("myname/program/data/example.csv"))
        expect_true(file.exists("myname/program/fxn/program_helpers.R"))
        expect_true(file.exists("myname/program/fxn/plots.R"))
    }

    # clean up
    unlink("myname", TRUE)
}

test_that("create_new_application", {

    expect_message(create_new_application(name = "myname", location = ".", sampleapp = FALSE), "Framework creation was successful.")

    expect_cleanup_create_new_application()
})

test_that("create_new_application sample", {

    expect_message(create_new_application(name = "myname", location = ".", sampleapp = TRUE), "Framework creation was successful.")

    expect_cleanup_create_new_application(sampleapp = TRUE)
})

test_that("create_new_application invalid location", {
    expect_warning(create_new_application(name = "myname", location = "invalid", sampleapp = FALSE),
                   "Framework creation could not proceed, location=<invalid> does not exist!")
})

test_that("create_new_application existing location", {
    expect_warning(create_new_application(name = "testthat", location = "..", sampleapp = FALSE),
                   "Framework creation could not proceed, path=<../testthat> already exists!")
})
