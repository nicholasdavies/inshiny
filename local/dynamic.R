library(inshiny)
library(shiny)
library(bslib)

# Static and dynamic (uiOutput/renderUI) copies of every inshiny widget, side
# by side. Both panels are built from the same widgets() call, so any
# difference in behaviour comes from the dynamic path alone.

# Widget ids, without the panel prefix
ids = c("text", "number", "slider", "switch", "date", "select", "selectm",
    "link", "button")

# One copy of every widget, with ids prefixed for the panel it belongs to
widgets = function(p)
{
    id = function(x) paste0(p, "_", x)

    tagList(
        inline("Text: ", inline_text(id("text"), "Nick", "Enter text"), "."),
        inline("Number: ", inline_number(id("number"), 38, 30, 50), "."),
        inline("Slider: ", inline_slider(id("slider"), 50, 0, 100), "."),
        inline("Switch: ", inline_switch(id("switch"), FALSE,
            on = span(class = "text-success", "On"),
            off = span(class = "text-danger", "Off")), "."),
        inline("Date: ", inline_date(id("date"), "2025-08-01",
            format = "dd/mm/yyyy"), "."),
        inline("Select: ", inline_select(id("select"), rownames(mtcars)[1:5]), "."),
        inline("Multi: ", inline_select(id("selectm"), rownames(mtcars)[1:5],
            multiple = TRUE), "."),
        inline("Link: ", inline_link(id("link"), "click me", icon = icon("dog")),
            " Button: ", inline_button(id("button"), "press me",
                icon = icon("gears"))),
        inline(inline_button(id("update"), "Update all"))
    )
}

# Send an update to every widget in a panel. inline_select(multiple = TRUE) is
# left out as update_inline() does not support it.
update_all = function(p)
{
    id = function(x) paste0(p, "_", x)

    update_inline(id("text"), value = "Updated",
        placeholder = span(class = "text-danger", "Enter your name"))
    update_inline(id("number"), value = 42, min = 0, max = 100, step = 2)
    update_inline(id("slider"), value = 25, min = 0, max = 50)
    update_inline(id("switch"), value = TRUE,
        on = span(class = "text-info", "Switched on"),
        off = span(class = "text-secondary", "Switched off"))
    update_inline(id("date"), value = as.Date("2025-08-15"))
    update_inline(id("select"), choices = rownames(mtcars)[6:10])
    update_inline(id("link"), label = "updated link", accent = "danger")
    update_inline(id("button"), label = "updated button", icon = icon("paw"))
}

# Current value and class of every input in a panel
values = function(input, p)
{
    paste0(vapply(ids, function(i) {
        v = input[[paste0(p, "_", i)]]
        paste0(format(i, width = 8), " ",
            if (is.null(v)) "NULL" else paste0(format(v), collapse = ", "),
            "  (", paste0(class(v), collapse = "/"), ")")
    }, character(1)), collapse = "\n")
}

ui = page_fixed(
    theme = bs_theme(version = 5, preset = "lumen"),

    h1("Static vs dynamic widgets"),

    checkboxInput("show", "Show dynamic widgets", TRUE),

    layout_columns(
        card(
            card_header("Static"),
            widgets("s"),
            hr(),
            verbatimTextOutput("s_values")
        ),
        card(
            card_header("Dynamic"),
            uiOutput("dynamic"),
            hr(),
            verbatimTextOutput("d_values")
        )
    )
)

server = function(input, output, session) {
    output$dynamic = renderUI({
        if (isTRUE(input$show)) widgets("d")
    })

    output$s_values = renderText(values(input, "s"))
    output$d_values = renderText(values(input, "d"))

    observeEvent(input$s_update, update_all("s"))
    observeEvent(input$d_update, update_all("d"))
}

shinyApp(ui, server)
