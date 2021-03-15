# ----------------------------------------
# --     PROGRAM ui_sidebar_right.R     --
# ----------------------------------------
# USE: Create UI elements for the
#      application sidebar (right side on
#      the desktop; contains options) and
#      ATTACH them to the UI by calling
#      add_ui_sidebar_right()
#
# NOTEs:
#   - All variables/functions here are
#     not available to the UI or Server
#     scopes - this is isolated
# ----------------------------------------

# -- IMPORTS --



# ----------------------------------------
# --   RIGHT SIDEBAR ELEMENT CREATION   --
# ----------------------------------------

# -- Create Elements

if (utils::packageVersion('shinydashboardPlus') < 2) {
    tab1 <- rightSidebarTabContent(
        id = 1,
        icon = "desktop",
        title = "Tab 1 - Plots",
        active = TRUE,
        checkboxInput("enableGGPlot", "Enable GGPlot", value = TRUE),
        checkboxInput("enableLatticePlot", "Enable Lattice Plot", value = TRUE),
        checkboxInput("enableCXPlot", "Enable CanvasXpress Plot", value = TRUE))

    tab2 <- rightSidebarTabContent(
        id = 2,
        title = "Tab 2 - Datatable")

    tab3 <- rightSidebarTabContent(
        id = 3,
        title = "Tab 3 - Other",
        icon = "paint-brush")

    plus_fxn <- list(tab1, tab2, tab3)
} else {
    tab1 <- controlbarItem(
        id = 1,
        title = icon("desktop"),
        "Tab 1 - Plots",
        checkboxInput("enableGGPlot", "Enable GGPlot", value = TRUE),
        checkboxInput("enableLatticePlot", "Enable Lattice Plot", value = TRUE),
        checkboxInput("enableCXPlot", "Enable CanvasXpress Plot", value = TRUE)
    )
    
    tab2 <- controlbarItem(
        id = 2,
        title = icon("database"),
        "Tab 2 - Datatable",
    )
    
    tab3 <- controlbarItem(
        id = 3,
        title = icon("paint-brush"),
        "Tab 3 - Other",
    )
    
    plus_fxn <- controlbarMenu(tab1, tab2, tab3)
}

# -- Register Basic Elements in the ORDER SHOWN in the UI
add_ui_sidebar_right(plus_fxn)
