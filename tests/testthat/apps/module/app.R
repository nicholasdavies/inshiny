library(shiny)
library(bslib)
library(inshiny)

# A widget inside a Shiny module, for the regression tests in test-dynamic.R.
# A module namespaces the ids of the widgets it holds, so an update sent to
# "txt" from within the module has to reach the widget whose id is "mod-txt".

widget_ui = function(id)
{
    ns = NS(id)

    tagList(
        inline("Text: ", inline_text(ns("txt"), "before")),
        inline("Switch: ", inline_switch(ns("sw"), FALSE)),
        actionButton(ns("go"), "Update")
    )
}

widget_server = function(id)
{
    moduleServer(id, function(input, output, session) {
        observeEvent(input$go, {
            update_inline("txt", value = "after")
            update_inline("sw", value = TRUE)
        })
    })
}

ui = page_fixed(
    theme = bs_theme(version = 5),
    widget_ui("mod")
)

server = function(input, output, session) {
    widget_server("mod")
}

shinyApp(ui, server)
