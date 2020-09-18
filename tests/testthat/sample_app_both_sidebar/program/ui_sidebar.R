# ----------------------------------------
# --       PROGRAM ui_sidebar.R         --
# ----------------------------------------
# USE: Create UI elements for the
#      application sidebar (left side on
#      the desktop; contains options) and
#      ATTACH them to the UI by calling
#      add_ui_sidebar_basic() or
#      add_ui_sidebar_advanced()
#
# NOTEs:
#   - All variables/functions here are
#     not available to the UI or Server
#     scopes - this is isolated
# ----------------------------------------

# -- IMPORTS --



# ----------------------------------------
# --     SIDEBAR ELEMENT CREATION       --
# ----------------------------------------

# -- Create Basic Elements
basictext <- div(style = "padding-top: 5px;",
                 helpText(align = "center",
                          "The BASIC tab is intended for commonly used ",
                          "options and settings for the application."))

# -- Register Basic Elements in the ORDER SHOWN in the UI
add_ui_sidebar_basic(list(basictext), append = FALSE)


# -- Create Advanced Elements
advancedtext <- div(style = "padding-top: 5px;",
                    helpText(align = "center",
                             style = "info",
                            "The ADVANCED tab is intended for less-commonly ",
                            "used options and settings for the application."))

resetinfo <- div(style = "padding-left: 5px;",
                 p("The reset functionality (button below) is a part of the ",
                   "framework and completely resets a user's session and ",
                   "rolls over their log.  Nothing needs to be done by the ",
                   "program code for this to work."))


# -- Register Advanced Elements in the ORDER SHOWN in the UI
add_ui_sidebar_advanced(list(advancedtext, resetinfo), append = FALSE)
