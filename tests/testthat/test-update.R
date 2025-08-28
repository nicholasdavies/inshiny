test_that("update can assemble messages", {
    update_inline("select", fake_session,
        value = 42, placeholder = "Enter text", meaning = NULL,
        label = "Label", icon = shiny::icon("gears"), accent = "primary",
        min = "0", max = as.Date("2025-01-01"), step = NULL, default = 50,
        on = NULL, off = "Off",
        datesdisabled = as.Date("2025-01-01"), daysofweekdisabled = c(0, 6),
        choices = letters, selected = "a")

    expect_snapshot(x)
})

test_that("update handles selects", {
    # Choices but no selected
    update_inline("select", fake_session, choices = "a")
    expect_equal(x, list(id = "select",
        choices = shiny::HTML(
        '<li><a class="dropdown-item inshiny-item active" href="#" data-list="select" data-item="a" selected>a</a></li>'
    )))

    # Selected but no choices
    update_inline("select", fake_session, selected = "a", datesdisabled = NULL)
    expect_equal(x, list(id = "select", datesdisabled = NA, value = "a"))
})

test_that("update handles errors", {
    expect_error(update_inline("id", NULL)) # invalid session
    expect_error(update_inline(17, fake_session)) # non-string id
    expect_error(update_inline("id", fake_session, value = NULL, step = 1:2)) # invalid number
    expect_error(update_inline("id", fake_session, step = 1, default = Inf)) # invalid value
    expect_error(update_inline("id", fake_session, label = 1:2)) # invalid html
})
