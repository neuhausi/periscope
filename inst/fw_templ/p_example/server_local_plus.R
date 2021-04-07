# ----------------------------------------
# --       PROGRAM server_local.R       --
# ----------------------------------------
# USE: Session-specific variables and
#      functions for the main reactive
#      shiny server functionality.  All
#      code in this file will be put into
#      the framework inside the call to
#      shinyServer(function(input, output, session)
#      in server.R
#
# NOTEs:
#   - All variables/functions here are
#     SESSION scoped and are ONLY
#     available to a single session and
#     not to the UI
#
#   - For globally scoped session items
#     put var/fxns in server_global.R
#
# FRAMEWORK VARIABLES
#     input, output, session - Shiny
#     ss_userAction.Log - Reactive Logger S4 object
# ----------------------------------------

# -- IMPORTS --


# -- VARIABLES --


# -- FUNCTIONS --
source(paste("program", "fxn", "program_helpers.R", sep = .Platform$file.sep))
source(paste("program", "fxn", "plots.R", sep = .Platform$file.sep))


plot2_data <- reactive({
    result <- plot2ggplot_data()
    if (!input$enableGGPlot) {
        result <- NULL
    }
    result
})

plot2 <- reactive({
    result <- NULL
    if (!is.null(plot2_data())) {
        result <- plot2ggplot()
    }
    result
})

plot3_data <- reactive({
    result <- plot3lattice_data()
    if (!input$enableLatticePlot) {
        result <- NULL
    }
    result
})

plot3 <- reactive({
    result <- NULL
    if (!is.null(plot3_data())) {
        result <- plot3lattice()
    }
    result
})

# ----------------------------------------
# --          SHINY SERVER CODE         --
# ----------------------------------------

# -- Initialize UI Elements
output$proginfo <- renderUI({
    list(p("All program-specific (i.e. application-specific) code should be ",
           "modified/added in the ", strong("program subfolder"),
           " of the framework"),
         hr(),
         p("Sidebar elements are setup and registered to the framework in ",
           "program/ui_sidebar.R"),
         p("UI body boxes (such as this one) are registered to the framework ",
           "in program/ui_body.R."),
         p("Rendering handles and reactivity are programmed in ",
           "program/server_local.R for session-specific functionality.  If ",
           "application-wide functionality is useful across all users that ",
           "should be added into server_global.R.  Scoping information is in ",
           "the top comment of all program example files.") )
    })

output$tooltips <- renderUI({
    list(hr(),
         p(ui_tooltip(id = "ex1",
                      label = "Tooltips",
                      text = "Example tooltip text"),
           "can be added with the following code in the UI:"),
         p(pre("U: ui_tooltip('tooltipID', 'label text (optional)', 'text content')")) )
    })

output$busyind  <- renderUI({
    list(hr(),
         p("There is an automatic wait indicator in the navbar when the shiny ",
           "server session is busy."),
         div(align = "center",
             bsButton("showWorking",
                      label = "Show application busy indicator for 5 seconds",
                      style = "primary")) )
    })

output$download <- renderUI({
    list(
        hr(),
        p("Data download buttons for single-option (no choice of format) or ",
          "multiple choices of formats can be added by specifying the ",
          "extensions and corresponding data functions with the ",
          "following code:"),
        p(pre("U: downloadFileButton('uiID', list(extensions))"),
          pre("S: callModule(downloadFile, 'uiID', logger, 'filenameroot', list(datafxns)"),
          "Single Download: ",
          downloadFileButton("exampleDownload1", c("csv"), "csv"),
          "Multiple-choice Download: ",
          downloadFileButton("exampleDownload2",
                             c("csv", "xlsx", "tsv"), "Download options")) )
    })

output$alerts   <- renderUI({
    list(hr(),
         p("There are four standardized locations for alerts in this app. To create ",
           "an alert call the following on the server: ",
           pre('S: createAlert(session, location, content = "Alert Text", ...)'),
           'LOCATION can be: "sidebarBasicAlert", "sidebarAdvancedAlert", "sidebarRightAlert", ',
           'and "bodyAlert".  See the ', em("alertBS"),
           "documentation for more information on styles and other options"),
         div(align = "center",
             bsButton( "exampleBasicAlert",
                       label  = "Sidebar - Basic",
                       style  = "success",
                       width  = "20%"),
             bsButton( "exampleBodyAlert",
                       label  = "Body",
                       style  = "info",
                       width  = "20%"),
             bsButton( "exampleAdvancedAlert",
                       label  = "Sidebar - Advanced",
                       style  = "warning",
                       width  = "20%"),
             bsButton( "exampleRightAlert",
                       label  = "Sidebar - Right",
                       style  = "danger",
                       width  = "20%") ) )
    })

output$loginfo <- renderUI({
    list(p("The collapsed ",
           strong("User Action Log"), em("below"),
           "is the standardized footer added by the framework.",
           "To create actions to the framework call one of the logging ",
           "functions like: ",
           pre('logXXXX("Your Log Message with %s, %s parameters", parm1, parm2, logger = ss_userAction.Log)')),
         p("The XXXX should be replaced by an actual log level like 'info', 'debug', 'warn' or 'error'.
            The framework will handle updating the footer UI element every ",
           "time the log is added to.  It is important to note that the log ",
           "rolls over for each session.  The log files are kept in the ",
           "/log directory and named 'actions.log'.  ONE old copy of ",
           "the log is kept as 'actions.log.last"),
         p("See the ", em("logging"), "documentation for more information ",
           "on functions and other options") )
    })

output$hover_info <- renderUI({
    hover <- input$examplePlot2_hover
    point <- nearPoints(mtcars, hover,
                        xvar = "wt", yvar = "mpg",
                        maxpoints = 1)
    if (nrow(point) == 0) {
        return(NULL)
    }
    else {
        left_pct <- (hover$x - hover$domain$left) / (hover$domain$right - hover$domain$left)
        left_px <- hover$range$left + left_pct * (hover$range$right - hover$range$left)

        top_pct <- (hover$domain$top - hover$y) / (hover$domain$top - hover$domain$bottom)
        top_px <- hover$range$top + top_pct * (hover$range$bottom - hover$range$top)

        style <- paste0("position:absolute;",
                        "z-index:100;",
                        "background-color: rgba(245, 245, 245, 0.85); ",
                        "left:", left_px + 2, "px; top:", top_px + 2, "px;")

        return(wellPanel(class = "well-sm",
                         style = style,
                         HTML("<b> Car: </b>", rownames(point))) )
    }
})

# -- CanvasXpress Plot Example

output$examplePlot1  <- renderCanvasXpress({
    result <- plot_htmlwidget()
    if (!input$enableCXPlot) {
        result <- canvasXpress(destroy = TRUE)
    }
    result
})

loginfo("Be Sure to Remember to Log ALL user actions",
        logger = ss_userAction.Log)

# -- Setup Download Modules with Functions we want called
callModule(downloadFile, "exampleDownload1", ss_userAction.Log,
           "examplesingle",
           list(csv = load_data1))
callModule(downloadFile, "exampleDownload2", ss_userAction.Log,
           "examplemulti",
           list(csv = load_data2, xlsx = load_data2, tsv = load_data2))
callModule(downloadableTable, "exampleDT1",  ss_userAction.Log,
           "exampletable",
           list(csv = load_data3, tsv = load_data3),
           load_data3,
           rownames = FALSE)

callModule(downloadablePlot, "examplePlot2", ss_userAction.Log,
           filenameroot = "plot2_ggplot",
           downloadfxns = list(jpeg = plot2,
                               csv  = plot2_data),
           aspectratio  = 1.5,
           visibleplot  = plot2)

callModule(downloadablePlot, "examplePlot3", ss_userAction.Log,
           filenameroot = "plot3_lattice",
           aspectratio  = 2,
           downloadfxns = list(png  = plot3,
                               tiff = plot3,
                               txt  = plot3_data,
                               tsv  = plot3_data),
           visibleplot  = plot3)

# -- Observe UI Changes
observeEvent(input$exampleBasicAlert, {
    loginfo("Sidebar Basic Alert Button Pushed",
            logger = ss_userAction.Log)
    createAlert(session, "sidebarBasicAlert",
                style = "success",
                content = "Example Basic Sidebar Alert")
})

observeEvent(input$exampleAdvancedAlert, {
    loginfo("Sidebar Advanced Alert Example Button Pushed",
            logger = ss_userAction.Log)
    createAlert(session, "sidebarAdvancedAlert",
                style = "warning",
                content = "Example Advanced Sidebar Alert")

})

observeEvent(input$exampleRightAlert, {
    loginfo("Sidebar Right Alert Example Button Pushed",
            logger = ss_userAction.Log)
    createAlert(session, "sidebarRightAlert",
                style = "danger",
                content = "Example Right Sidebar Alert")
    
})

observeEvent(input$exampleBodyAlert, {
    loginfo("Body Alert Example Button Pushed",
            logger = ss_userAction.Log)
    createAlert(session, "bodyAlert", style = "info", append = FALSE,
                content = paste("Example Body Alert - Append set to FALSE,",
                                "so only one alert will show"))
})

observeEvent(input$showWorking, {
    loginfo("Show Busy Indicator Button Pushed",
            logger = ss_userAction.Log)
    Sys.sleep(5)
})
