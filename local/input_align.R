library(shiny)
library(bslib)

# widgets:
# text - handled by this
# number - handled by this plus arrows and validation
# link - as currently implemented
# button - have done this but better to revert to older implementation
# switch - as currently implemented
# slider
# select
# date
# then need to think about updates

scr = paste(readLines("./local/input_align.js"), collapse = "\n")
css = paste(readLines("./local/input_align.css"), collapse = "\n")

ui = page_fixed(
    theme = bs_theme(version = 5, preset = "quartz"),

    tags$head(tags$script(HTML(scr)), tags$style(HTML(css))),

    textInput("tb_native", "Native text input", value = "Toast toast toast"),

    span("Test test test"),
    span(style = "position: relative; margin: 0 0.15rem",
        span(" test test", contenteditable = NA, id = "tb_test",
            class = "inshiny-nofocus inshiny-form-text", style = "position: relative; padding: 0 0.35rem"),
        span(class = "form-control", style = "position: absolute; inset: -0.25rem 0rem; z-index: -1; padding: 0")
    ),

    br(),
    span("Test test test test test test"),
    br(),
    span("Test test test test test test"),

    br(),
    htmlOutput("out1"),
    htmlOutput("out2")
)

server = function(input, output, session)
{
    print(input)
    output$out1 = renderUI({ input$tb_native })
    output$out2 = renderUI({ input$tb_test })
}

shinyApp(ui, server)
