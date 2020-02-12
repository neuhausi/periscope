context("periscope convert existing application")


expect_converted_application <- function(location, right_sidebar = NULL, reset_button = NULL) {
    expect_true(dir.exists(location))
    expect_true(file.exists(file.path(location, "global.R")))
    expect_true(file.exists(file.path(location, "server.R")))
    expect_true(file.exists(file.path(location, "ui.R")))
    expect_true(file.exists(file.path(location, "program")))
    expect_true(all.equal(readLines(file.path(location, "global.R")), readLines(system.file("fw_templ", "global.R", package = "periscope"))))
    expect_true(all.equal(readLines(file.path(location, "server.R")), readLines(system.file("fw_templ", "server.R", package = "periscope"))))
    
    ui_content <- readLines(con = paste(location, "ui.R", sep = .Platform$file.sep))
    
    if (!is.null(right_sidebar)) { 
        if (right_sidebar) {
            expect_true(any(grepl("fw_create_right_sidebar", ui_content)))
        } else {
            expect_true(!any(grepl("fw_create_right_sidebar", ui_content)))   
        }
    }
    
    if (!is.null(reset_button)) {
        if (reset_button) {
            expect_true(!any(grepl("resetbutton", ui_content)))
        } else {
            expect_true(any(grepl("resetbutton", ui_content)))   
        }
    }
    # clean up
    unlink(location, TRUE)
}

# creates a temp directory, copies the sample_app to this directory and returns the path of the temp app
create_app_tmp_dir <- function() {
    app_name     <- "sample_app"
    app_temp.dir <- tempdir()
    file.copy(app_name, app_temp.dir, recursive = TRUE)
    file.path(app_temp.dir, app_name)
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
    app_location <- create_app_tmp_dir()
    
    expect_message(add_right_sidebar(location = app_location), "Add right sidebar conversion was successful. File\\(s\\) updated: ui.R")
    expect_converted_application(location = app_location, right_sidebar = TRUE)
})

test_that("add_right_sidebar valid location, added twice", {
    app_location <- create_app_tmp_dir()
    
    expect_message(add_right_sidebar(location = app_location), "Add right sidebar conversion was successful. File\\(s\\) updated: ui.R")
    expect_message(add_right_sidebar(location = app_location), "Right sidebar already available, no conversion needed")
    expect_converted_application(location = app_location, right_sidebar = TRUE)
})


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
    app_location <- create_app_tmp_dir()
    
    expect_message(remove_reset_button(location = app_location), "Remove reset button conversion was successful. File\\(s\\) updated: ui.R")
    expect_converted_application(location = app_location, reset_button = FALSE)
})

test_that("remove_reset_button valid location, remove twice", {
    app_location <- create_app_tmp_dir()
    
    expect_message(remove_reset_button(location = app_location), "Remove reset button conversion was successful. File\\(s\\) updated: ui.R")
    expect_message(remove_reset_button(location = app_location), "Reset button already removed, no conversion needed")
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
    app_location <- create_app_tmp_dir()
    
    expect_message(add_reset_button(location = app_location), "Reset button already available, no conversion needed")
})

test_that("add_reset_button valid location, not available yet", {
    app_location <- create_app_tmp_dir()
    
    remove_reset_button(location = app_location)
    expect_message(add_reset_button(location = app_location), "Add reset button conversion was successful. File\\(s\\) updated: ui.R")
    expect_converted_application(location = app_location, reset_button = TRUE)
})
