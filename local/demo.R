library(inshiny)
library(shiny)
library(bslib)

# X make all widgets depend on a Shiny widget call for e.g. restoreInput
# TODO make all widgets validate on shiny connect
# X hitting return on any widget messes up the display.
# TODO selectize input text colour is different.
# TODO selectize input, when typing in a potential value, text box remains small.
# TODO make sure can add/remove widgets using e.g. uiOutput.

# todo on inline_number
# x respect min/max/step
# x restrict to numbers
# x add default
# x add keyboard arrow up / down, page up/down, home, end
# x on arrow up/down from "Enter number" placeholder, go to default (not default +/- 1)
# guidance on what to enter for malformed input?
# setTimeout for fast change?

# TODO two handles in inline_slider (?)

# TODO inline_slider now rejects malformed text input and defaults to starting value.
# TODO there should be another param to inline_slider called default.
# TODO should input_number do the same if provided with a default and input is invalid (e.g. ".")
# TODO and input_text if input is invalid (e.g. "" only? but what about " "?)

# https://stackoverflow.com/a/41389961

choices = list(`East Coast` = list(NY = "NY", NJ = "NJ", CT = "CT"), `West Coast` = list(
    WA = "WA", OR = "OR", CA = "CA"), Midwest = list(MN = "MN",
    WI = "WI", `<IA>` = "\"IA"))

ui = page_fixed(
    theme = bs_theme(version = 5, preset = "quartz"),

    h1("Inline widget test"),

    inline("My name is ", inline_text("myname", "Nick", "Enter text"), ", I am ",
        inline_number("myage", 38, 30, 50), " years old."),

    inline(uiOutput("greeting")),

    inline("The value of the slider is ", inline_slider("slider", 50, 0, 100), "."),

    inline("The main power generator is ",
        inline_switch("myswitch1", FALSE,
            on = span(class = "text-success", "Activated"),
            off = span(class = "text-danger", "Gathering dust")
        ), "."
    ),

    inline("Today's date is ", inline_date("mydate", "2025-08-01",
        format = "dd/mm/yyyy", daysofweekdisabled = c(0, 6),
        datesdisabled = as.Date(c("2025-08-26", "2025-08-27"))), "."),

    inline("Do action links ", inline_link("id0", "like this"),
        " and action buttons ", inline_button("id1", "like this", icon = shiny::icon("gears")),
        " already work?"),

    inline(inline_button("test_button", "Test", icon = shiny::icon("gear"))),

    inline(inline_button("link1", HTML("&nbsp;"), NULL), " -- ", inline_link("link2", NULL, icon("dog"), accent = "dark"), " -- ",
        inline_button("link3", "horse", NULL), " -- ", inline_link("link4", "cat", icon("cat"))),

    inline("Some fun cars include ", inline_select("test2", rownames(mtcars), multiple = TRUE), "."),
    inline("But the best car is the ", inline_select("test3", rownames(mtcars)), "."),
    inline("Group select ", inline_select("test4", choices), "."),

    uiOutput("link_count"),
    uiOutput("button_count"),
    uiOutput("slider_greeting"),
    uiOutput("date_greeting"),

    inline("It was the year of Our Lord ",
        inline_date("tale_date", "1775-07-01"),
        ". Spiritual revelations were conceded to ",
        inline_select("tale_country", c("England", "France", "Spain")),
        " at that favoured period, as at this. ",
        "Mrs. Southcott had recently attained her ",
        inline_number("tale_age", 25), "th blessed birthday, ",
        "of whom a prophetic private in the Life Guards had heralded the sublime appearance ",
        "by announcing that arrangements were made for the swallowing up of London and ",
        inline_text("tale_borough", "Westminster"), ". ",
        "Even the Cock-lane ghost had been laid only a round ",
        inline_slider("tale_years", 12, 2, 100), " of years, ",
        "after rapping out its messages, as the spirits of this very year last past ",
        "(supernaturally deficient in originality) ",
        inline_button("tale_button", "rapped out"), " theirs. ",
        "Mere messages in the earthly order of events had lately come to the ",
        "English Crown and People, from a congress of British subjects in ",
        inline_switch("tale_usa", FALSE, "THE USA", "America"), ": ",
        "which, strange to relate, have proved more important to the human race ",
        "than any communications yet received through any of the chickens ",
        "of the Cock-lane brood.")
)

classes = function(x) {
    paste0(" (", paste0(class(x), collapse = "/"), ")")
}

server = function(input, output, session) {
    output$greeting = renderUI({ paste0("Hello, ", input$myname, classes(input$myname),
        ", age ", input$myage, classes(input$myage), "!") })

    output$link_count = renderUI({ paste0("Link count is ", input$id0, classes(input$id0), "!") })
    output$button_count = renderUI({ paste0("Button count is ", input$id1, classes(input$id1), "!") })
    output$slider_greeting = renderUI({ if (is.null(input$slider)) "null" else paste0("There are ",
        input$slider, classes(input$slider), " things!") })
    output$date_greeting = renderUI({ if (is.null(input$mydate)) "null" else paste0("Date is ",
        input$mydate, classes(input$mydate), ".") })

    shiny::observeEvent(input$test_button, {
        update_inline("link1", label = HTML("<strong>No&nbsp;animal</strong>"))
        update_inline("link2", label = shiny::tags$strong("doggo"), icon = icon("paw"), accent = NULL)
        update_inline("link3", label = "horsieeeee")
        update_inline("link4", icon = icon("shield-cat"), accent = "danger")

        update_inline("myswitch1", value = TRUE, on = span(class = "text-info", "It's on"),
            off = span(class = "text-secondary", "It's off"))

        update_inline("myname", value = "Nork", placeholder = span(class = "text-danger", "Enter your name"))
        update_inline("myage", value = 40, min = NULL, max = NULL, step = 10)
        update_inline("slider", value = 45, min = 25, max = 75, step = NULL)

        update_inline("tale_country", choices = c("England", "Wales"))

        update_inline("mydate", min = as.Date("2025-08-01"), max = as.Date("2025-08-31"), value = NULL,
            daysofweekdisabled = NULL, datesdisabled = "2025-08-25")
    })
}

shinyApp(ui, server)

