#' Update an inline widget
#'
#' Use this in your server code to change the parameters of an existing
#' inline widget. Most, but not all, parameters from the corresponding
#' `inline_*` functions can be changed. Note that while Shiny has a separate
#' update function for each type of widget (e.g. [shiny::updateTextInput] for
#' [shiny::textInput], etc.), the inshiny package has this single function to
#' update all types of inline widgets. This function can only be called in a
#' reactive context, and can only be called on `inline_*` widgets, not on
#' "built-in" Shiny widgets.
#'
#' See the documentation for each inline widget for details of how each
#' parameter is interpreted.
#'
#' When adjusting `min`, `max`, `datesdisabled`, or `daysofweekdisabled`, it
#' is recommended that you also send an update to `value` with the current
#' value of `input[[id]]` or any new value as applicable. This will ensure that
#' any invalid value gets highlighted in the app as invalid after accounting
#' for the new bounds and disallowed values.
#'
#' @param id The `id` of the inline widget to change.
#' @param session The currently active Shiny session. In almost all cases you
#'     can leave this to its default value.
#' @param value (date, number, select, slider, switch, text) The current value
#'     of the widget.
#' @param placeholder (date, number, slider, text) The character string or HTML
#'     element that will appear when the widget's textbox is empty, as a prompt.
#' @param meaning (all widgets) The descriptive label for people using assistive
#'     technology such as screen readers.
#' @param label,icon (button, link) The label and icon that appear in the
#'     button or link.
#' @param accent (button, link) The Boostrap accent to apply to the button or
#'     link.
#' @param min,max (date, number, slider) The minimum and maximum allowable
#'     value.
#' @param step (number, slider) The increment or decrement by which to change
#'     the value.
#' @param default (number, slider) The default value to assume when the input
#'     is blank or invalid.
#' @param on,off (switch) Labels to use for when the switch is on or off.
#' @param datesdisabled,daysofweekdisabled (date) Dates to make unselectable.
#' @param choices,selected (select) Options to choose from and current selection.
#' @return Nothing.
#' @examples
#' # Example UI setup
#' ui <- bslib::page_fixed(
#'     inline(
#'         inline_button("mybutton", "Button"),
#'         inline_date("mydate"),
#'         inline_link("mylink", "Link"),
#'         inline_number("mynumber", 42),
#'         inline_select("myselect", letters),
#'         inline_slider("myslider", 42, 0, 100),
#'         inline_switch("myswitch", TRUE),
#'         inline_text("mytext")
#'     )
#' )
#'
#' # This covers all updatable attributes except `meaning` (all widgets) and
#' # `placeholder` (date, number, slider, text).
#' server <- function(input, output) {
#'     update_inline("mybutton", label = "Click me", icon = shiny::icon("recycle"),
#'         accent = "info")
#'     update_inline("mydate", value = "2026-01-01", min = "2025-01-01",
#'         max = "2026-12-31", datesdisabled = "2025-12-25",
#'         daysofweekdisabled = c(0, 6))
#'     update_inline("mylink", label = "Click me", icon = shiny::icon("recycle"),
#'         accent = "info")
#'     update_inline("mynumber", value = 25, min = 20, max = 50, step = 5,
#'         default = 25)
#'     update_inline("myselect", choices = letters[1:5], selected = "c")
#'     update_inline("myslider", value = 25, min = 20, max = 50, step = 5,
#'         default = 25)
#'     update_inline("myswitch", value = TRUE, on = "Present", off = "Absent")
#'     update_inline("mytext", value = "Howdy")
#' }
#' @export
update_inline = function(id, session = shiny::getDefaultReactiveDomain(),
    value, placeholder, meaning,
    label, icon, accent,
    min, max, step, default,
    on, off,
    datesdisabled, daysofweekdisabled,
    choices, selected)
{
    # Validate session argument
    if (!inherits(session, c("ShinySession", "MockShinySession", "session_proxy"))) {
        stop("session must be a 'ShinySession' object.")
    }

    # Require id
    id

    # Populate message arguments
    args = list()
    args$id = arg_string(id)
    args$value = arg_value(value)
    args$placeholder = arg_html(placeholder)
    args$meaning = arg_string(meaning)
    args$accent = arg_string(accent)
    args$label = arg_html(label)
    args$icon = arg_html(icon)
    args$min = arg_value(min)
    args$max = arg_value(max)
    args$step = arg_number(step)
    args$default = arg_value(default)
    args$on = arg_html(on)
    args$off = arg_html(off)
    args$datesdisabled = arg_whatever(datesdisabled)
    args$daysofweekdisabled = arg_whatever(daysofweekdisabled)

    # Special logic for choices and selected
    if (!missing(choices) && !missing(selected)) {
        # change choices and selected (send selected as value)
        details = select_details(id, choices, selected, multiple = FALSE);
        args$choices = details$items
        args$value = details$selected
    } else if (!missing(choices) && missing(selected)) {
        # change choices, maintain currently-selected item if still present
        details = select_details(id, choices, session$input[[id]], multiple = FALSE);
        args$choices = details$items
    } else if (!missing(selected)) {
        # send selected as value
        args$value = arg_string(selected)
    }

    # Send update message
    session$sendCustomMessage("inshiny-update", args);

    return (invisible())
}

# Argument checkers for update_inline above

# argument can be anything
arg_whatever = function(x)
{
    if (missing(x)) {
        return (NULL)
    } else if (is.null(x)) {
        return (NA)
    }
    return (x)
}

# argument is a scalar character string
arg_string = function(x)
{
    if (missing(x)) {
        return (NULL)
    } else if (is.null(x)) {
        return (NA)
    } else if (!rlang::is_string(x)) {
        stop("Expecting string for parameter ", as.character(substitute(x)))
    }
    return (x[[1]])
}

# argument can be coerced to number
arg_number = function(x)
{
    if (missing(x)) {
        return (NULL)
    } else if (is.null(x)) {
        return (NA)
    }
    x = as.numeric(x)
    if (length(x) != 1 || !is.finite(x)) {
        stop("Expecting number for parameter ", as.character(substitute(x)))
    }
    return (x[[1]])
}

# argument is a value
arg_value = function(x)
{
    if (missing(x)) {
        return (NULL)
    } else if (is.null(x)) {
        return (NA)
    } else if (inherits(x, "Date")) {
        x = as.character(x)
    }

    if (!((is.numeric(x) && is.finite(x)) || is.character(x) || is.logical(x)) ||
            is.na(x) || length(x) != 1) {
        stop("Expecting numeric, character, logical, or Date value for parameter ",
            as.character(substitute(x)))
    }
    return (x[[1]])
}

# argument is html that can be coerced to a scalar character string
arg_html = function(x)
{
    if (missing(x)) {
        return (NULL)
    } else if (is.null(x)) {
        return (NA)
    }
    x = as.character(x)
    if (!rlang::is_string(x)) {
        stop("Expecting html for parameter ", as.character(substitute(x)))
    }
    return (shiny::HTML(x[[1]]))
}
