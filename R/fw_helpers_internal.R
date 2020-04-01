# FRAMEWORK HELPER FUNCTIONS -------
# -- (INTERNAL ONLY - No Exports) --

.g_sidebar_default_value <- c()

# .g_opts --------------------
# holds the app options values
.g_opts <- shiny::reactiveValues(
    tt_image           = "img/tooltip.png",
    tt_height          = "16px",
    tt_width           = "16px",
    datetime.fmt       = "%m-%d-%Y %H:%M",
    log.formatter      = function(record) { paste0(record$logger,
                                                   " [", record$timestamp, "] ",
                                                   record$msg) },
    loglevel            = "DEBUG",
    app_title           = "Set using set_app_parameters() in program/global.R",
    app_info            = NULL,
    app_version         = "1.0.0",
    data_download_types = c("csv", "xlsx", "tsv", "txt"),
    plot_download_types = c("png", "jpeg", "tiff", "bmp"),
    reset_button        = TRUE,
    reset_wait          = 5000,  #milliseconds
    show_userlog        = TRUE,
    body_elements       = c(),
    show_left_sidebar   = TRUE,
    side_basic          = .g_sidebar_default_value,
    side_basic_label    = "Basic",
    side_advanced       = .g_sidebar_default_value,
    side_advanced_label = "Advanced",
    sidebar_right_icon  = "gears"
)

# reset app options
.reset_app_options <- function() {
    .g_opts$side_basic    <- .g_sidebar_default_value
    .g_opts$side_advanced <- .g_sidebar_default_value
}


# UI ----------------------------
# Creates the tags and JS for the processing image and text in the header
.header_injection <- function() {
    app_info  <- shiny::isolate(.g_opts$app_info)
    app_title <- shiny::isolate(.g_opts$app_title)

    items <- list(shiny::tags$script(
        shiny::HTML(
            "$(\"<div class='periscope-title'>",
            ifelse(is.null(app_info),
                   app_title,
                   ifelse(class(app_info)[1] == "html",
                          paste("<a id='titleinfobox_trigger' href='#'>",
                                app_title, "</a>"),
                          paste("<a href='", app_info,
                                "' target = '_blank'>",
                                app_title, "</a>"))),
            "</div>\").insertAfter($(\"a.sidebar-toggle\"));")))
    return(items)
}

.right_sidebar_injection <- function() {
    shiny::tags$script(shiny::HTML("setTimeout(function() {
                                        $('[class~=\"control-sidebar-tabs\"]').find('li:first').remove();
                                   }, 5000);"))
}

.remove_sidebar_toggle <- function() {
    shiny::tags$script(shiny::HTML("$('[class~=\"sidebar-toggle\"]').remove();
                                    $('[class~=\"logo\"]').css('background-color', '#3c8dbc');"))
}

# Returns the custom css as HTML
.framework_css <- function() {
    return( shiny::HTML("
            /* Sidebar */
                .sidebar .periscope-input-label-with-tt {
                    margin: 5px;
                    font-weight: bold;
                }
                .tab-content {
                    padding-top: 5px;
                    margin: 5px;
                }
                .notab-content {
                    padding-top: 5px;
                    margin: 5px;
                }
                section.sidebar .shiny-input-container {
                    padding: 0;
                    margin: 5px;
                    width: 95%;
                }
                .form-group {
                    margin-bottom: 10px;
                }

                /*.main-sidebar { background-color: #3380A9 !important; } */

            /* Header */
                .main-header {
                    position: fixed;
                    width: 100%;
                }

                .main-header .logo {
                    padding: 0;
                }

                .main-header .periscope-busy-ind {
                    display: block;
                    text-align: center;
                    line-height: 50px;
                    font-size: medium;
                    color: white;
                }
                .main-header .periscope-title {
                    text-align: center;
                    line-height: 50px;
                    font-size: x-large;
                    color: white;
                    width: 80%;
                    float:left;
                }
                .main-header .periscope-title a {
                    font-size: x-large;
                    color: white;
                }

                .content {
                    padding-top: 65px;
                }

                @media (max-width:767px) {
                    .content {
                        padding-top: 115px;
                    }
                }

            /* Other */
                .help-block {
                    padding: 12px 15px 0 12px;
                }
                .wrapper {
                    background-color: #ecf0f5 !important;
                }

            /* --- MODULES --- */

            /* Download Button */
                .periscope-download-btn { }
                .periscope-download-choice { }

            /* Downloadable Table */
                .periscope-downloadable-table { }
                .periscope-downloadable-table-header > div {
                    float: right;
                }
                .periscope-downloadable-table-button {
                    float: left;
                }
            /* Downloadable Plot */
                .periscope-downloadable-plot { }
                .periscope-downloadable-plot-button {
                position: relative;
                margin-left: 5px;
                margin-right: 5px;
                top: -39px;
                float: right;
                }
            "))
}

# Returns the custom js as HTML
.framework_js <- function() {
    app_title <- shiny::isolate(.g_opts$app_title)

    return(shiny::HTML(paste0("
        setInterval(
            function() {
                if ($('html').attr('class')=='shiny-busy') {
                    setTimeout(function() {
                        if ($('html').attr('class')=='shiny-busy') {
                            $('div.periscope-busy-ind').show();
                        }
                    }, 250);
                } else {
                    $('div.periscope-busy-ind').hide();
                }
            }, 100);

        document.title = '", app_title, "';

        Shiny.addCustomMessageHandler('downloadbutton_toggle',
            function(message) {
                if (Number(message.rows) > 0) {
                    $('#'.concat(message.btn)).show();
                } else {
                    $('#'.concat(message.btn)).hide();
                }
            }
        );
    ")) )
}


# Server ----------------------------

# Sets up the logging functionality including archiving out any existing log
# and attaching the file handler.  DEBUG will also attach a console handler.
# NOTE: only one previous log is kept (as <name>.loglast)
.setupUserLogging <- function(logger) {
    logdir    <- "log"
    logfile   <- paste0(paste(logdir, logger$name, sep = .Platform$file.sep),
                        ".log")
    formatter <- .g_opts$log.formatter
    loglevel  <- .g_opts$loglevel

    if (!dir.exists(logdir)) {
        dir.create(logdir)
    }

    if (file.exists(logfile)) {
        # archive out for now, keeping only one for now
        file.rename(logfile, paste(logfile, "last", sep = "."))
    }

    file.create(logfile)

    logging::addHandler(logging::writeToFile,
                        file = logfile,
                        level = loglevel,
                        logger = logger,
                        formatter = formatter)

    if (loglevel == "DEBUG") {
        logging::addHandler(logging::writeToConsole,
                            level = loglevel,
                            logger = logger,
                            formatter = formatter)
    }

    return(logfile)
}


.setup_logging <- function(session, logger) {
    return(
        shiny::reactiveFileReader(
            500, #milliseconds,
            session,
            .setupUserLogging(logger),
            readLines) )
}
