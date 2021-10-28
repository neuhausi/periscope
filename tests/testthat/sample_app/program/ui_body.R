# ----------------------------------------
# --          PROGRAM ui_body.R         --
# ----------------------------------------
# USE: Create UI elements for the
#      application body (right side on the
#      desktop; contains output) and
#      ATTACH them to the UI by calling
#      add_ui_body()
#
# NOTEs:
#   - All variables/functions here are
#     not available to the UI or Server
#     scopes - this is isolated
# ----------------------------------------

# -- IMPORTS --


# ----------------------------------------
# --      BODY ELEMENT CREATION         --
# ----------------------------------------

# -- Create Elements
body1 <- shinydashboard::box( id     = "bodyElement1",
              title  = "Code Specifics and Examples",
              width  = 8,
              status = "primary",
              collapsible = TRUE,
              collapsed   = TRUE,
              htmlOutput("busyind"),
              htmlOutput("tooltips"),
              htmlOutput("alerts"),
              htmlOutput("download"))

body2 <- shinydashboard::box( id     = "bodyElement2",
              title  = "Framework Information",
              width  = 4,
              status = "success",
              collapsible = TRUE,
              collapsed   = TRUE,
              htmlOutput("proginfo") )

app_styling <-  shinydashboard::box(id          = "app_styling",
                                    title       = "Application Styling",
                                    width       = 12,
                                    status      = "primary",
                                    collapsible = TRUE,
                                    collapsed   = TRUE,
                                    htmlOutput("styles"))

body3 <- shinydashboard::box( id     = "bodyElement3",
              title  = "Downloadable Table",
              width  = 12,
              status = "primary",
              collapsible = TRUE,
              collapsed   = TRUE,
              htmlOutput("table_info"),
              hr(),
              downloadableTableUI("exampleDT1",
                                  list("csv", "tsv"),
                                  "Download table data") )

body4 <- shinydashboard::box( id = "bodyElement4",
              title = "CanvasXpress Plot",
              width = 4,
              status = "info",
              collapsible = TRUE,
              collapsed = FALSE,
              canvasXpressOutput("examplePlot1"))

plot2_hover <- hoverOpts(id = "examplePlot2_hover")

body5 <- shinydashboard::box( id = "bodyElement5",
              title = "downloadablePlots - ggplot2 & lattice",
              width = 8,
              status = "info",
              collapsible = TRUE,
              collapsed = FALSE,
              fluidRow(
                  column(width = 6, downloadablePlotUI("examplePlot2",
                                                      list("jpeg", "csv"),
                                                      "Download plot or data",
                                                      btn_halign = "left",
                                                      btn_valign = "top",
                                                      btn_overlap = FALSE,
                                                      hoverOpts = plot2_hover)),
                  column(width = 6, downloadablePlotUI("examplePlot3",
                                                      list("png", "tiff",
                                                           "txt", "tsv"),
                                                      btn_overlap = FALSE,
                                                      "Download plot or data")) ),
              uiOutput("hover_info") )

body6 <- shinydashboard::box( id     = "bodyElement6",
                              title  = "Logging Information",
                              width  = 12,
                              status = "danger",
                              collapsible = FALSE,
                              htmlOutput("loginfo") )

# -- Register Elements in the ORDER SHOWN in the UI
# --    Note: Will be added before the standard framework footer
add_ui_body(list(body1, body2, app_styling, body3, body4, body5, body6), append = FALSE)
