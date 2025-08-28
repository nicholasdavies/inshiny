test_that("slider is stable", {
    expect_snapshot(cc(inline_slider("slider_id", value = 42,
        min = 1, max = 100, step = 2, default = 99,
        placeholder = "Enter a number", meaning = "Favourite number")))
})
