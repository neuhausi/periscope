# FRAMEWORK HELPER FUNCTIONS ---------------------------------
# -- (Used in shiny with ::: but not exported as user fxns) --


# Framework Server Setup
fw_server_setup <- function(input, output, session, logger) {
    logfile <- shiny::isolate(.setup_logging(session, logger))
    .bodyFooter("footerId", logfile)
    if (shiny::isolate(.g_opts$reset_button)) {
        .appReset("appResetId", logger)
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
    getLogger(name = "actions")
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
    if (!(.g_sdp_installed)) {
        stop('shinydashboardPlus is not installed')
    }
    
    if (.g_sdp_oldver) {
        plus_fxn <- getExportedValue("shinydashboardPlus", "dashboardHeaderPlus")
        arg_list <- list(enable_rightsidebar = TRUE, 
                         rightSidebarIcon = sidebar_right_icon)
    } else {
        plus_fxn <- getExportedValue("shinydashboardPlus", "dashboardHeader")
        arg_list <- list(controlbarIcon = shiny::icon(sidebar_right_icon))
    }
    
    return(
        do.call(plus_fxn, args = c(list(
            title = shiny::div(class = "periscope-busy-ind",
                               "Working",
                               shiny::img(alt = "Working...",
                                          hspace = "5px",
                                          src = "img/loader.gif") ),
            titleWidth = shiny::isolate(.g_opts$sidebar_size)),
            arg_list)
        )
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
    if (!(.g_sdp_installed)) {
        stop('shinydashboardPlus is not installed')
    }
    
    side_right <- shiny::isolate(.g_opts$side_right)
    
    params <- list(shinyBS::bsAlert("sidebarRightAlert"))
    if (!is.null(side_right) && length(side_right) > 0) {
        params <- c(params, side_right)
    }
    
    if (.g_sdp_oldver) {
        plus_fxn <- getExportedValue("shinydashboardPlus", "rightSidebar")
    } else {
        plus_fxn <- getExportedValue("shinydashboardPlus", "dashboardControlbar")
    }

    return(do.call(plus_fxn, params))
}

# Framework UI Body Creation
fw_create_body <- function() {
    header_color_style          <- "$('.logo').css('background-color', $('.navbar').css('background-color'))"
    update_right_side_bar_width <- "$('.navbar-custom-menu').on('click',
                                           function() {
                                               main_width = $('.main-sidebar').css('width');
                                               if ($('.control-sidebar-open').length != 0) {
                                                   $('.control-sidebar-open').css('width', main_width);
                                                   $('.control-sidebar-bg').css('width', main_width);
                                                   $('.control-sidebar-bg').css('right', '0px' );
                                                   $('.control-sidebar').css('right', '0px');
                                               } else {
                                                  $('.control-sidebar-bg').css('right', '-' + main_width);
                                                  $('.control-sidebar').css('right', '-' +  main_width);
                                                  $('.control-sidebar').css('width', '-' +  main_width);
                                               }
                                           });"
                                           
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

    shinydashboard::dashboardBody(
        fresh::use_theme(create_theme()),
        shiny::tags$head(
            shiny::tags$style(.framework_css()),
            shiny::tags$script(.framework_js())),
        shiny::tags$script(update_right_side_bar_width),
        shiny::tags$script(header_color_style),
        info_content,
        shiny::isolate(.g_opts$body_elements),
        if (shiny::isolate(.g_opts$show_userlog)) {
            .bodyFooterOutput("footerId") 
        } else {
            NULL
        }
    )
    
}

create_theme <- function() {
    theme_settings            <- NULL
    primary_color             <- NULL
    sidebar_width             <- NULL
    sidebar_background_color  <- NULL
    sidebar_hover_color       <- NULL
    sidebar_text_color        <- NULL
    body_background_color     <- NULL
    box_color                 <- NULL
    infobox_color             <- NULL
    theme_colors_keys         <- c("primary_color", "sidebar_background_color", "sidebar_hover_color",
                                   "sidebar_text_color", "body_background_color", "box_color",
                                   "infobox_color")
    
    if (file.exists("www/periscope_style.yaml")) {
        theme_settings <- tryCatch({
            yaml::read_yaml("www/periscope_style.yaml")
        },
        error = function(e){
            warning("Could not parse 'periscope_style.yaml' due to: ", e$message)
            NULL
        })
        
        if (!is.null(theme_settings) && is.list(theme_settings)) {
            for (color in theme_colors_keys) {
                if (!is_valid_color(theme_settings[[color]])) {
                    warning(color, " has invalid color value. Setting default color.")
                    theme_settings[[color]] <- NULL
                }
            }
            
            primary_color            <- theme_settings[["primary_color"]]
            sidebar_width            <- theme_settings[["sidebar_width"]]
            sidebar_background_color <- theme_settings[["sidebar_background_color"]]
            sidebar_hover_color      <- theme_settings[["sidebar_hover_color"]]
            sidebar_text_color       <- theme_settings[["sidebar_text_color"]]
            body_background_color    <- theme_settings[["body_background_color"]]
            box_color                <- theme_settings[["box_color"]]
            infobox_color            <- theme_settings[["infobox_color"]]
            if (!is.null(sidebar_width)) {
                if (any(!is.numeric(sidebar_width), sidebar_width <= 0)) {
                    warning("'sidebar_width' must be positive value. Setting default value.")
                } else {
                    sidebar_width <- paste0(sidebar_width, "px")
                }
            }
        }
    }
    
    fresh::create_theme(
        fresh::adminlte_color(
            light_blue = primary_color
        ),
        fresh::adminlte_sidebar(
            width = sidebar_width,
            dark_bg = sidebar_background_color,
            dark_hover_bg = sidebar_hover_color,
            dark_color = sidebar_text_color
        ),
        fresh::adminlte_global(
            content_bg = body_background_color,
            box_bg = box_color, 
            info_box_bg = infobox_color
        )
    )
}

is_valid_color <- function(color) {
    tryCatch({
        grDevices::col2rgb(color)
        TRUE
    },
    error = function(e) {
        FALSE
    })
}
