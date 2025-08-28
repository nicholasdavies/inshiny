test_that("select is stable", {
    expect_snapshot(cc(inline_select("select_id",
        list("Dog names" = c("Fido", "Rex"), "Cat names" = c("Felix", "Boots")),
        selected = "Rex", multiple = FALSE, meaning = "Select a pet name")))

    expect_snapshot(cc(inline_select("select_id",
        list("Dog names" = c("Fido", "Rex"), "Cat names" = c("Felix", "Boots")),
        selected = "Rex", multiple = TRUE, meaning = "Select a pet name")))
})
