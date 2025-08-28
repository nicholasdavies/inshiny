test_that("inline is stable", {
    expect_snapshot(cc(inline("This is a ", shiny::span(style = "color: red", "test"),
        ".", class = "mb-2", style = "font-weight: bold")))
})
