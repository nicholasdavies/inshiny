test_that("text is stable", {
    expect_snapshot(cc(inline_text("text_id", value = "Hello.",
        placeholder = "Enter some text", meaning = "Text input")))
})
