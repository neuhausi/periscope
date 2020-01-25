context("periscope convert existing application")


expect_converted_application <- function(location, resetbutton) {
    expect_true(dir.exists(location))
    expect_true(file.exists(file.path(location, "global.R")))
    expect_true(file.exists(file.path(location, "server.R")))
    expect_true(file.exists(file.path(location, "ui.R")))
    expect_true(file.exists(file.path(location, "program")))
    expect_true(all.equal(readLines(file.path(location, "global.R")), readLines(system.file("fw_templ", "global.R", package = "periscope"))))
    expect_true(all.equal(readLines(file.path(location, "server.R")), readLines(system.file("fw_templ", "server.R", package = "periscope"))))
    
    ui_content <- readLines(con = paste(location, "ui.R", sep = .Platform$file.sep))
    if (resetbutton) {
        expect_true(!any(grepl("resetbutton", ui_content)))
    } else {
        expect_true(any(grepl("resetbutton", ui_content)))   
    }
}

## remove_reset_button tests 

test_that("remove_reset_button null location", {
    expect_warning(remove_reset_button(location = NULL),
                   "Remove reset button conversion could not proceed, location cannot be empty!")
})

test_that("remove_reset_button empty location", {
    expect_warning(remove_reset_button(location = ""),
                   "Remove reset button conversion could not proceed, location cannot be empty!")
})

test_that("remove_reset_button invalid location", {
    expect_warning(remove_reset_button(location = "invalid"),
                   "Remove reset button conversion could not proceed, location=<invalid> does not exist!")
})

test_that("remove_reset_button location does not contain an existing application", {
    expect_warning(remove_reset_button(location = "../testthat"),
                   "Remove reset button conversion could not proceed, location=<../testthat> does not contain a valid periscope application!")
})

test_that("remove_reset_button valid location", {
    dir.create('myname')
    file.copy("sample_app", "myname", recursive = TRUE)
    app_location <- "myname/sample_app"
    
    expect_message(remove_reset_button(location = app_location), "Remove reset button conversion was successful. File\\(s\\) updated: ui.R")
    expect_converted_application(location = app_location, resetbutton = FALSE)
    
    # clean up
    unlink("myname", TRUE)
})

test_that("remove_reset_button valid location, remove twice", {
    dir.create('myname')
    file.copy("sample_app", "myname", recursive = TRUE)
    app_location <- "myname/sample_app"
    
    expect_message(remove_reset_button(location = app_location), "Remove reset button conversion was successful. File\\(s\\) updated: ui.R")
    expect_message(remove_reset_button(location = app_location), "Reset button already removed, no conversion needed")
    
    # clean up
    unlink("myname", TRUE)
})

## add_reset_button tests

test_that("add_reset_button null location", {
    expect_warning(add_reset_button(location = NULL),
                   "Add reset button conversion could not proceed, location cannot be empty!")
})

test_that("add_reset_button empty location", {
    expect_warning(add_reset_button(location = ""),
                   "Add reset button conversion could not proceed, location cannot be empty!")
})

test_that("add_reset_button invalid location", {
    expect_warning(add_reset_button(location = "invalid"),
                   "Add reset button conversion could not proceed, location=<invalid> does not exist!")
})

test_that("add_reset_button location does not contain an existing application", {
    expect_warning(add_reset_button(location = "../testthat"),
                   "Add reset button conversion could not proceed, location=<../testthat> does not contain a valid periscope application!")
})

test_that("add_reset_button valid location, already available", {
    dir.create('myname')
    file.copy("sample_app", "myname", recursive = TRUE)
    app_location <- "myname/sample_app"
    
    expect_message(add_reset_button(location = app_location), "Reset button already available, no conversion needed")
    
    # clean up
    unlink("myname", TRUE)
})

test_that("add_reset_button valid location, not available yet", {
    dir.create('myname')
    file.copy("sample_app", "myname", recursive = TRUE)
    app_location <- "myname/sample_app"
    
    remove_reset_button(location = app_location)
    expect_message(add_reset_button(location = app_location), "Add reset button conversion was successful. File\\(s\\) updated: ui.R")
    expect_converted_application(location = app_location, resetbutton = TRUE)
    
    # clean up
    unlink("myname", TRUE)
})
