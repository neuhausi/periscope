# -------------------------------------
# -- Application Reset Button Module --
# -- (Internal/Private Shiny Module) --
# -------------------------------------

# Module UI Function
.appResetButton <- function(id) {
    ns <- shiny::NS(id)

    shiny::div(align = "center",
               shinyBS::bsButton(ns("resetButton"),
                                 label  = "Reset Application",
                                 type   = "toggle",
                                 value  = FALSE,
                                 style  = "warning",
                                 size   = "small",
                                 width  = "90%",
                                 block  = TRUE),
               shiny::span(class = "invisible",
                           shinyBS::bsButton(ns("resetPending"),
                                             label  = NULL,
                                             type   = "toggle",
                                             value  = FALSE) )
    ) #div
}

# Module Server Function
.appReset <- function(..., logger) {
    call <- match.call()
    params <- list(...)
    param_index <- 1
    params_length <- length(params)
    old_style_call <- call[[1]] == "module" || "periscope" %in% as.character(call[[1]])
    
    if (old_style_call) {
        input   <- params[[param_index]]
        param_index <- param_index + 1
        output  <- params[[param_index]]
        param_index <- param_index + 1
        session <- params[[param_index]]
        param_index <- param_index + 1
    } else {
        id <- params[[param_index]]
        param_index <- param_index + 1
    }
    
    if (missing(logger) && params_length >= param_index) {
        logger <- params[[param_index]]
    }
    
    if (old_style_call) {
        app_reset(input, output, session, logger)
    }
    else {
        shiny::moduleServer(
            id,
            function(input, output, session) {
                app_reset(input, output, session, logger)
            })   
    }
}


app_reset <- function(input, output, session, logger) {
    shiny::observe({
        pending  <- shiny::isolate(input$resetPending)
        waittime <- shiny::isolate(.g_opts$reset_wait)
        
        if (is.null(pending)) {
            return() # there is no reset button on the UI for the app
        }
        
        if (input$resetButton && !(pending)) {
            # reset initially requested
            logwarn(paste("Application Reset requested by user. ",
                          "Resetting in ", (waittime / 1000),
                          "seconds."),
                    logger = logger)
            shinyBS::createAlert(
                session, "sidebarAdvancedAlert",
                style = "danger",
                content = paste("The application will be reset in",
                                (waittime / 1000),
                                "seconds if you do not cancel below."))
            shinyBS::updateButton(
                session,
                session$ns("resetButton"),
                label = "Cancel Application Reset",
                style = "danger")
            shinyBS::updateButton(
                session,
                session$ns("resetPending"),
                value = TRUE)
            shiny::invalidateLater(waittime, session)
        }
        else if (!input$resetButton && pending) {
            # reset cancelled by pushing the button again
            loginfo("Application Reset cancelled by user.",
                    logger = logger)
            
            shinyBS::createAlert(
                session, "sidebarAdvancedAlert",
                style = "success",
                content = "The application reset was canceled.")
            shinyBS::updateButton(
                session,
                session$ns("resetButton"),
                label = "Reset Application",
                style = "warning")
            shinyBS::updateButton(
                session,
                session$ns("resetPending"),
                value = FALSE)
        }
        else if (pending) {
            # reset timed out
            logwarn("Application Reset", logger = logger)
            session$reload()
        }
    })
    
} 
