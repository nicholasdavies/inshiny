library(shiny)
library(bslib)
library(inshiny)

# Widgets that move between two uiOutputs, keeping the same ids, for the
# regression tests in test-dynamic.R. Both outputs invalidate in the same
# flush, so the incoming copy of a widget is inserted while the outgoing copy
# is still in the document, and the two briefly share their ids.

widgets = function()
{
    tagList(
        inline("Slider: ", inline_slider("sl", 50, 0, 100)),
        inline("Date: ", inline_date("dt", "2025-08-01", format = "dd/mm/yyyy")),
        inline("Select: ", inline_select("se", c("alpha", "beta", "gamma"))),
        inline("Number: ", inline_number("nu", 5, 0, 10)),
        inline("Switch: ", inline_switch("sw", FALSE))
    )
}

ui = page_fixed(
    theme = bs_theme(version = 5),

    checkboxInput("where", "Move widgets to panel B", FALSE),

    card(card_header("Panel A"), uiOutput("panelA")),
    card(card_header("Panel B"), uiOutput("panelB")),

    actionButton("go", "Update all")
)

server = function(input, output, session) {
    output$panelA = renderUI({ if (!isTRUE(input$where)) widgets() })
    output$panelB = renderUI({ if (isTRUE(input$where)) widgets() })

    observeEvent(input$go, {
        update_inline("sl", value = 30)
        update_inline("dt", value = as.Date("2025-08-20"))
        update_inline("se", choices = c("delta", "epsilon"), selected = "epsilon")
        update_inline("nu", value = 8)
        update_inline("sw", value = TRUE)
    })
}

shinyApp(ui, server)
