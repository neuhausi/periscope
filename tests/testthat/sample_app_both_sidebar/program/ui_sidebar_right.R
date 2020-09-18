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

# -- Register Basic Elements in the ORDER SHOWN in the UI
add_ui_sidebar_right(list(tab1, tab2, tab3))
