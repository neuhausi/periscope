# ----------------------------------------
# --      PROGRAM server_global.R       --
# ----------------------------------------
# USE: Server-specific variables and
#      functions for the main reactive
#      shiny server functionality.  All
#      code in this file will be put into
#      the framework outside the call to
#      shinyServer(function(input, output, session)
#      in server.R
#
# NOTEs:
#   - All variables/functions here are
#     SERVER scoped and are available
#     across all user sessions, but not to
#     the UI.
#
#   - For user session-scoped items
#     put var/fxns in server_local.R
#
# FRAMEWORK VARIABLES
#     none
# ----------------------------------------

# -- IMPORTS --
library(colourpicker)
library(DT)
library(htmltools)
library(htmlwidgets)


# -- VARIABLES --
sg_example_data <- read.csv("program/data/example.csv",
                            comment.char = c("#"),
                            stringsAsFactors = F)
    #note - since this is an example, the dataset provided is a reference
    #       dataset.  This file is being read in server_global.R, where you
    #       should only load data that will be available to ALL users/sessions.
    #       ** IMPORTANT **
    #       Do not read user-specific data in this file or global.R, use
    #       server-local.R for user-specific (i.e. session-specific) data!

# -- FUNCTIONS --


