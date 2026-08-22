library(shiny)
library(bslib)
library(inshiny)

# Static and dynamic (uiOutput/renderUI) copies of every inshiny widget, for
# the regression tests in test-dynamic.R. Both panels are built from the same
# widgets() call, so any difference between them comes from the dynamic path.

# One copy of every widget, with ids prefixed for the panel it belongs to
widgets = function(p)
{
    id = function(x) paste0(p, "_", x)

    tagList(
        inline("Text: ", inline_text(id("text"), "Nick", "Enter text")),
        inline("Number: ", inline_number(id("number"), 38, 30, 50)),
        inline("Slider: ", inline_slider(id("slider"), 50, 0, 100)),
        inline("Switch: ", inline_switch(id("switch"), FALSE)),
        inline("Date: ", inline_date(id("date"), "2025-08-01",
            format = "dd/mm/yyyy")),
        inline("Select: ", inline_select(id("select"),
            c("alpha", "beta", "gamma"))),
        inline("Multi: ", inline_select(id("selectm"),
            c("alpha", "beta", "gamma"), multiple = TRUE)),
        inline("Link: ", inline_link(id("link"), "click me")),
        inline("Button: ", inline_button(id("button"), "press me"))
    )
}

# Send an update to every widget in a panel
update_all = function(p)
{
    id = function(x) paste0(p, "_", x)

    update_inline(id("text"), value = "Updated")
    update_inline(id("number"), value = 42, min = 0, max = 100, step = 2)
    update_inline(id("slider"), value = 25, min = 0, max = 50)
    update_inline(id("switch"), value = TRUE, on = "Yes", off = "No")
    update_inline(id("date"), value = as.Date("2025-08-15"))
    update_inline(id("select"), choices = c("delta", "epsilon"),
        selected = "epsilon")
    # Choices of more than one word, as these can wrap within themselves and
    # so are the harder case for sizing the widget
    update_inline(id("selectm"),
        choices = c("Duster 360", "Merc 240D", "Mazda RX4"),
        selected = c("Duster 360", "Merc 240D"))
    update_inline(id("link"), label = "updated link")
    update_inline(id("button"), label = "updated button")
}

# The widgets sit in cards, whose bodies space their contents with a flex gap,
# as that is where the spacing of inline widgets needs the most care
ui = page_fixed(
    theme = bs_theme(version = 5),

    checkboxInput("show", "Show dynamic widgets", TRUE),

    layout_columns(
        card(card_header("Static"), widgets("s")),
        card(card_header("Dynamic"), uiOutput("dynamic"))
    ),

    actionButton("update_s", "Update static"),
    actionButton("update_d", "Update dynamic")
)

server = function(input, output, session) {
    output$dynamic = renderUI({
        if (isTRUE(input$show)) widgets("d")
    })

    observeEvent(input$update_s, update_all("s"))
    observeEvent(input$update_d, update_all("d"))
}

shinyApp(ui, server)
