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
load_themes <- reactiveValues(themes = NULL)


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
          pre("S: downloadFile('uiID', logger, 'filenameroot', list(datafxns)"),
          "Single Download: ",
          downloadFileButton("exampleDownload1", c("csv"), "csv"),
          "Multiple-choice Download: ",
          downloadFileButton("exampleDownload2",
                             c("csv", "xlsx", "tsv"), "Download options")) )
})

output$alerts   <- renderUI({
    list(hr(),
         p("There are two standardized locations for alerts in this app. To create ",
           "an alert call the following on the server: ",
           pre('S: createAlert(session, location, content = "Alert Text", ...)'),
           'LOCATION can be: "bodyAlert" and "sidebarRightAlert", See the ', em("alertBS"),
           "documentation for more information on styles and other options"),
         div(align = "center",
             bsButton( "exampleBodyAlert",
                       label  = "Body",
                       style  = "info",
                       width  = "25%"),
             bsButton( "exampleRightAlert",
                       label  = "Sidebar - Right",
                       style  = "danger",
                       width  = "25%")) )
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

output$styles <- renderUI({
    load_themes$themes <- read_themes()
    list(p("User can control primary aspects of the application's styles by modifying the www/periscope_style.yaml file.\n This interactive example can be used to explore those parameters."),
         p("Color values can be specified as:",
           tags$ul(tags$li("Hex Value:", HTML("&nbsp;"), tags$b(tags$i("i.e. '#31A5CC'"))),
                   tags$li("RGB Value:", HTML("&nbsp;"), tags$b(tags$i("i.e. 'rgb(49, 165, 204)'"))),
                   tags$li("Color Name:", HTML("&nbsp;"), tags$b(tags$i("i.e. 'green', 'red', ..."))))),
         fluidRow(
             column(width = 6,
                    colourpicker::colourInput("primary_color", 
                                              ui_tooltip("primary_tip", 
                                                         "Primary Color", 
                                                         "Sets the primary status color that affects the color of the header, valueBox, infoBox and box."),
                                              load_themes$themes[["primary_color"]])),
             column(width = 6,
                    numericInput("sidebar_width", 
                                 ui_tooltip("sidebar_width_tip", 
                                            "Sidebar Width", 
                                            "Change the default sidebar width"),
                                 load_themes$themes[["sidebar_width"]]))),
         fluidRow(
             column(width = 6,
                    colourpicker::colourInput("sidebar_background_color", 
                                              ui_tooltip("sidebar_background_color_tip", 
                                                         "Sidebar Background Color", 
                                                         "Change the default sidebar background color"),
                                              load_themes$themes[["sidebar_background_color"]])),
             column(width = 6,
                    colourpicker::colourInput("body_background_color", 
                                              ui_tooltip("body_background_color_tip", 
                                                         "Body Background Color", 
                                                         "Change body background color"),
                                              load_themes$themes[["body_background_color"]]))),
         fluidRow(
             column(width = 6,
                    colourpicker::colourInput("box_color", 
                                              ui_tooltip("box_color_tip", 
                                                         "Box Color", 
                                                         "Change box default color"),
                                              load_themes$themes[["box_color"]])),
             column(width = 6,
                    br(),
                    bsButton("updateStyles",
                             label  = "Update Application Theme"),
                    style = "margin-top: 5px;")))
    
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
downloadFile("exampleDownload1", 
             ss_userAction.Log,
             "examplesingle",
             list(csv = load_data1))
downloadFile("exampleDownload2",
             ss_userAction.Log,
             "examplemulti",
             list(csv = load_data2, xlsx = load_data2, tsv = load_data2))
sketch <- htmltools::withTags(
    table(
        class = "display",
        thead(
            tr(
                th(rowspan = 2, "Location"),
                th(colspan = 2, "Statistics")),
            tr(
                th("Change"),
                th("Increase")))
        ))

downloadableTable("exampleDT1",
                  ss_userAction.Log,
                  "exampletable",
                  list(csv = load_data3, tsv = load_data3),
                  load_data3,
                  colnames = c("Area", "Delta", "Increase"),
                  filter = "bottom",
                  callback = htmlwidgets::JS("table.order([1, 'asc']).draw();"),
                  container = sketch,
                  formatStyle = list(columns = c("Total.Population.Change"),   
                                     color = DT::styleInterval(0, c("red", "green"))),
                  formatStyle = list(columns = c("Natural.Increase"),   
                                     backgroundColor = DT::styleInterval(c(7614, 15914, 34152),
                                                                         c("lightgray", "gray", "cadetblue", "#808000"))))

output$table_info <- renderUI({
    list(
        tags$ul(tags$li("User can customize downloadableTable modules using DT options such as:",
                        tags$ul(tags$li("labels:", HTML("&nbsp;"),
                                        tags$b(tags$i("i.e. 'colnames', 'caption', ..."))),
                                tags$li("layout and columns styles:", HTML("&nbsp;"),
                                        tags$b(tags$i("i.e. 'container', 'formatStyle', ..."))),
                                tags$li("other addons:", HTML("&nbsp;"),
                                        tags$b(tags$i("i.e. 'filter', 'callback', ..."))))),
                tags$li("For more information about table options please visit the",
                        tags$a("DT documentation", target = "_blank", href = "https://rstudio.github.io/DT/"),
                        "site")
        ))
})


downloadablePlot("examplePlot2",
                 ss_userAction.Log,
                 filenameroot = "plot2_ggplot",
                 downloadfxns = list(jpeg = plot2,
                                     csv  = plot2_data),
                 aspectratio  = 1.5,
                 visibleplot  = plot2)

downloadablePlot("examplePlot3", 
                 ss_userAction.Log,
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

output$body <- renderUI({
    list(periscope:::fw_create_body(),
         init_js_command())
})

observeEvent(input$updateStyles, {
    req(input$primary_color)
    req(input$sidebar_width)
    req(input$sidebar_background_color)
    req(input$body_background_color)
    req(input$box_color)
    
    lines <- c("### primary_color",
               "# Sets the primary status color that affects the color of the header, valueBox, infoBox and box.",
               "# Valid values are names of the color or hex-decimal value of the color (i.e,: \"blue\", \"#086A87\").",
               "# Blank/empty value will use default value",
               paste0("primary_color: '", input$primary_color, "'\n\n"),
               
               
               "# Sidebar variables: change the default sidebar width, colors:",
               "### sidebar_width",
               "# Width is to be specified as a numeric value in pixels. Must be greater than 0 and include numbers only.",
               "# Valid possible value are 200, 350, 425, ...",
               "# Blank/empty value will use default value",
               paste0("sidebar_width: ", input$sidebar_width, "\n"),
               
               "### sidebar_background_color",
               "# Valid values are names of the color or hex-decimal value of the color (i.e,: \"blue\", \"#086A87\").",
               "# Blank/empty value will use default value",
               paste0("sidebar_background_color: '", input$sidebar_background_color, "'\n"),
               
               "### sidebar_hover_color",
               "# The color of sidebar menu item upon hovring with mouse.",
               "# Valid values are names of the color or hex-decimal value of the color (i.e,: \"blue\", \"#086A87\").",
               "# Blank/empty value will use default value",
               "sidebar_hover_color: \n",
               
               "### sidebar_text_color",
               "# Valid values are names of the color or hex-decimal value of the color (i.e,: \"blue\", \"#086A87\").",
               "# Blank/empty value will use default value",
               "sidebar_text_color: \n\n",
               
               "# body variables",
               "### body_background_color",
               "# Valid values are names of the color or hex-decimal value of the color (i.e,: \"blue\", \"#086A87\").",
               "# Blank/empty value will use default value",
               paste0("body_background_color: '", input$body_background_color, "'\n"),
               
               "# boxes variables",
               "### box_color",
               "# Valid values are names of the color or hex-decimal value of the color (i.e,: \"blue\", \"#086A87\").",
               "# Blank/empty value will use default value",
               paste0("box_color: '", input$box_color, "'\n"),
               
               "### infobox_color",
               "# Valid values are names of the color or hex-decimal value of the color (i.e,: \"blue\", \"#086A87\").",
               "# Blank/empty value will use default value",
               "infobox_color: ")
    
    write(lines, "www/periscope_style.yaml", append = F)
    load_themes$themes <- read_themes()
    output$body <- renderUI({
        list(periscope:::fw_create_body(),
             shiny::tags$script("$('#app_styling').closest('.box').find('[data-widget=collapse]').click();"),
             init_js_command())
    }) 
})

init_js_command <- function() {
    list(shiny::tags$script("setTimeout(function() {$('div.navbar-custom-menu').click()}, 1000);"),
         shiny::tags$script("$('div.navbar-custom-menu').click();"),
         shiny::tags$script("$('#examplePlot2-dplotButtonDiv').css('display', 'inherit')"),
         shiny::tags$script("$('#examplePlot3-dplotButtonDiv').css('display', 'inherit')"))
}
