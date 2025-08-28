test_that("switch is stable", {
    expect_snapshot(cc(inline_switch("switch_id", value = FALSE,
        on = shiny::span("On", class = "text-success"),
        off = shiny::span("Off", class = "text-danger"),
        meaning = "On/off switch")))
})
