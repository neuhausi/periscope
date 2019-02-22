context("periscope - App reset")

test_that(".appResetButton", {
    result <- .appResetButton("myid")

    expect_equal(result$name, "div")
    expect_equal(length(result$attribs), 1)
    expect_equal(result$attribs$align, "center")

    result.children <- result$children
    expect_equal(length(result.children), 2)

    expect_equal(result.children[[1]]$name, "button")
    expect_equal(result.children[[1]]$attribs$id, "myid-resetButton")

})
