library(shiny)
library(shinyjs)
library(bslib)

# TODO note all the restoreInput calls inside various bits; will have to
# adjust to this.

# TODO two handles in inline_slider (?)

# TODO inline_slider now rejects malformed text input and defaults to starting value.
# TODO there should be another param to inline_slider called default.
# TODO should input_number do the same if provided with a default and input is invalid (e.g. ".")
# TODO and input_text if input is invalid (e.g. "" only? but what about " "?)

# https://stackoverflow.com/a/41389961
js_code = R"--(
// For text and number
// copy the text from input to the span
document.addEventListener('input', event => {
    const target = event.target;
    if (!(target instanceof HTMLElement)) return;
    if (!target.matches('.resize-input')) return;

    // Add extra padding for numeric input handle
    var extra = "";
    if (target.matches('.resize-number')) extra = "00";

    // Resize hidden span so that the input's span width can be adjusted to its width
    target.previousElementSibling.textContent = (target.value || target.placeholder) + extra;

    // // Have a default value for numbers
    // if (target.matches('.resize-number') && !target.value) {
    //     Shiny.setInputValue(target.id, 42, { priority: "event" });
    // }
});

// Initialize all text and number inputs to the right width
Array.from(document.querySelectorAll('.resize-input')).forEach(input => {
    var extra = "";
    if (input.matches('.resize-number')) extra = "00";
    input.previousElementSibling.textContent = input.value + extra;
});

// For switches
$(".tweak-switch").on("change", function() {
    if ($(this).is(":checked")) {
        $("#" + $(this).data("label-id")).html($(this).data("on-label"));
    } else {
        $("#" + $(this).data("label-id")).html($(this).data("off-label"));
    }
});
)--"

js_code_slider = R"--(
to_number = function(x, deflt) {
    x = String(x).trim();
    var y = Number(x);
    if (isNaN(y) || x == "") return deflt;
    return y;
}

shinyjs.bindSlider = function(params) {
    var defaultParams = { slider_id: null };
    params = shinyjs.getParams(params, defaultParams);
    var textbox_id = "tweak-slider-text-" + params.slider_id;

    var slider = $(document.getElementById(params.slider_id)).data("ionRangeSlider");
    if (!slider) return;
    var textbox = document.getElementById(textbox_id);

    function update_textbox(data) {
        if (!$(textbox).data("dontChange")) {
            textbox.value = data.from;
            textbox.previousElementSibling.textContent = textbox.value || textbox.placeholder;
        }
    }

    // Keep label synced while dragging and on programmatic updates
    slider.update({
        onChange: update_textbox,
        onUpdate: update_textbox
    });

    textbox.addEventListener("input", function() {
        var deflt = to_number($(textbox).data("tweak-default"));
        var val = $(this).prop("value");
        $(textbox).css("background-color", "")

        if (val == "") {
            console.log("empty");
            $(textbox).data("dontChange", true);
            slider.update({ from: deflt });
            // Send a value to Shiny even if the slider is defocused and closed.
            Shiny.setInputValue(params.slider_id, deflt, { priority: "event" });
            $(textbox).data("dontChange", false);
            return;
        }

        // validate
        console.log(Number("") + "|" + Number("  "));
        val = to_number($(this).prop("value"), null);
        var out_of_range = true;
        if (val < slider.options.min) {
            val = slider.options.min;
        } else if (val > slider.options.max) {
            val = slider.options.max;
        } else if (val === null) {
            val = deflt;
        } else {
            out_of_range = false;
        }

        if (out_of_range) {
            $(textbox).css("background-color", "red")
            console.log("invalid " + val)
        } else {
            $(textbox).css("color", "")
            console.log("valid " + val)
        }

        $(textbox).data("dontChange", true)
        slider.update({ from: val });
        $(textbox).data("dontChange", false)

        // Send a value to Shiny even if the slider is defocused and closed.
        Shiny.setInputValue(params.slider_id, val, { priority: "event" });
    });
}
)--"

css_code = HTML(glue::glue(R"--(
.resize-container {
    display: inline-block;
    position: relative;
}

.resize-input,
.resize-text {
    margin: 0;
    padding: 0.1rem 0.5rem;
}

.resize-text {
    display: inline-block;
    visibility: hidden;
    white-space: pre;
}

.resize-input {
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
}

.selectize-dropdown {
    width: auto !important;
}

.selectize-dropdown [data-selectable], .selectize-dropdown .optgroup-header {
    white-space: nowrap;
}

.selectize-input {
    padding: 0.1rem 40px 0.1rem 0.5rem;
    min-height: 1rem;
    font-size: 100%;
    border-color: ${ bs_get_variables(bs_theme(), "primary") }
}

/* for multi select */

.selectize-control.multi .selectize-input > div {
    margin: 0 0.3rem 0 0;
    padding: 0 0.1rem;

    background-color: transparent;
    box-decoration-break: clone;
    background-image: linear-gradient(transparent 10%, rgba(0, 0, 0, 0.05) 10%, rgba(0, 0, 0, 0.05) 90%, transparent 90%);
    background-size: 100% 100%;
    background-repeat: no-repeat;
}

.selectize-control.multi .selectize-input.has-items {
    padding: 0.1rem 0rem 0.1rem 0.5rem;
}

)--", .open = "${"))

noWS = function(tag)
{
    if (inherits(tag, "shiny.tag")) {
        for (i in seq_along(tag$children)) {
            tag$children[[i]] = noWS(tag$children[[i]])
        }
        tag$.noWS = c("inside", "before", "after")
    }
    return (tag)
}

inline_text = function(id, value, placeholder = "Enter text")
{
    # form-group shiny-input-container seem to add some stylistic things
    # shiny-input-container expands width (not what we want)
    # form-group expands height (poss to fit in grid?)
    span(class = "resize-container",
        span(class = "resize-text border border-primary rounded focus-ring", "aria-hidden" = "true"),
        tags$input(
            id = id,
            # form-control makes font a bit smaller
            class = "shiny-input-text resize-input border border-primary rounded focus-ring",
            type = "text",
            value = value,
            placeholder = placeholder,
            autofocus = NA,
            `data-update-on` = "change" # can also be "blur"
        )
    )
}

# TODO add step, min, max.
inline_number = function(id, value, placeholder = "Enter number")
{
    # form-group shiny-input-container seem to add some stylistic things
    # shiny-input-container expands width (not what we want)
    # form-group expands height (poss to fit in grid?)
    span(class = "resize-container",
        span(class = "resize-text border border-primary rounded focus-ring", "aria-hidden" = "true"),
        tags$input(
            id = id,
            # form-control makes font a bit smaller
            class = "shiny-input-text resize-input resize-number border border-primary rounded focus-ring",
            type = "number",
            value = value,
            placeholder = placeholder,
            autofocus = NA,
            `data-update-on` = "change" # can also be "blur"
        )
    )
}

inline_date = function(inputId, value = NULL, min = NULL, max = NULL,
    format = "yyyy-mm-dd", startview = "month", weekstart = 0, language = "en",
    autoclose = TRUE, datesdisabled = NULL, daysofweekdisabled = NULL)
{
    div(id = id, class = "shiny-date-input resize-container", style = "display:inline-block",
        span(class = "resize-text border border-primary rounded focus-ring", "aria-hidden" = "true"),
        tags$input(
            type = "text",
            class = "resize-input border border-primary rounded focus-ring",
            #aria-labelledby="mydate-label",
            `aria-label` = "Date",
            title = paste("Date format:", format), `data-date-language` = language,
            `data-date-week-start` = weekstart,
            `data-date-format` = format,
            `data-date-start-view` = startview,
            `data-min-date` = min,
            `data-max-date` = max,
            `data-initial-date` = value,
            `data-date-autoclose` = if (autoclose) "true" else "false",
            `data-date-dates-disabled` = jsonlite::toJSON(datesdisabled, null = "null"),
            `data-date-days-of-week-disabled` = jsonlite::toJSON(daysofweekdisabled, null = "null")),
        shiny:::datePickerDependency()
    )
}

inline_select = function(id, choices, multiple = FALSE)
{
    selected = choices[[1]]

    # Note. This div has to be contained in a div for the correct layout.
    div(
        style = "display: inline-block",
        tag("select", list(
            id = id,
            class = "shiny-input-select",
            multiple = if (multiple) "multiple" else NULL,
            lapply(choices, function(ch) tags$option(value = ch,
                selected = if (ch == selected) NA else NULL, ch))
        )),
        tags$script(
            type = "application/json",
            `data-for` = id,
            `data-nonempty` = "",
            '{"plugins":["selectize-plugin-a11y"]}'
        )
    )
}

inline_switch = function(id, value, on = "On", off = "Off")
{
    label_id = paste0("tweak-switch-label-", id)

    span(
        style = "display: inline-block",
        `data-require-bs-version` = "5",
        `data-require-bs-caller` = "input_switch()",
        span(
            class = "bslib-input-switch form-switch form-check",
            style = "margin-right: -5px; margin-bottom: 0px; display: inline-block; vertical-align: text-top; min-height: 0",
            tags$input(id = "id", class = "form-check-input tweak-switch", type = "checkbox", role = "switch",
                `data-label-id` = label_id, `data-on-label` = on, `data-off-label` = off)
        ),
        span(id = label_id, off)
    )
}

# Note that "border border-primary rounded" below aligns better. But "btn btn-outline-primary" adds a nice mouseover effect. Achieved with:
# transition: color 0.15s ease-in-out, background-color 0.15s ease-in-out, border-color 0.15s ease-in-out, box-shadow 0.15s ease-in-out;

inline_slider = function(id, min, max, value = min, step = NULL)
{
    if (!is.numeric(min)) stop("min must be numeric.")
    if (!is.numeric(max)) stop("max must be numeric.")
    if (!is.numeric(value)) stop("value must be numeric.")
    if (value < min || value > max) stop("value must lie between min and max.")

    slider_id = id;
    textbox_id = paste0("tweak-slider-text-", id);

    # Note: this removes some extra spacing at the bottom of the slider.
    slider = sliderInput(slider_id, label = NULL, min = min, max = max, value = value, step = step)
    slider$attribs$class = stringr::str_remove_all(slider$attribs$class, "form-group") |>
        stringr::str_trim()

    span(class = "dropdown-center resize-container",
        span(class = "resize-text border border-primary rounded focus-ring", "aria-hidden" = "true"),
        tags$input(
            id = textbox_id,
            # form-control makes font a bit smaller
            class = "shiny-input-text resize-input border border-primary rounded focus-ring",
            tabindex = 0,
            type = "text",
            `data-bs-toggle` = "dropdown",
            `data-bs-auto-close` = "outside",
            `data-tweak-default` = value,
            `aria-expanded` = "false",
            style = "padding: 0.1rem 0.5rem",
            value = value,
            placeholder = paste(value, "(default)"),
            autofocus = NA,
            `data-update-on` = "change" # can also be "blur"
        ),
        div(
            class = "dropdown-menu p-3 rounded-3 border shadow", # TODO do I want shadow?
            slider
        )
    )
}

inline_link = function(id, label, icon = NULL, ...)
{
    actionLink(inputId = id, label = label, icon = icon, ...)
}

inline_button = function(id, label, icon = NULL, ...)
{
    actionLink(inputId = id, label = label, icon = icon,
        style = "padding: 0.1rem 0.5rem; text-decoration: none",
        class = "border border-primary rounded bg-primary", ...)
}

inline = function(...)
{
    elements = list(...)
    noWS(tag("div", c(list(style = "margin-bottom: 0.5rem"),
        lapply(elements, function(e) if (inherits(e, "shiny.tag")) e else span(e))
    )))
}

fake = selectInput("fake_id", "no label", "a")
fake$attribs$style = "display: none"

ui = page_fixed(
    useShinyjs(),  # Include shinyjs
    extendShinyjs(text = js_code_slider, functions = c("bindSlider")),
    tags$head(
        tags$style(css_code)
    ),
    fake, # needed to initialize selectize.

    h1("Inline widget test"),

    inline("My name is ", inline_text("myname", "Nick"), ", I am ",
        inline_number("myage", 38), " years old."),

    inline(uiOutput("greeting")),

    inline("Some fun cars include ", inline_select("test2", rownames(mtcars), multiple = TRUE), "."),
    inline("But the best car is ", inline_select("test3", rownames(mtcars)), "."),

    inline("The main power generator is ",
        inline_switch("myswitch",
            on = span(style = "color: green", "Activated"),
            off = span(style = "color: red", "Gathering dust")
        ), "."
    ),

    inline("The value of the slider is ", inline_slider("slider", 0, 100, 50), "."),

    inline("Today's date is ", inline_date("mydate"), "."),

    br(), br(), br(), br(), br(),

    uiOutput("slider_greeting"),

    inline("Do action links ", inline_link("id0", "like this"),
        " and action buttons ", inline_button("id1", "like this"),
        " already work?"),

    br(), br(), br(), br(), br(),

    inline("It was the year of Our Lord ",
        inline_date("tale_date", "1775-07-01"),
        ". Spiritual revelations were conceded to ",
        inline_select("tale_country", c("England", "France", "Spain")),
        "at that favoured period, as at this. ",
        "Mrs. Southcott had recently attained her ",
        inline_number("tale_age", 25), "th blessed birthday, ",
        "of whom a prophetic private in the Life Guards had heralded the sublime appearance ",
        "by announcing that arrangements were made for the swallowing up of London and ",
        inline_text("tale_borough", "Westminster"), ". ",
        "Even the Cock-lane ghost had been laid only a round ",
        inline_slider("tale_years", 2, 100, 12), " of years, ",
        "after rapping out its messages, as the spirits of this very year last past ",
        "(supernaturally deficient in originality) rapped out theirs. ",
        "Mere messages in the earthly order of events had lately come to the ",
        "English Crown and People, from a congress of British subjects in ",
        inline_switch("tale_usa", FALSE, "THE USA", "America"), ": ",
        "which, strange to relate, have proved more important to the human race ",
        "than any communications yet received through any of the chickens ",
        "of the Cock-lane brood.")
)

server = function(input, output) {
    runjs(js_code)

    output$greeting = renderUI({ paste0("Hello, ", input$myname, " (age ", input$myage, ")!") })

    js$bindSlider(slider_id = "slider")
    js$bindSlider(slider_id = "tale_years")

    output$slider_greeting = renderUI({ if (is.null(input$slider)) "null" else paste0("There are ", input$slider, " things!") })
}

shinyApp(ui, server)

