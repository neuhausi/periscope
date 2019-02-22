context("periscope - Body footer")

test_that(".bodyFooter", {
    result <- .bodyFooterOutput("myid")

    expect_equal(result$name, "div")
    expect_equal(length(result$attribs), 1)
    expect_equal(result$attribs$class, "col-sm-12")

    result.children <- result$children
    expect_equal(length(result.children), 1)

    expect_equal(result.children[[1]]$name, "div")
    expect_equal(length(result.children[[1]]$attribs), 1)
    expect_equal(result.children[[1]]$attribs$class, "box collapsed-box")

    result.subchilds <- result$children[[1]]$children

    expect_equal(length(result.subchilds), 3)

    expect_equal(result.subchilds[[1]]$name, "div")
    expect_equal(result.subchilds[[1]]$attribs$class, "box-header")
    expect_equal(length(result.subchilds[[1]]$children), 2)

    expect_equal(result.subchilds[[1]]$children[[1]]$name, "h3")
    expect_equal(result.subchilds[[1]]$children[[1]]$attribs$class, "box-title")
    expect_equal(result.subchilds[[1]]$children[[1]]$children[[1]], "User Action Log")

    expect_equal(result.subchilds[[1]]$children[[2]]$name, "div")
    expect_equal(result.subchilds[[1]]$children[[2]]$attribs$class, "box-tools pull-right")
    expect_equal(result.subchilds[[1]]$children[[2]]$children[[1]]$name, "button")
    expect_equal(result.subchilds[[1]]$children[[2]]$children[[1]]$attribs$class, "btn btn-box-tool")
    expect_equal(result.subchilds[[1]]$children[[2]]$children[[1]]$attribs$`data-widget`, "collapse")
    expect_equal(result.subchilds[[1]]$children[[2]]$children[[1]]$children[[1]]$name, "i")
    expect_equal(result.subchilds[[1]]$children[[2]]$children[[1]]$children[[1]]$attribs$class, "fa fa-plus")

    expect_equal(result.subchilds[[2]]$name, "div")
    expect_equal(result.subchilds[[2]]$attribs$class, "box-body")
    expect_equal(result.subchilds[[2]]$attribs$id, "myid-userlog")
    expect_equal(length(result.subchilds[[2]]$children), 1)

    expect_equal(result.subchilds[[2]]$children[[1]]$name, "div")
    expect_equal(result.subchilds[[2]]$children[[1]]$attribs$id, "myid-dt_userlog")
    expect_equal(result.subchilds[[2]]$children[[1]]$attribs$class, "shiny-html-output")
    expect_equal(result.subchilds[[2]]$children[[1]]$children, list())





})
