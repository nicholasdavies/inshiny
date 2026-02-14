test_that("helpers catch errors", {
    withr::local_envvar(c(CI = "true"))

    expect_error(check_tags(1, 2, "testthat"))
    expect_error(check_tags(shiny::div(), shiny::span(), "testthat"))
    expect_error(check_tags(shiny::div(), shiny::div(shiny::span()), "testthat"))
    expect_error(check_tags(shiny::div(shiny::div(), shiny::div()), shiny::div(shiny::div()), "testthat"))
    expect_error(coalesce(shiny::div(style = "1", style = "2")))
})

test_that("boolean works", {
    expect_identical(boolean(NA), "mixed")
    expect_identical(boolean(TRUE), "true")
    expect_identical(boolean(FALSE), "false")
})
