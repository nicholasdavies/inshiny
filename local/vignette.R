library(shiny)
library(bslib)
library(inshiny)

ui <- page_fixed(
    theme = bs_theme(version = 5, preset = "shiny"),

    h1("Temperature plot"),

    plotOutput("plot", width = 480, height = 300),

    br(),

    inline("Start on ", inline_date("start_date", "2025-01-01"),
        " and plot for ", inline_number("num_days", 365), " days."),

    inline("Average temperature: ", inline_slider("avg_temp", 20, 0, 40),
        " °C. Range: ±", inline_select("temp_range", c(5, 10, 15), 10), " °C."),

    inline("Hemisphere: ", inline_switch("southern", FALSE,
        on = "Southern", off = "Northern")),

    inline(inline_button("colour", "Change colour"), " ",
        inline_link("reset", "Reset"))
)

# ui <- page_fixed(
#     theme = bs_theme(version = 5, preset = "quartz"),
#
#     h1("Temperature plot"),
#
#     plotOutput("plot", width = 480, height = 320),
#
#     br(),
#
#     dateInput("start_date", "Start date", "2025-01-01"),
#     numericInput("num_days", "Number of days", 365),
#     sliderInput("avg_temp", "Average temperature (°C)", 0, 40, 20),
#     selectInput("temp_range", "Temperature range (± °C)", c(5, 10, 15), 10),
#     checkboxInput("southern", "Southern hemisphere", FALSE),
#     actionButton("colour", "Change colour"),
#     actionLink("reset", "Reset"),
# )

server <- function(input, output, session)
{
    output$plot <- renderPlot({
        date <- input$start_date + seq_len(input$num_days) - 1;
        xpts <- as.POSIXlt(date)$yday; # day number, 0-365
        temperature <- cos(2 * pi * xpts / 364) *
            ifelse(input$southern, 1, -1) * as.numeric(input$temp_range) +
            input$avg_temp;
        par(mar = c(5, 5, 1, 2))
        plot(date, temperature, type = "l", ylim = c(-15, 55),
            col = input$colour %% 16 + 1, lwd = 3)
        abline(h = 0, col = 8, lty = 2)
    })

    observeEvent(input$reset, {
        update_inline("start_date", value = "2025-01-01")
        update_inline("num_days", value = 365)
        update_inline("avg_temp", value = 20)
        update_inline("temp_range", value = "10")
        update_inline("southern", value = FALSE)
        update_inline("colour", value = 0)
    })
}

shinyApp(ui, server)
