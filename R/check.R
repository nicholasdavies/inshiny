#' Inline on/off switch
#'
#' An on/off switch widget similar to [bslib::input_switch()] that can be
#' included in an [inline()] wrapper.
#'
#' @inheritParams inline_text
#' @param value Whether the switch is initially off or on; `FALSE` for off,
#'     `TRUE` for on.
#' @param on,off Labels that will appear to the right of the switch when the
#'     switch is on or off, respectively. These can be character strings or
#'     HTML elements. For example, you can style these with a
#'     [span][htmltools::span] and apply one of the
#'     [Bootstrap 5 text color classes](https://getbootstrap.com/docs/5.3/utilities/colors/)
#'     (see examples). `NULL` for no labels.
#' @inherit inline_text return
#' @seealso [bslib::input_switch] for how the switch works with your Shiny server.
#' @examples
#' ui <- bslib::page_fixed(
#'     shiny::h1("Switch test"),
#'     inline("The server is now ",
#'         inline_switch("myswitch", TRUE,
#'             on = shiny::span(class = "text-success", "powered ON"),
#'             off = shiny::span(class = "text-danger", "powered OFF"),
#'             meaning = "Server power switch"),
#'         "."
#'     )
#' )
#' @export
inline_switch = function(id, value, on = "On", off = "Off",
    meaning = NULL)
{
    label_id = paste0("inshiny-switch-label-", id)

    # Make base switch
    widget = bslib::input_switch(id = id, label = NULL,
        value = value, width = NULL)

    # Check structure is as expected
    check_tags(widget,
        shiny::div(shiny::div(shiny::tags$input(), shiny::tags$label(shiny::span()))),
        "bslib::input_switch()")

    # Modify switch
    # ARIA: https://developer.mozilla.org/en-US/docs/Web/Accessibility/ARIA/Reference/Roles/switch_role
    widget = coalesce(widget)
    change_name(widget, NULL, "span") # change div to span
    remove_class(widget, NULL, c("form-group", "shiny-input-container")) # remove padding
    change_name(widget, 1, "span") # change inner div to span
    append_class(widget, 1, "inshiny-switch-container") # mark as inshiny switch container for styling
    append_class(widget, c(1, 1), "inshiny-switch") # mark as inshiny switch for styling / JS
    change_attrib(widget, c(1, 1), "aria-label", meaning) # accessibility
    change_attrib(widget, c(1, 1), "aria-checked", value) # accessibility
    change_attrib(widget, c(1, 1), "data-label-id", label_id) # attributes for JS
    change_attrib(widget, c(1, 1), "data-on-label", on) # ditto
    change_attrib(widget, c(1, 1), "data-off-label", off) # ditto
    remove_child(widget, c(1, 2)) # delete <label>
    insert_child(widget, 2, shiny::span(id = label_id, if (value) on else off)) # insert status label

    return (widget)
}
