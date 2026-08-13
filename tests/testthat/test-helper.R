test_that("helpers catch errors", {
    withr::local_envvar(c(CI = "true"))

    expect_error(check_tags(1, 2, "testthat"))
    expect_error(check_tags(shiny::div(), shiny::span(), "testthat"))
    expect_error(check_tags(shiny::div(), shiny::div(shiny::span()), "testthat"))
    expect_error(check_tags(shiny::div(shiny::div(), shiny::div()), shiny::div(shiny::div()), "testthat"))
    expect_error(coalesce(shiny::div(style = "1", style = "2")))
})

test_that("plain_text works", {
    expect_identical(plain_text(NULL), "")
    expect_identical(plain_text("Enter text"), "Enter text")
    expect_identical(plain_text(shiny::HTML("<b>Type</b>")), "Type")
    expect_identical(plain_text(shiny::span(class = "text-danger", "Type here")),
        "Type here")
    expect_identical(plain_text(shiny::span("a ", shiny::tags$b("&"), " b")),
        "a & b")
    expect_identical(plain_text(shiny::HTML("&amp;lt;")), "&lt;")
})

test_that("boolean works", {
    expect_identical(boolean(NA), "mixed")
    expect_identical(boolean(TRUE), "true")
    expect_identical(boolean(FALSE), "false")
})
