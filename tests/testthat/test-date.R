test_that("date is stable", {
    expect_snapshot(cc(inline_date("date_id", value = as.Date("2025-08-28"),
        min = "2025-01-01", max = NULL,
        placeholder = "Enter date", meaning = "Date to select",
        format = "dd/mm/yyyy", startview = "year", weekstart = 1, language = "en",
        autoclose = TRUE, datesdisabled = c("2025-12-25", "2026-12-25"),
        daysofweekdisabled = c(0, 6))))
})

test_that("date errors detected", {
    expect_error(inline_date("date_id", value = as.Date("2025-08-28"),
        min = "2025-09-01", max = "2025-09-30"))
    expect_error(inline_date("date_id", value = NA))
})
