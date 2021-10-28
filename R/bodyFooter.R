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
.bodyFooter <- function(..., logdata) {
    call <- match.call()
    params <- list(...)
    param_index <- 1
    params_length <- length(params)
    old_style_call <- call[[1]] == "module" || "periscope" %in% as.character(call[[1]])
    
    if (old_style_call) {
        input   <- params[[param_index]]
        param_index <- param_index + 1
        output  <- params[[param_index]]
        param_index <- param_index + 1
        session <- params[[param_index]]
        param_index <- param_index + 1
    } else {
        id <- params[[param_index]]
        param_index <- param_index + 1
    }
    
    if (missing(logdata) && params_length >= param_index) {
        logdata <- params[[param_index]]
    }
    
    if (old_style_call) {
        body_footer(input, output, session, logdata)
    }
    else {
        shiny::moduleServer(
            id,
            function(input, output, session) {
                body_footer(input, output, session, logdata)
            })
    }
}

body_footer <- function(input, output, session, logdata) {
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
