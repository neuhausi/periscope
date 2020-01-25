# Conversion functions for existing applications.


ui_filename     <- "ui.R"
reset_button_expression    <- "fw_create_sidebar\\(resetbutton = FALSE\\)"
no_reset_button_expression <- "fw_create_sidebar\\(\\)"

# Checks if the location contains a periscope application.
.is_periscope_app <- function(location = ".") {
    result <- TRUE
    if (!all(file.exists(file.path(location, c("server.R", "ui.R", "global.R", "program"))))) {
        result <- FALSE
    }
    result
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
            # update ui if needed
            if (!any(grepl(reset_button_expression, ui_content))) {
                writeLines(gsub(no_reset_button_expression, reset_button_expression, ui_content), 
                           con = paste(location, ui_filename, sep = usersep))
                files_updated <- c(files_updated, ui_filename)
            }
            if (length(files_updated) > 0) {
                message(paste("Remove reset button conversion was successful. File(s) updated:",  paste(files_updated, collapse = ",")))
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
            ui_content <- readLines(con = paste(location, ui_filename, sep = usersep))
            # update ui if needed
            if (any(grepl(reset_button_expression, ui_content))) {
                writeLines(gsub(reset_button_expression, no_reset_button_expression, ui_content), 
                           con = paste(location, ui_filename, sep = usersep))
                files_updated <- c(files_updated, ui_filename)
            }
            if (length(files_updated) > 0) {
                message(paste("Add reset button conversion was successful. File(s) updated:",  paste(files_updated, collapse = ",")))
            } else {
                message("Reset button already available, no conversion needed")  
            }
        }
    },
    warning = function(w) {
        warning(w$message, call. = FALSE)
    })
    invisible(NULL)
}
