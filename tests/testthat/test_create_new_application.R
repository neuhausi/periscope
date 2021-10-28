context("periscope create new application")

expect_cleanup_create_new_application <- function(fullname, sampleapp = FALSE, dashboard_plus = FALSE, leftsidebar = TRUE) {
    local_edition(3)
    expect_true(dir.exists(fullname))
    expect_true(file.exists(paste0(fullname, "/global.R")))
    expect_true(file.exists(paste0(fullname, "/server.R")))
    expect_true(file.exists(paste0(fullname, "/ui.R")))
    expect_true(dir.exists(paste0(fullname, "/www")))
    expect_true(dir.exists(paste0(fullname, "/www/css")))
    expect_true(dir.exists(paste0(fullname, "/www/js")))
    expect_true(file.exists(paste0(fullname, "/www/periscope_style.yaml")))
    expect_true(dir.exists(paste0(fullname, "/www/img")))
    expect_true(file.exists(paste0(fullname, "/www/img/loader.gif")))
    expect_true(file.exists(paste0(fullname, "/www/img/tooltip.png")))
    expect_true(dir.exists(paste0(fullname, "/program")))
    expect_true(file.exists(paste0(fullname, "/program/global.R")))
    expect_true(file.exists(paste0(fullname, "/program/server_global.R")))
    expect_true(file.exists(paste0(fullname, "/program/server_local.R")))
    expect_true(file.exists(paste0(fullname, "/program/ui_body.R")))
    expect_true(dir.exists(paste0(fullname, "/program/data")))
    expect_true(dir.exists(paste0(fullname, "/program/fxn")))
    expect_true(dir.exists(paste0(fullname, "/log")))

    if (leftsidebar) {
        expect_true(file.exists(paste0(fullname, "/program/ui_sidebar.R")))
    } else {
        expect_true(!file.exists(paste0(fullname, "/program/ui_sidebar.R")))
    }
    
    if (sampleapp) {
        expect_true(file.exists(paste0(fullname, "/program/data/example.csv")))
        expect_true(file.exists(paste0(fullname, "/program/fxn/program_helpers.R")))
        expect_true(file.exists(paste0(fullname, "/program/fxn/plots.R")))
    }
    if (dashboard_plus) {
        expect_true(file.exists(paste0(fullname, "/program/ui_sidebar_right.R")))
    } else {
        expect_true(!file.exists(paste0(fullname, "/program/ui_sidebar_right.R")))
    }
    # clean up
    unlink(fullname, TRUE)
}

test_that("create_new_application", {
    appTemp.dir  <- tempdir()
    appTemp      <- tempfile(pattern = "TestThatApp", tmpdir = appTemp.dir)
    appTemp.name <- gsub('\\\\|/', '', (gsub(appTemp.dir, "", appTemp, fixed = T)))

    expect_message(create_new_application(name = appTemp.name, location = appTemp.dir, sampleapp = FALSE, rightsidebar = NULL), 
                   "Framework creation was successful.")
    expect_cleanup_create_new_application(appTemp)
})

test_that("create_new_application sample", {
    appTemp.dir  <- tempdir()
    appTemp      <- tempfile(pattern = "TestThatApp", tmpdir = appTemp.dir)
    appTemp.name <- gsub('\\\\|/', '', (gsub(appTemp.dir, "", appTemp, fixed = T)))
    
    expect_message(create_new_application(name = appTemp.name, location = appTemp.dir, sampleapp = TRUE, rightsidebar = NULL), 
                   "Framework creation was successful.")
    expect_cleanup_create_new_application(appTemp, sampleapp = TRUE)
})

test_that("create_new_application sample right_sidebar", {
    appTemp.dir   <- tempdir()
    appTemp       <- tempfile(pattern = "TestThatApp", tmpdir = appTemp.dir)
    appTemp.name  <- gsub('\\\\|/', '', (gsub(appTemp.dir, "", appTemp, fixed = T)))
    right_sidebar <- "gears"
    
    expect_message(create_new_application(name = appTemp.name, location = appTemp.dir, sampleapp = TRUE, rightsidebar = right_sidebar), 
                   "Framework creation was successful.")
    expect_cleanup_create_new_application(appTemp, sampleapp = TRUE, dashboard_plus = !is.null(right_sidebar))
    
    appTemp       <- tempfile(pattern = "TestThatApp", tmpdir = appTemp.dir)
    appTemp.name  <- gsub('\\\\|/', '', (gsub(appTemp.dir, "", appTemp, fixed = T)))
    
    expect_message(create_new_application(name = appTemp.name, location = appTemp.dir, sampleapp = TRUE, rightsidebar = TRUE), 
                   "Framework creation was successful.")
    expect_cleanup_create_new_application(appTemp, sampleapp = TRUE, dashboard_plus = TRUE)
    
    appTemp       <- tempfile(pattern = "TestThatApp", tmpdir = appTemp.dir)
    appTemp.name  <- gsub('\\\\|/', '', (gsub(appTemp.dir, "", appTemp, fixed = T)))
    
    expect_error(create_new_application(name = appTemp.name, location = appTemp.dir, sampleapp = TRUE, rightsidebar = 1), 
                 "Framework creation could not proceed, invalid type for rightsidebar, only logical or character allowed")
})

test_that("create_new_application sample right_sidebar without left_sidebar", {
    appTemp.dir   <- tempdir()
    appTemp       <- tempfile(pattern = "TestThatApp", tmpdir = appTemp.dir)
    appTemp.name  <- gsub('\\\\|/', '', (gsub(appTemp.dir, "", appTemp, fixed = T)))
    
    expect_message(create_new_application(name = appTemp.name, location = appTemp.dir, sampleapp = TRUE, rightsidebar = TRUE, leftsidebar = FALSE), 
                   "Framework creation was successful.")
    expect_cleanup_create_new_application(appTemp, sampleapp = TRUE, dashboard_plus = TRUE, leftsidebar = FALSE)
})

test_that("create_new_application sample invalid right_sidebar", {
    appTemp.dir   <- tempdir()
    appTemp       <- tempfile(pattern = "TestThatApp", tmpdir = appTemp.dir)
    appTemp.name  <- gsub('\\\\|/', '', (gsub(appTemp.dir, "", appTemp, fixed = T)))
    
    expect_error(create_new_application(name = appTemp.name, location = appTemp.dir, sampleapp = TRUE, rightsidebar = mtcars), 
                   "Framework creation could not proceed, invalid type for rightsidebar, only logical or character allowed")
})

test_that("create_new_application no left sidebar", {
    appTemp.dir   <- tempdir()
    appTemp       <- tempfile(pattern = "TestThatApp", tmpdir = appTemp.dir)
    appTemp.name  <- gsub('\\\\|/', '', (gsub(appTemp.dir, "", appTemp, fixed = T)))
    
    expect_message(create_new_application(name = appTemp.name, location = appTemp.dir, leftsidebar = FALSE), 
                   "Framework creation was successful.")
    expect_cleanup_create_new_application(appTemp, leftsidebar = FALSE)
})

test_that("create_new_application no reset button", {
    appTemp.dir   <- tempdir()
    appTemp       <- tempfile(pattern = "TestThatApp", tmpdir = appTemp.dir)
    appTemp.name  <- gsub('\\\\|/', '', (gsub(appTemp.dir, "", appTemp, fixed = T)))
    
    expect_message(create_new_application(name = appTemp.name, location = appTemp.dir, sampleapp = TRUE, resetbutton = FALSE), 
                   "Framework creation was successful.")
    expect_cleanup_create_new_application(appTemp, sampleapp = TRUE)
})

test_that("create_new_application no reset button, no left sidebar", {
    appTemp.dir   <- tempdir()
    appTemp       <- tempfile(pattern = "TestThatApp", tmpdir = appTemp.dir)
    appTemp.name  <- gsub('\\\\|/', '', (gsub(appTemp.dir, "", appTemp, fixed = T)))
    
    expect_message(create_new_application(name = appTemp.name, location = appTemp.dir, sampleapp = TRUE, resetbutton = FALSE, leftsidebar = FALSE), 
                   "Framework creation was successful.")
    expect_cleanup_create_new_application(appTemp, sampleapp = TRUE, leftsidebar = FALSE)
})


test_that("create_new_application invalid yaml file", {
    appTemp.dir  <- tempdir()
    appTemp      <- tempfile(pattern = "TestThatApp", tmpdir = appTemp.dir)
    appTemp.name <- gsub('\\\\|/', '', (gsub(appTemp.dir, "", appTemp, fixed = T)))
    
    expect_warning(create_new_application(name = appTemp.name, location = appTemp.dir, sampleapp = FALSE, rightsidebar = NULL, custom_theme_file = ""), 
                   "'custom_theme_file' must be single character value pointing to valid yaml file location. Using default values.")
})

test_that("create_new_application with valid yaml file", {
    appTemp.dir  <- tempdir()
    appTemp      <- tempfile(pattern = "TestThatApp", tmpdir = appTemp.dir)
    appTemp.name <- gsub('\\\\|/', '', (gsub(appTemp.dir, "", appTemp, fixed = T)))
    yaml_loc     <- "sample_app/www/periscope_style.yaml" 
    
    expect_message(create_new_application(name = appTemp.name, location = appTemp.dir, sampleapp = FALSE, rightsidebar = NULL, custom_theme_file = yaml_loc), 
                   "Framework creation was successful.")
})


test_that("create_new_application invalid location", {
    expect_warning(create_new_application(name = "Invalid", location = tempfile(), sampleapp = FALSE),
                   "Framework creation could not proceed, location=.* does not exist!")
})

test_that("create_new_application existing location", {
    appTemp.dir  <- tempdir()
    appTemp      <- tempfile(pattern = "TestThatApp", tmpdir = appTemp.dir)
    appTemp.name <- gsub('\\\\|/', '', (gsub(appTemp.dir, "", appTemp, fixed = T)))
    
    create_new_application(name = appTemp.name, location = appTemp.dir, sampleapp = FALSE)
    
    expect_warning(create_new_application(name = appTemp.name, location = appTemp.dir, sampleapp = FALSE),
                   paste0("Framework creation could not proceed, path=.* already exists!"))

    expect_cleanup_create_new_application(appTemp)
})
