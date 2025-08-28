test_that("number is stable", {
    expect_snapshot(cc(inline_number("number_id", value = 42,
        min = 1, max = 100, step = 2, default = 99,
        placeholder = "Enter a number", meaning = "Favourite number")))
})

test_that("number errors detected", {
    expect_error(inline_number("number_id", value = "42"))
    expect_error(inline_number("number_id", value = 42, min = "0"))
    expect_error(inline_number("number_id", value = 42, max = "100"))
    expect_error(inline_number("number_id", value = 42, step = "1"))
})
