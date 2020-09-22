# Conversion functions for existing applications.


ui_filename                       <- "ui.R"
ui_no_sidebar_filename            <- "ui_no_sidebar.R"
ui_plus_filename                  <- "ui_plus.R"
ui_plus_no_sidebar_filename       <- "ui_plus_no_sidebar.R"
ui_left_sidebar_filename          <- "ui_sidebar.R"
ui_right_sidebar_filename         <- "ui_sidebar_right.R"
create_left_sidebar_expr          <- "fw_create_sidebar\\("
create_left_sidebar_closed_expr   <- "fw_create_sidebar\\(\\)"
no_reset_button_expr              <- "fw_create_sidebar\\(resetbutton = FALSE"
no_reset_button_closed_expr       <- "fw_create_sidebar\\(resetbutton = FALSE\\)"


# Checks if the location contains a periscope application.
.is_periscope_app <- function(location = ".") {
    result <- TRUE
    if (!all(file.exists(file.path(location, c("server.R", "ui.R", "global.R", "program"))))) {
        result <- FALSE
    }
    result
}

#' Add the left sidebar to an existing application.
#'
#' @param location path of the existing application.
#'
#' @export
add_left_sidebar <- function(location) {
    tryCatch({
        if (is.null(location) || location == "") {
            warning("Add left sidebar conversion could not proceed, location cannot be empty!")
        }
        else if (!dir.exists(location)) {
            warning("Add left sidebar conversion could not proceed, location=<", location, "> does not exist!")
        }
        else if (!.is_periscope_app(location)) {
            warning("Add left sidebar conversion could not proceed, location=<", location, "> does not contain a valid periscope application!")
        }
        else {
            usersep <- .Platform$file.sep
            
            files_updated <- c()
            ui_content           <- readLines(con = paste(location, ui_filename, sep = usersep))
            ui_content_formatted <- gsub(" ", "", ui_content)
            # update ui if needed
            if (any(grepl("showsidebar=FALSE", ui_content_formatted))) {
                if (any(grepl("fw_create_right_sidebar", ui_content_formatted))) {
                    new_ui_content <- readLines(con = system.file("fw_templ",  ui_plus_filename, package = "periscope"))
                } else {
                    new_ui_content <- readLines(con = system.file("fw_templ",  ui_filename, package = "periscope"))
                }
                if (any(grepl("resetbutton=FALSE", ui_content_formatted))) {
                    new_ui_content <- gsub(create_left_sidebar_closed_expr, no_reset_button_closed_expr, new_ui_content)    
                }
                writeLines(new_ui_content, con = paste(location, ui_filename, sep = usersep)) 
                
                # add left_sidebar file    
                writeLines(readLines(con = system.file("fw_templ",  "p_blank", ui_left_sidebar_filename, package = "periscope")), 
                           con = paste(location, "program", ui_left_sidebar_filename, sep = usersep))
                
                files_updated <- c(files_updated, c(ui_filename, ui_left_sidebar_filename))
            }
            if (length(files_updated) > 0) {
                message(paste("Add left sidebar conversion was successful. File(s) updated:",  paste(files_updated, collapse = ", ")))
            } else {
                message("Left sidebar already available, no conversion needed")  
            }
        }
    },
    warning = function(w) {
        warning(w$message, call. = FALSE)
    })
    invisible(NULL)
}

#' Add the right sidebar to an existing application.
#'
#' @param location path of the existing application.
#'
#' @export
add_right_sidebar <- function(location) {
    tryCatch({
        if (is.null(location) || location == "") {
            warning("Add right sidebar conversion could not proceed, location cannot be empty!")
        }
        else if (!dir.exists(location)) {
            warning("Add right sidebar conversion could not proceed, location=<", location, "> does not exist!")
        }
        else if (!.is_periscope_app(location)) {
            warning("Add right sidebar conversion could not proceed, location=<", location, "> does not contain a valid periscope application!")
        }
        else {
            usersep <- .Platform$file.sep
            
            files_updated <- c()
            # replace ui by ui_plus (take care of resetbutton!)
            ui_content <- gsub(" ", "", readLines(con = paste(location, ui_filename, sep = usersep)))
            # update ui if needed
            if (!any(grepl("fw_create_right_sidebar", ui_content))) {
                reset_button   <- TRUE
                new_ui_content <- ui_content
                if (any(grepl("resetbutton=FALSE", ui_content))) { 
                    reset_button <- FALSE 
                }
                if (!any(grepl("showsidebar=FALSE", ui_content))) { 
                    new_ui_content <- readLines(con = system.file("fw_templ", ui_plus_filename, package = "periscope"))
                    if (!reset_button) {
                        new_ui_content <- gsub(create_left_sidebar_closed_expr, no_reset_button_closed_expr, new_ui_content)
                    }
                } else {
                    new_ui_content <- readLines(con = system.file("fw_templ", ui_plus_no_sidebar_filename, package = "periscope"))
                    if (!reset_button) {
                        new_ui_content <- gsub(create_left_sidebar_closed_expr, no_reset_button_closed_expr, new_ui_content)
                    }
                }
                writeLines(new_ui_content, con = paste(location, ui_filename, sep = usersep))   
                
                # add right_sidebar file    
                writeLines(readLines(con = system.file("fw_templ",  "p_blank", ui_right_sidebar_filename, package = "periscope")), 
                           con = paste(location, "program", ui_right_sidebar_filename, sep = usersep))
                
                files_updated <- c(files_updated, c(ui_filename, ui_right_sidebar_filename))
            }
            
            if (length(files_updated) > 0) {
                message(paste("Add right sidebar conversion was successful. File(s) updated:",  paste(files_updated, collapse = ", ")))
            } else {
                message("Right sidebar already available, no conversion needed")  
            }
        }
    },
    warning = function(w) {
        warning(w$message, call. = FALSE)
    })
    invisible(NULL)
}

#' Remove the reset button from an existing application.
#'
#' @param location path of the existing application.
#'
#' @export
remove_reset_button <- function(location) {
    tryCatch({
        if (is.null(location) || location == "") {
            warning("Remove reset button conversion could not proceed, location cannot be empty!")
        }
        else if (!dir.exists(location)) {
            warning("Remove reset button conversion could not proceed, location=<", location, "> does not exist!")
        }
        else if (!.is_periscope_app(location)) {
            warning("Remove reset button conversion could not proceed, location=<", location, "> does not contain a valid periscope application!")
        }
        else {
            usersep <- .Platform$file.sep
            
            files_updated <- c()
            ui_content <- readLines(con = paste(location, ui_filename, sep = usersep))
            ui_content_formatted <- gsub(" ", "", ui_content)
            # update ui if needed
            if (!any(grepl("resetbutton=FALSE", ui_content_formatted))) {
                if (any(grepl("showsidebar=FALSE", ui_content_formatted))) { 
                    message("Left sidebar not available, reset button cannot be removed")  
                } else {
                    new_ui_content <- gsub(create_left_sidebar_expr, no_reset_button_expr, ui_content)
                    writeLines(new_ui_content, 
                               con = paste(location, ui_filename, sep = usersep))
                    files_updated <- c(files_updated, ui_filename)
                    message(paste("Remove reset button conversion was successful. File(s) updated:",  paste(files_updated, collapse = ",")))
                }
            } else {
                message("Reset button already removed, no conversion needed")  
            }
        }
    },
    warning = function(w) {
        warning(w$message, call. = FALSE)
    })
    invisible(NULL)
}

#' Add the reset button to an existing application.
#'
#' @param location path of the existing application.
#'
#' @export
add_reset_button <- function(location) {
    tryCatch({
        if (is.null(location) || location == "") {
            warning("Add reset button conversion could not proceed, location cannot be empty!")
        }
        else if (!dir.exists(location)) {
            warning("Add reset button conversion could not proceed, location=<", location, "> does not exist!")
        }
        else if (!.is_periscope_app(location)) {
            warning("Add reset button conversion could not proceed, location=<", location, "> does not contain a valid periscope application!")
        }
        else {
            usersep <- .Platform$file.sep
            
            files_updated <- c()
            ui_content           <- readLines(con = paste(location, ui_filename, sep = usersep))
            ui_content_formatted <- gsub(" ", "", ui_content)
            # update ui if needed
            if (any(grepl("resetbutton=FALSE", ui_content_formatted))) {
                if (any(grepl("showsidebar=FALSE", ui_content_formatted))) { 
                    message("Left sidebar is not available, please first run 'add_left_sidebar'")
                } else {
                    new_ui_content <- gsub(no_reset_button_expr, create_left_sidebar_expr, ui_content)
                    writeLines(new_ui_content, 
                               con = paste(location, ui_filename, sep = usersep))
                    files_updated <- c(files_updated, ui_filename)
                    message(paste("Add reset button conversion was successful. File(s) updated:",  paste(files_updated, collapse = ",")))
                }
            } else {
                if (any(grepl("showsidebar=FALSE", ui_content_formatted))) { 
                    message("Left sidebar is not available, please first run 'add_left_sidebar'")
                } else {
                    message("Reset button already available, no conversion needed")  
                }
            }
        }
    },
    warning = function(w) {
        warning(w$message, call. = FALSE)
    })
    invisible(NULL)
}
