context("periscope convert existing application")


expect_converted_application <- function(location, right_sidebar, reset_button) {
    expect_true(dir.exists(location))
    expect_true(file.exists(file.path(location, "global.R")))
    expect_true(file.exists(file.path(location, "server.R")))
    expect_true(file.exists(file.path(location, "ui.R")))
    expect_true(file.exists(file.path(location, "program")))
    expect_true(all.equal(readLines(file.path(location, "global.R")), readLines(system.file("fw_templ", "global.R", package = "periscope"))))
    expect_true(all.equal(readLines(file.path(location, "server.R")), readLines(system.file("fw_templ", "server.R", package = "periscope"))))
    
    ui_content <- readLines(con = paste(location, "ui.R", sep = .Platform$file.sep))
    if (right_sidebar) {
        expect_true(any(grepl("fw_create_right_sidebar", ui_content)))
    } else {
        expect_true(!any(grepl("fw_create_right_sidebar", ui_content)))   
    }
    if (reset_button) {
        expect_true(!any(grepl("resetbutton", ui_content)))
    } else {
        expect_true(any(grepl("resetbutton", ui_content)))   
    }
}

## add_right_sidebar tests 

test_that("add_right_sidebar null location", {
    expect_warning(add_right_sidebar(location = NULL),
                   "Add right sidebar conversion could not proceed, location cannot be empty!")
})

test_that("add_right_sidebar empty location", {
    expect_warning(add_right_sidebar(location = ""),
                   "Add right sidebar conversion could not proceed, location cannot be empty!")
})

test_that("add_right_sidebar invalid location", {
    expect_warning(add_right_sidebar(location = "invalid"),
                   "Add right sidebar conversion could not proceed, location=<invalid> does not exist!")
})

test_that("add_right_sidebar location does not contain an existing application", {
    expect_warning(add_right_sidebar(location = "../testthat"),
                   "Add right sidebar conversion could not proceed, location=<../testthat> does not contain a valid periscope application!")
})

test_that("add_right_sidebar valid location", {
    dir.create('myname')
    file.copy("sample_app", "myname", recursive = TRUE)
    app_location <- "myname/sample_app"
    
    expect_message(add_right_sidebar(location = app_location), "Add right sidebar conversion was successful. File\\(s\\) updated: ui.R")
    expect_converted_application(location = app_location, right_sidebar = TRUE, reset_button = TRUE)
    
    # clean up
    unlink("myname", TRUE)
})

test_that("add_right_sidebar valid location, added twice", {
    dir.create('myname')
    file.copy("sample_app", "myname", recursive = TRUE)
    app_location <- "myname/sample_app"
    
    expect_message(add_right_sidebar(location = app_location), "Add right sidebar conversion was successful. File\\(s\\) updated: ui.R")
    expect_message(add_right_sidebar(location = app_location), "Right sidebar already available, no conversion needed")
    expect_converted_application(location = app_location, right_sidebar = TRUE, reset_button = TRUE)
    
    # clean up
    unlink("myname", TRUE)
})
