# FRAMEWORK HELPER FUNCTIONS ---------------------------------
# -- (Used in shiny with ::: but not exported as user fxns) --


# Framework Server Setup
fw_server_setup <- function(input, output, session, logger) {
    logfile <- shiny::isolate(.setup_logging(session, logger))
    shiny::callModule(.bodyFooter, "footerId",   logfile)
    if (shiny::isolate(.g_opts$reset_button)) {
        shiny::callModule(.appReset, "appResetId", logger)
    }
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
            titleWidth = shiny::isolate(.g_opts$sidebar_size))
    )
}

# Framework UI Header Creation that includes a right sidebar
fw_create_header_plus <- function(sidebar_right_icon = shiny::isolate(.g_opts$sidebar_right_icon)) {
    return(
        shinydashboardPlus::dashboardHeaderPlus(
            title = shiny::div(class = "periscope-busy-ind",
                               "Working",
                               shiny::img(alt = "Working...",
                                          hspace = "5px",
                                          src = "img/loader.gif") ),
            titleWidth = shiny::isolate(.g_opts$sidebar_size),
            enable_rightsidebar = TRUE, rightSidebarIcon = sidebar_right_icon)
    )
}

# Framework UI Left Sidebar Creation
fw_create_sidebar <- function(showsidebar = shiny::isolate(.g_opts$show_left_sidebar), resetbutton = shiny::isolate(.g_opts$reset_button)) {
    result <- NULL
    if (showsidebar) {
        basic <- shiny::isolate(.g_opts$side_basic)
        adv   <- shiny::isolate(.g_opts$side_advanced)
        
        if (!is.null(adv) && length(adv) > 0 && resetbutton) {
            adv[[length(adv) + 1]] <- .appResetButton("appResetId")
        }
        result <- shinydashboard::dashboardSidebar(
                    width = shiny::isolate(.g_opts$sidebar_size),
                    .header_injection(),             #injected header elements
                    .right_sidebar_injection(),
                    if (!is.null(basic[[1]]) && !is.null(adv[[1]])) {
                        shiny::div(class = "tab-content",
                                   shiny::tabsetPanel(
                                       id = "Options",
                                       selected = shiny::isolate(.g_opts$side_basic_label),
                                       shiny::tabPanel(
                                           shiny::isolate(.g_opts$side_basic_label),
                                           basic),
                                       shiny::tabPanel(
                                           shiny::isolate(.g_opts$side_advanced_label),
                                           adv)))
                    }
                    else if (!is.null(basic[[1]]) && is.null(adv[[1]])) {
                        shiny::div(class = "notab-content",
                                   basic)
                    }
                    else if (is.null(basic[[1]]) && !is.null(adv[[1]])) {
                        shiny::div(class = "notab-content",
                                   adv)
                    })
    } else {
        result <- shinydashboard::dashboardSidebar(width = 0,
                                                   collapsed = TRUE,
                                                   .header_injection(),
                                                   .right_sidebar_injection(),
                                                   .remove_sidebar_toggle())
    }
    result
}

# Framework UI Right Sidebar Creation
fw_create_right_sidebar <- function() {
    side_right <- shiny::isolate(.g_opts$side_right)
    
    params <- list(background = "dark", shinyBS::bsAlert("sidebarRightAlert"))
    if (!is.null(side_right) && length(side_right) > 0) {
        for (element in side_right) {
            params <- append(params, list(element))
        }
    }
    return(do.call(shinydashboardPlus::rightSidebar, params))
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
                shiny::tags$script(.framework_js())),
            info_content,
            shiny::isolate(.g_opts$body_elements),
            if (shiny::isolate(.g_opts$show_userlog)) {
                .bodyFooterOutput("footerId") }
            else {NULL}
        )
    )
}
