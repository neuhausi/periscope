# -------------------------------------
# --      Body Footer Box Module     --
# -- (Internal/Private Shiny Module) --
# -------------------------------------

# Module UI Function
.bodyFooterOutput <- function(id) {
    ns <- shiny::NS(id)

    shinydashboard::box(
        id     = ns("userlog"),
        title  = "User Action Log",
        width  = 12,
        status = NULL,
        collapsible = TRUE,
        collapsed   = TRUE,
        shiny::tableOutput(ns("dt_userlog")) )
}


# Module Server Function
.bodyFooter <- function(input, output, session, logdata) {
    output$dt_userlog <- shiny::renderTable({

        lines <- logdata()
        if (is.null(lines) || length(lines) == 0) {
            return()
        }

        out1 <- data.frame(orig = lines, stringsAsFactors = F)
        loc1 <- regexpr("\\[", out1$orig)
        loc2 <- regexpr("\\]", out1$orig)

        out1$logname   <- substr(out1$orig, 1, loc1 - 1)

        out1$timestamp <- substr(out1$orig, loc1 + 1, loc2 - 1)
        out1$timestamp <- lubridate::parse_date_time(out1$timestamp, "YmdHMS")

        out1$action <- substring(out1$orig, loc2 + 1)
        out1$action <- trimws(out1$action, "both")

        data.frame(action = out1$action,
                   time = format(out1$timestamp, format = .g_opts$datetime.fmt))
    })
}
