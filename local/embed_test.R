library(inshiny)
library(shiny)
library(bslib)

ui = page_sidebar(
    theme = bs_theme(version = 5, preset = "lumen"),

    inline("My name is ", inline_text("myname1", "Nick", "Enter text")),

    card(
        inline("My name is ", inline_text("myname2", "Nick", "Enter text")),
        fill = FALSE
    ),

    accordion(
        inline("My name is ", inline_text("myname3", "Nick", "Enter text")),

        accordion_panel(
            "Title", inline("My name is ", inline_text("myname4", "Nick", "Enter text"))
        )
    ),

    sidebar = sidebar(
        inline("My name is ", inline_text("myname5", "Nick", "Enter text"))
    )
)

server = function(input, output, session) {
}

shinyApp(ui, server)

