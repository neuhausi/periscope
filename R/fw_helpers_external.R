# FRAMEWORK HELPER FUNCTIONS ---------------------------------
# -- (Used in shiny with ::: but not exported as user fxns) --


# Framework Server Setup
fw_server_setup <- function(input, output, session, logger) {
    logfile <- shiny::isolate(.setup_logging(session, logger))
    shiny::callModule(.bodyFooter, "footerId",   logfile)
    shiny::callModule(.appReset,   "appResetId", logger)
}

# Reset app options
fw_reset_app_options <- function() {
    .reset_app_options()
}

# Get LogLevel
fw_get_loglevel <- function() {
    return(shiny::isolate(.g_opts$loglevel))
}

# Get Application Title
fw_get_title <- function() {
    return(shiny::isolate(.g_opts$app_title))
}

# Get Application Version
fw_get_version <- function() {
    return(shiny::isolate(.g_opts$app_version))
}

# Get User Action Log
fw_get_user_log <- function() {
    logging::getLogger(name = "actions")
}

# Framework UI Header Creation
fw_create_header <- function() {
    return(
        shinydashboard::dashboardHeader(
            title = shiny::div(class = "periscope-busy-ind",
                               "Working",
                               shiny::img(alt = "Working...",
                                          hspace = "5px",
                                          src = "img/loader.gif") ),
            titleWidth = shiny::isolate(.g_opts$sidebar_size) )
    )
}

# Framework UI Sidebar Creation
fw_create_sidebar <- function() {
    basic <- shiny::isolate(.g_opts$side_basic)
    adv   <- shiny::isolate(.g_opts$side_advanced)

    return(
        shinydashboard::dashboardSidebar(
            width = shiny::isolate(.g_opts$sidebar_size),
            .header_injection(),             #injected header elements
            if (!is.null(adv[[1]])) {
                shiny::div(class = "tab-content",
                    shiny::tabsetPanel(
                        id = "Options",
                        selected = shiny::isolate(.g_opts$side_basic_label),
                        shiny::tabPanel(
                            shiny::isolate(.g_opts$side_basic_label),
                            basic),
                        shiny::tabPanel(
                            shiny::isolate(.g_opts$side_advanced_label),
                            adv,
                            .appResetButton("appResetId"))) )
            }
            else {
                shiny::div(class = "notab-content",
                            basic)
            }
        ) )
}

# Framework UI Body Creation
fw_create_body <- function() {
    app_info <- shiny::isolate(.g_opts$app_info)
    info_content <- NULL

    if (!is.null(app_info) && (class(app_info)[1] == "html")) {
        info_content <- shinyBS::bsModal(
                id = "titleinfobox",
                title = shiny::isolate(.g_opts$app_title),
                trigger = "titleinfobox_trigger",
                size = "large",
                app_info)
    }

    return(
        shinydashboard::dashboardBody(
            shiny::tags$head(
                shiny::tags$style(.framework_css()),
                shiny::tags$script(.framework_js()) ),
            info_content,
            shiny::isolate(.g_opts$body_elements),
            if (shiny::isolate(.g_opts$show_userlog)) {
                .bodyFooterOutput("footerId") }
            else {NULL}
        )
    )
}
