test_that("helpers catch errors", {
    expect_error(check_tags(1, 2, "testthat"))
    expect_error(check_tags(shiny::div(), shiny::span(), "testthat"))
    expect_error(check_tags(shiny::div(), shiny::div(shiny::span()), "testthat"))
    expect_error(check_tags(shiny::div(shiny::div(), shiny::div()), shiny::div(shiny::div()), "testthat"))
    expect_error(coalesce(shiny::div(style = "1", style = "2")))
})
