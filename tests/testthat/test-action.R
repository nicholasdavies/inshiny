test_that("link is stable", {
    expect_snapshot(cc(inline_link("link_id", label = "Link",
        icon = shiny::icon("gears"), meaning = "A link",
        accent = c("success", "underline-warning"))))
})

test_that("button is stable", {
    expect_snapshot(cc(inline_button("btn_id", label = "Play",
        icon = shiny::icon("play"), meaning = "Play button",
        accent = "danger")))
})
