test_that("link is stable", {
    if (packageVersion("shiny") >= "1.12.0") {
        expect_snapshot(cc(inline_link("link_id", label = "Link",
            icon = shiny::icon("gears"), meaning = "A link",
            accent = c("success", "underline-warning"))),
            variant = "shiny-1.12.0")
    } else {
        expect_snapshot(cc(inline_link("link_id", label = "Link",
            icon = shiny::icon("gears"), meaning = "A link",
            accent = c("success", "underline-warning"))),
            variant = "shiny-1.10.0")
    }
})

test_that("button is stable", {
    if (packageVersion("shiny") >= "1.12.0") {
        expect_snapshot(cc(inline_button("btn_id", label = "Play",
            icon = shiny::icon("play"), meaning = "Play button",
            accent = "danger")),
            variant = "shiny-1.12.0")
    } else {
        expect_snapshot(cc(inline_button("btn_id", label = "Play",
            icon = shiny::icon("play"), meaning = "Play button",
            accent = "danger")),
            variant = "shiny-1.10.0")
    }
})
