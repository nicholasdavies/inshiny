library(inshiny)
library(shiny)
library(bslib)

ui = page_sidebar(
    theme = bs_theme(version = 5, preset = "lumen"),

    h4("Top level"),
    inline("My name is ", inline_text("myname1", "Nick", "Enter text")),

    h4("Card"),
    card(
        inline("My name is ", inline_text("myname2", "Nick", "Enter text")),
        fill = FALSE
    ),

    h4("Accordion"),
    accordion(
        inline("My name is ", inline_text("myname3", "Nick", "Enter text")),

        accordion_panel(
            "Title", inline("My name is ", inline_text("myname4", "Nick", "Enter text"))
        )
    ),

    h4("List group"),
    tags$div(class = "list-group",
        tags$div(class = "list-group-item",
            inline("My name is ", inline_text("myname6", "Nick", "Enter text"))
        )
    ),

    h4("Toast"),
    tags$div(class = "toast show", role = "alert",
        tags$div(class = "toast-body",
            inline("My name is ", inline_text("myname7", "Nick", "Enter text"))
        )
    ),

    h4("Modal content (inline)"),
    tags$div(class = "modal-content",
        tags$div(class = "modal-body",
            inline("My name is ", inline_text("myname8", "Nick", "Enter text"))
        )
    ),

    h4("Custom div with background"),
    tags$div(class = "inshiny-bg", style = "background-color: var(--bs-body-bg); padding: 1rem; border: 1px solid var(--bs-border-color); border-radius: 0.375rem;",
        inline("My name is ", inline_text("myname9", "Nick", "Enter text"))
    ),

    sidebar = sidebar(
        inline("My name is ", inline_text("myname5", "Nick", "Enter text"))
    )
)

server = function(input, output, session) {
}

shinyApp(ui, server)

