#' Inline slider input
#'
#' A numeric input with a slider pop-up similar to [shiny::sliderInput()] that
#' can be included in an [inline()] wrapper.
#'
#' @inheritParams inline_text
#' @param value The initial number.
#' @param min,max Minimum and maximum values. Both are required.
#' @param step A step value that the slider will use to jump between values
#'     between min and max.
#' @param default A default value to be used if the input is invalid or empty.
#' @inherit inline_text return
#' @seealso [shiny::sliderInput] for how the slider input works with your Shiny server.
#' @examples
#' ui <- bslib::page_fixed(
#'     shiny::h1("Pep talk"),
#'     inline("When you go out there tonight, give ",
#'         inline_slider("amount", 10, 0, 110, step = 1, default = 50,
#'             placeholder = "Enter a percentage.", meaning = "Percent to give"),
#'         "%.")
#' )
#' @export
inline_slider = function(id, value, min, max, step = NULL, default = value,
    placeholder = "Enter number", meaning = NULL)
{
    if (!is_number(min)) stop("min must be a number.")
    if (!is_number(max)) stop("max must be a number.")
    if (!is_number(value)) stop("value must be a number.")
    if (!is_number_or_null(step)) stop("step must be a number, or NULL.")
    if (value < min || value > max) stop("value must lie between min and max.")

    # Select an appropriate step for both slider and number.
    if (is.null(step)) {
        range = max - min;
        if (range < 2 || max != floor(max) || min != floor(min)) {
            step = 10 ^ round(log10(range / 100))
        } else {
            step = 1;
        }
    }

    slider_id = paste0("inshiny-slider-", id);

    # Get textbox (number input without up/down arrows)
    textbox = inline_number(id = id, value = value, min = min, max = max,
        step = step, default = default, placeholder = placeholder,
        meaning = meaning)$children[[2]]

    # Modify textbox
    tq = htmltools::tagQuery(textbox)
    tq$addAttrs(
        "data-bs-toggle" = "dropdown",
        "data-bs-auto-close" = "outside",
        "aria-expanded" = "false" # Gets updated by Bootstrap automatically
    )
    tq$find(".inshiny-number-form")$
        addClass("inshiny-with-slider")
    textbox = tq$allTags()

    # Get slider widget
    slider = coalesce(shiny::sliderInput(slider_id, label = NULL,
        min = min, max = max, value = value, step = step))

    # Modify widget
    # Note, needs label
    tq = htmltools::tagQuery(slider)
    tq$removeClass("form-group")
    tq$find("label")$addClass("inshiny-slider")
    slider = tq$allTags()

    shiny::span(class = "dropdown-center",
        textbox,
        shiny::div(
            class = "dropdown-menu p-3 rounded-3 border shadow", # TODO do I want shadow?
            slider
        )
    )
}
