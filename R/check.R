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
    widget = coalesce(bslib::input_switch(id = id, label = NULL,
        value = value, width = NULL))

    # Check structure is as expected
    check_tags(widget,
        shiny::div(shiny::div(shiny::tags$input(), shiny::tags$label(shiny::span()))),
        "bslib::input_switch()")

    # Modify switch
    # ARIA: https://developer.mozilla.org/en-US/docs/Web/Accessibility/ARIA/Reference/Roles/switch_role
    tq = htmltools::tagQuery(widget)

    tq$each(rename_tag("span"))$ # top-level <div>: change to span
        removeClass(c("form-group", "shiny-input-container")) # remove padding

    tq$find(".bslib-input-switch")$ # get inner <div>
        addClass("inshiny-switch-container")$ # mark as inshiny switch container for styling
        each(rename_tag("span")) # change to span

    tq$find(".bslib-input-switch > input")$ # get <input> tag
        addClass("inshiny-switch")$ # mark as inshiny switch for styling/JS
        addAttrs(
            "aria-label" = meaning, # accessibility
            "aria-checked" = boolean(value), # accessibility
            "data-label-id" = label_id, # attributes for JS
            "data-on-label" = on, # attributes for JS
            "data-off-label" = off # attributes for JS
        )

    tq$find(".bslib-input-switch > label")$remove() # remove <label> tag

    tq$append(shiny::span(id = label_id, if (value) on else off)) # insert status label

    # Return modified tag
    tq$allTags()
}
