# Conversion functions for existing applications.

ui_filename               <- "ui.R"
ui_plus_filename          <- "ui_plus.R"
ui_right_sidebar_filename <- "ui_sidebar_right.R"

# Checks if the location contains a periscope application.
.is_periscope_app <- function(location = ".") {
    result <- TRUE
    if (!all(file.exists(file.path(location, c("server.R", "ui.R", "global.R", "program"))))) {
        result <- FALSE
    }
    result
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
            # replace ui by ui_plus (take car of resetbutton!)
            ui_content <- readLines(con = paste(location, ui_filename, sep = usersep))
            # update ui if needed
            if (!any(grepl("shinydashboardPlus", ui_content))) {
                writeLines(readLines(con = system.file("fw_templ", ui_plus_filename, package = "periscope")), 
                           con = paste(location, ui_filename, sep = usersep))
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
