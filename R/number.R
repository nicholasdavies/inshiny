#' Inline number input
#'
#' A single line numeric input similar to [shiny::numericInput()] that can be
#' included in an [inline()] wrapper.
#'
#' @inheritParams inline_text
#' @param value The initial number.
#' @param min,max Minimum and maximum values. Use `NULL` for no limit.
#' @param step A step value for incrementing and decrementing the number using
#'     the up or down arrow keys or with the clickable arrows on the widget. The
#'     Page Up and Page Down keys increment or decrement the number by 10 steps,
#'     and the Home and End keys set the number to the minimum or maximum
#'     respectively.
#' @param default A default value to be used if the input is invalid or empty.
#' @inherit inline_text return
#' @seealso [shiny::numericInput] for how the number input works with your Shiny server.
#' @examples
#' ui <- bslib::page_fixed(
#'     shiny::h1("Breakfast app (beta)"),
#'     inline("Make me an omelette with ",
#'         inline_number("eggs", 6, min = 2, max = 12, step = 1,
#'             placeholder = "6 (default)", meaning = "Number of eggs"),
#'         " eggs.")
#' )
#' @export
inline_number = function(id, value, min = NULL, max = NULL, step = NULL,
    default = value, placeholder = "Enter number", meaning = NULL)
{
    # TODO need to do full type checking for each argument, for all functions...
    # TODO check what happens with very small or very large numbers...
    if (!is_number(value))        stop("value must be a number.")
    if (!is_number_or_null(min))  stop("min must be a number or NULL.")
    if (!is_number_or_null(max))  stop("max must be a number or NULL.")
    if (!is_number_or_null(step)) stop("step must be a number or NULL.")

    # Modify numeric input
    # ARIA: https://developer.mozilla.org/en-US/docs/Web/Accessibility/ARIA/Reference/Roles/spinbutton_role
    widget = inline_text(id = id, value = value, placeholder = placeholder,
        meaning = meaning)
    append_class(widget, 1, "inshiny-number-form")
    change_attrib(widget, 1, "role", "spinbutton")
    change_attrib(widget, 1, "aria-valuenow", value)
    change_attrib(widget, 1, "aria-valuemin", min)
    change_attrib(widget, 1, "aria-valuemax", max)
    change_attrib(widget, 1, "data-default", default)
    change_attrib(widget, 1, "data-min", min)
    change_attrib(widget, 1, "data-max", max)
    change_attrib(widget, 1, "data-step", step)

    shiny::span(
        shiny::div(class = "inshiny-arrows",
            shiny::span(class = "inshiny-inc", `data-target-id` = id),
            shiny::span(class = "inshiny-dec", `data-target-id` = id)
        ),
        widget
    )
}
