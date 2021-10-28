context("periscope - UI functionality")
local_edition(3)

test_that("fw_create_header", {
    expect_snapshot_output(periscope:::fw_create_header())
})

check_sidebar_result <- function(result, showsidebar = TRUE,  basic_existing = FALSE, advanced_existing = FALSE) {
    expect_equal(result$name, "aside")
    if (length(result$attribs) == 2) {
        expect_equal(result$attribs, list(class = "main-sidebar", 'data-collapsed' = "false"))
    } else {
        if (showsidebar) {
            expect_equal(result$attribs, list(id = "sidebarCollapsed", class = "main-sidebar", 'data-collapsed' = "false"))   
        } else {
            expect_equal(result$attribs, list(id = "sidebarCollapsed", class = "main-sidebar", 'data-collapsed' = "true"))   
        }
    }
    
    result.children <- result$children
    expect_equal(length(result.children), 2)
    if (showsidebar) {
        expect_equal(result.children[[1]], NULL) ## ?
    } else {
        expect_equal(length(result.children[[1]]), 3)
        expect_equal(result.children[[1]][[1]], "head")
        expect_equal(class(result.children[[1]][[2]]), "list")
        expect_equal(class(result.children[[1]][[3]]), "list")
    }
    
    expect_equal(result.children[[2]]$name, "section")
    expect_equal(result.children[[2]]$attribs$class, "sidebar")
    expect_equal(result.children[[2]][[2]]$id, "sidebarItemExpanded")
    
    result.subchilds <- result.children[[2]]$children[[1]]
    expect_equal(length(result.subchilds), 3)
    
    expect_equal(result.subchilds[[1]][[1]]$name, "script")
    expect_true(grepl("Set using set_app_parameters\\() in program/global.R", result.subchilds[[1]][[1]]$children[[1]]))
    
    if (basic_existing || advanced_existing) {
        expect_equal(result.subchilds[[3]]$name, "div")
        
        if (basic_existing && advanced_existing) {
            expect_equal(result.subchilds[[3]]$attribs$class, "tab-content")
        } else {
            expect_equal(result.subchilds[[3]]$attribs$class, "notab-content")
        }
    }
}


test_that("fw_create_sidebar no sidebar", {
    expect_snapshot_output(periscope:::fw_create_sidebar(showsidebar = F, resetbutton = F))
})

test_that("fw_create_sidebar empty", {
    expect_snapshot_output(periscope:::fw_create_sidebar(showsidebar = T, resetbutton = F))
})

test_that("fw_create_sidebar only basic", {
    # setup
    side_basic            <- shiny::isolate(.g_opts$side_basic)
    .g_opts$side_basic    <- list(tags$p())
    side_advanced         <- shiny::isolate(.g_opts$side_advanced)
    .g_opts$side_advanced <- NULL
    
    expect_snapshot_output(periscope:::fw_create_sidebar(showsidebar = T, resetbutton = F))
    
    # teardown
    .g_opts$side_basic    <- side_basic
    .g_opts$side_advanced <- side_advanced
})

test_that("fw_create_sidebar only advanced", {
    # setup
    side_basic            <- shiny::isolate(.g_opts$side_basic)
    .g_opts$side_basic    <- NULL
    side_advanced         <- shiny::isolate(.g_opts$side_advanced)
    .g_opts$side_advanced <- list(tags$p())
    
    expect_snapshot_output(periscope:::fw_create_sidebar())
    
    # teardown
    .g_opts$side_basic    <- side_basic
    .g_opts$side_advanced <- side_advanced
})

test_that("fw_create_sidebar basic and advanced", {
    # setup
    side_basic            <- shiny::isolate(.g_opts$side_basic)
    .g_opts$side_basic    <- list(tags$p())
    side_advanced         <- shiny::isolate(.g_opts$side_advanced)
    .g_opts$side_advanced <- list(tags$p())
    
    result <- periscope:::fw_create_sidebar()
    
    check_sidebar_result(result, showsidebar = TRUE, basic_existing = TRUE, advanced_existing = TRUE)
    
    # teardown
    .g_opts$side_basic    <- side_basic
    .g_opts$side_advanced <- side_advanced
})

test_that("fw_create_body app_info", {
    # setup
    app_info         <- shiny::isolate(.g_opts$app_info)
    .g_opts$app_info <- HTML("<b>app_info</b>")
    
    expect_snapshot_output(periscope:::fw_create_body())
    
    # teardown
    .g_opts$app_info <- app_info
})

test_that("fw_create_body no log", {
    # setup
    show_userlog         <- shiny::isolate(.g_opts$show_userlog)
    .g_opts$show_userlog <- FALSE
    
    expect_snapshot_output(periscope:::fw_create_body())
    
    # teardown
    .g_opts$show_userlog <- show_userlog
})

test_that("add_ui_sidebar_basic", {
    result <- add_ui_sidebar_basic(elementlist = NULL, append = FALSE, tabname = "Basic")
    expect_null(result, "add_ui_sidebar_basic")
})

test_that("add_ui_sidebar_basic append", {
    result <- add_ui_sidebar_basic(elementlist = NULL, append = TRUE, tabname = "Basic")
    expect_null(result, "add_ui_sidebar_basic")
})

test_that("add_ui_sidebar_advanced", {
    result <- add_ui_sidebar_advanced(elementlist = NULL, append = FALSE, tabname = "Advanced")
    expect_null(result, "add_ui_sidebar_advanced")
})

test_that("add_ui_sidebar_advanced append", {
    result <- add_ui_sidebar_advanced(elementlist = NULL, append = TRUE, tabname = "Advanced")
    expect_null(result, "add_ui_sidebar_advanced")
})

test_that("add_ui_body", {
    result <- add_ui_body(elementlist = NULL, append = FALSE)
    expect_null(result, "add_ui_body")
})

test_that("add_ui_body", {
    result <- add_ui_body(elementlist = NULL, append = TRUE)
    expect_null(result, "add_ui_body")
})

test_that("ui_tooltip", {
    expect_snapshot_output(ui_tooltip(id = "id", label = "mylabel", text = "mytext"))
})

test_that("ui_tooltip no text", {
    expect_warning(ui_tooltip(id = "id", label = "mylabel", text = ""), "ui_tooltip\\() called without tooltip text.")
})

test_that("fw_create_header_plus", {
    expect_snapshot_output(periscope:::fw_create_header_plus())
})

test_that("fw_create_right_sidebar", {
    expect_snapshot_output(periscope:::fw_create_right_sidebar())
})

test_that("fw_create_right_sidebar SDP<2", {
    skip_if_not(t_sdp_old)
    
    expect_snapshot_output(periscope:::fw_create_right_sidebar())
    expect_snapshot_output(add_ui_sidebar_right(elementlist = list(selectInput(inputId = "id", choices = 1:3, label = "Input widget"))))
    expect_snapshot_output(periscope:::fw_create_right_sidebar())
})

test_that("fw_create_right_sidebar SDP>=2", {
    skip_if(t_sdp_old)
    
    expect_snapshot_output(periscope:::fw_create_right_sidebar())
})

test_that("add_ui_sidebar_right", {
    result <- add_ui_sidebar_right(elementlist = NULL)
    expect_null(result, "add_ui_sidebar_right")
})

test_that("add_ui_sidebar_right with append", {
    result <- add_ui_sidebar_right(elementlist = NULL, append = TRUE)
    expect_null(result, "add_ui_sidebar_right")
    
    result <- add_ui_sidebar_right(elementlist = NULL, append = FALSE)
    expect_null(result, "add_ui_sidebar_right")
})
