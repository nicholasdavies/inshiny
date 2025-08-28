test_that("slider is stable", {
    expect_snapshot(cc(inline_slider("slider_id", value = 42,
        min = 1, max = 100, default = 99,
        placeholder = "Enter a number", meaning = "Favourite number")))
})

test_that("slider auto-range works", {
    expect_equal(inline_slider("slider_id", value = 0.5, min = 0.5, max = 1.5)$
            children[[1]]$children[[1]]$attribs[["data-step"]], 0.01)
})

test_that("slider errors detected", {
    expect_error(inline_slider("slider_id", value = 0.5, min = "0.5", max = 1.5))
    expect_error(inline_slider("slider_id", value = 0.5, min = 0.5, max = "1.5"))
    expect_error(inline_slider("slider_id", value = "0.5", min = 0.5, max = 1.5))
    expect_error(inline_slider("slider_id", value = 0.5, min = 0.5, max = 1.5, step = "0.01"))
    expect_error(inline_slider("slider_id", value = 0.0, min = 0.5, max = 1.5))
})
