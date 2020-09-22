# ----------------------------------------
# --          PROGRAM global.R          --
# ----------------------------------------
# USE: Global variables and functions
#
# NOTEs:
#   - All variables/functions here are
#     globally scoped and will be available
#     to server, UI and session scopes
# ----------------------------------------

# -- IMPORTS --
library(canvasXpress)

# -- Setup your Application --
set_app_parameters(title = "Sample Title (click for an info pop-up)",
                   titleinfo = HTML("<h3>Application Information Pop-Up</h3>",
                                    "<p>This pop-up can contain any valid html
                                     code.</p><p>If you prefer to have the title
                                     link to any valid url location by providing
                                     a character string to the titleinfo
                                     parameter in <i>set_app_parameters(...)
                                     </i> in program/global.R file.</p>"),
                   loglevel = "DEBUG",
                   app_version = "1.0.0")
# -- PROGRAM --
