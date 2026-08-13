test_that("text is stable", {
    expect_snapshot(cc(inline_text("text_id", value = "Hello.",
        placeholder = "Enter some text", meaning = "Text input")))
})

test_that("html placeholder is rendered, with plain text for aria", {
    html = as.character(inline_text("text_id", value = "Hello.",
        placeholder = shiny::span(class = "text-danger", "Type here")))

    expect_match(html, '<span class="text-danger">Type here</span>', fixed = TRUE)
    expect_match(html, 'aria-placeholder="Type here"', fixed = TRUE)
})
