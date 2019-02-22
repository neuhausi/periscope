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
.appReset <- function(input, output, session, logger) {
    shiny::observe({
        pending  <- shiny::isolate(input$resetPending)
        waittime <- shiny::isolate(.g_opts$reset_wait)

        if (is.null(pending)) {
            return() # there is no reset button on the UI for the app
        }

        if (input$resetButton && !(pending)) {
            # reset initially requested
            logging::logwarn(paste("Application Reset requested by user. ",
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
            logging::loginfo("Application Reset cancelled by user.",
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
            logging::logwarn("Application Reset", logger = logger)
            session$reload()
        }
    })
}
