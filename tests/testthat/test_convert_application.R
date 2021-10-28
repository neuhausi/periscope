context("periscope convert existing application")


expect_converted_application <- function(location, right_sidebar = NULL, reset_button = NULL, left_sidebar = NULL) {
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
    if (!is.null(left_sidebar)) {
        if (left_sidebar) {
            expect_true(file.exists(file.path(location, "program", "ui_sidebar.R")))
        } else {
            expect_true(!file.exists(file.path(location, "program", "ui_sidebar.R")))   
        }
        
    }
    # clean up
    unlink(location, TRUE)
}

# creates a temp directory, copies the sample_app to this directory and returns the path of the temp app
create_app_tmp_dir <- function(left_sidebar = TRUE, right_sidebar = FALSE, reset_button = TRUE) {
    app_name     <- "sample_app"
    
    if (left_sidebar && right_sidebar) {
        app_name <- "sample_app_both_sidebar"
    } else if (!left_sidebar && right_sidebar) {
        app_name <- "sample_app_r_sidebar"
    } else if (!left_sidebar && !right_sidebar) {
        app_name <- "sample_app_no_sidebar"
    }
    
    if (!reset_button && !left_sidebar && !right_sidebar) {
        app_name <- "sample_app_no_sidebar_no_resetbutton"
    }
    
    app_temp.dir <- tempdir()
    file.copy(app_name, app_temp.dir, recursive = TRUE)
    file.path(app_temp.dir, app_name)
}

## left_sidebar tests 

test_that("add_left_sidebar null location", {
    expect_warning(add_left_sidebar(location = NULL),
                   "Add left sidebar conversion could not proceed, location cannot be empty!")
})

test_that("add_left_sidebar empty location", {
    expect_warning(add_left_sidebar(location = ""),
                   "Add left sidebar conversion could not proceed, location cannot be empty!")
})

test_that("add_left_sidebar invalid location", {
    expect_warning(add_left_sidebar(location = "invalid"),
                   "Add left sidebar conversion could not proceed, location=<invalid> does not exist!")
})

test_that("add_left_sidebar location does not contain an existing application", {
    expect_warning(add_left_sidebar(location = "../testthat"),
                   "Add left sidebar conversion could not proceed, location=<../testthat> does not contain a valid periscope application!")
})

test_that("add_left_sidebar to r sidebar, valid location", {
    app_location <- create_app_tmp_dir(left_sidebar = FALSE, right_sidebar = TRUE)
    
    expect_message(add_left_sidebar(location = app_location), "Add left sidebar conversion was successful. File\\(s\\) updated: ui.R")
    expect_converted_application(location = app_location, left_sidebar = TRUE)
})

test_that("add_left_sidebar to no sidebars, valid location", {
    app_location <- create_app_tmp_dir(left_sidebar = FALSE, right_sidebar = FALSE)
    
    expect_message(add_left_sidebar(location = app_location), "Add left sidebar conversion was successful. File\\(s\\) updated: ui.R")
    expect_converted_application(location = app_location, left_sidebar = TRUE)
})

test_that("add_left_sidebar valid location, added twice", {
    app_location <- create_app_tmp_dir(left_sidebar = FALSE)
    
    expect_message(add_left_sidebar(location = app_location), "Add left sidebar conversion was successful. File\\(s\\) updated: ui.R")
    expect_message(add_left_sidebar(location = app_location), "Left sidebar already available, no conversion needed")
    expect_converted_application(location = app_location, left_sidebar = TRUE)
})

test_that("add_left_sidebar to no resetbutton, valid location", {
    app_location <- create_app_tmp_dir(left_sidebar = FALSE, right_sidebar = FALSE, reset_button = FALSE)
    
    expect_message(add_left_sidebar(location = app_location), "Add left sidebar conversion was successful. File\\(s\\) updated: ui.R")
    expect_converted_application(location = app_location, left_sidebar = TRUE)
})

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

test_that("add_right_sidebar to l sidebar", {
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

test_that("add_right_sidebar to no sidebars", {
    app_location <- create_app_tmp_dir(left_sidebar = FALSE)
    
    expect_message(add_right_sidebar(location = app_location), "Add right sidebar conversion was successful. File\\(s\\) updated: ui.R")
    expect_converted_application(location = app_location, right_sidebar = TRUE)
})

test_that("add_right_sidebar to r sidebar already present", {
    app_location <- create_app_tmp_dir(left_sidebar = FALSE, right_sidebar = TRUE)
    
    expect_message(add_right_sidebar(location = app_location), "Right sidebar already available, no conversion needed")
    expect_converted_application(location = app_location, right_sidebar = TRUE)
})

test_that("add_right_sidebar to no resetbutton", {
    app_location <- create_app_tmp_dir(left_sidebar = FALSE, right_sidebar = FALSE, reset_button = FALSE)
    
    expect_message(add_right_sidebar(location = app_location), "Add right sidebar conversion was successful. File\\(s\\) updated: ui.R")
    expect_converted_application(location = app_location, right_sidebar = TRUE)
})

test_that("add_right_sidebar to l sidebars, no resetbutton,", {
    app_location <- create_app_tmp_dir(left_sidebar = TRUE, right_sidebar = FALSE)
    expect_message(remove_reset_button(location = app_location), "Remove reset button conversion was successful. File\\(s\\) updated: ui.R")
    
    expect_message(add_right_sidebar(location = app_location), "Add right sidebar conversion was successful. File\\(s\\) updated: ui.R")
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

test_that("remove_reset_button left sidebar", {
    app_location <- create_app_tmp_dir()
    
    expect_message(remove_reset_button(location = app_location), "Remove reset button conversion was successful. File\\(s\\) updated: ui.R")
    expect_converted_application(location = app_location, reset_button = FALSE)
})

test_that("remove_reset_button valid location, remove twice", {
    app_location <- create_app_tmp_dir()
    
    expect_message(remove_reset_button(location = app_location), "Remove reset button conversion was successful. File\\(s\\) updated: ui.R")
    expect_message(remove_reset_button(location = app_location), "Reset button already removed, no conversion needed")
})

test_that("remove_reset_button both sidebar", {
    app_location <- create_app_tmp_dir(left_sidebar = TRUE, right_sidebar = TRUE)
    
    expect_message(remove_reset_button(location = app_location), "Remove reset button conversion was successful. File\\(s\\) updated: ui.R")
    expect_converted_application(location = app_location, reset_button = FALSE)
})

test_that("remove_reset_button r sidebar", {
    app_location <- create_app_tmp_dir(left_sidebar = FALSE, right_sidebar = TRUE)
    
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

test_that("add_reset_button no left sidebar, right sidebar", {
    app_location <- create_app_tmp_dir(left_sidebar = FALSE, right_sidebar = TRUE)
    
    expect_message(add_reset_button(location = app_location), "Left sidebar is not available, please first run 'add_left_sidebar'")
})

test_that("add_reset_button no sidebars, no resetbutton", {
    app_location <- create_app_tmp_dir(left_sidebar = FALSE, right_sidebar = FALSE, reset_button = FALSE)
    
    expect_message(add_reset_button(location = app_location), "Left sidebar is not available, please first run 'add_left_sidebar'")
})
