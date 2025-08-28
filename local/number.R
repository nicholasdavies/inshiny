library(shiny)
library(bslib)

scr = paste(readLines("./local/number.js"), collapse = "\n")
css = paste(readLines("./local/number.css"), collapse = "\n")

ui = page_fixed(
    theme = bs_theme(version = 5, preset = "quartz"),

    tags$head(
        tags$script(HTML(scr)),
        tags$style(HTML(css))
    ),

    inline(
        span("Word"), br(), span("Word"),

        div(class = "two-rows",
            span(class = "cell inc", `data-target-id` = "my_number"),
            span(class = "cell dec", `data-target-id` = "my_number")
        ),
        inline_text_new("my_number", 1),

        br(), span("Word"), br(), span("Word")
    ),
)

server = function(input, output)
{
}

shinyApp(ui, server)
