context("periscope - Body footer")

test_that(".bodyFooterOutput", {
    local_edition(3)
    expect_snapshot_output(.bodyFooterOutput("myid"))
})

test_that(".bodyFooter", {
    testServer(.bodyFooter, {expect_silent(.bodyFooter)})
})
