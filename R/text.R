#' Inline text input
#'
#' A single line text input similar to [shiny::textInput()] that can be
#' included in an [inline()] wrapper.
#'
#' @param id The `input` slot that will be used to access the value.
#' @param value The initial text contents (a character string).
#' @param placeholder The character string or HTML element that will appear in
#'     the textbox when it is empty, as a prompt.
#' @param meaning A descriptive label, for people using assistive technology
#'     such as screen readers.
#' @return An inline widget to be included in an [inline()] wrapper.
#' @seealso [shiny::textInput] for how the text input works with your Shiny server.
#' @examples
#' ui <- bslib::page_fixed(
#'     shiny::h1("Hello!"),
#'     inline("My name is ", inline_text("myname", "Sisyphus",
#'         placeholder = "Enter your name", meaning = "Your name"), ".")
#' )
#' @export
inline_text = function(id, value = "", placeholder = "Enter text", meaning = NULL)
{
    # TODO Make this its own validation func
    placeholder = as.character(placeholder);
    if (length(placeholder) != 1 || is.na(placeholder) || stringr::str_trim(placeholder) == "") {
        placeholder = shiny::HTML("&nbsp;");
    }

    # Make base text input
    widget = shiny::textInput(inputId = id, label = NULL, value = value,
        width = NULL, placeholder = placeholder, updateOn = "change")

    # Check structure is as expected
    check_tags(widget, shiny::div(shiny::tags$label(), shiny::tags$input()),
        "shiny::textInput()")

    # Modify text input
    # ARIA: https://developer.mozilla.org/en-US/docs/Web/Accessibility/ARIA/Reference/Roles/textbox_role
    widget = coalesce(widget)
    change_name(widget, NULL, "span") # change outer div to span
    remove_class(widget, NULL, c("form-group", "shiny-input-container")) # remove padding
    append_class(widget, NULL, "inshiny-text-container") # text container class
    remove_child(widget, 1) # remove label
    change_name(widget, 1, "span") # input to span
    remove_class(widget, 1, c("shiny-input-text", "form-control")) # remove shiny input classes
    append_class(widget, 1, c("inshiny-nofocus", "inshiny-text-form")) # add inshiny input classes
    change_attrib(widget, 1, "type", NULL)
    change_attrib(widget, 1, "value", NULL)
    change_attrib(widget, 1, "placeholder", NULL)
    change_attrib(widget, 1, "data-update-on", NULL) # remove attributes
    change_attrib(widget, 1, "contenteditable", NA) # add contenteditable
    change_attrib(widget, 1, "tabindex", 0) # ensure tabbable
    change_attrib(widget, 1, "role", "textbox") # accessibility
    change_attrib(widget, 1, "aria-placeholder", placeholder) # accessibility
    change_attrib(widget, 1, "aria-label", meaning) # accessibility
    insert_child(widget, c(1, 1), value) # add contents of text control
    insert_child(widget, 2, shiny::span(class = "inshiny-text-placeholder text-info", `aria-hidden` = "true", placeholder))
    insert_child(widget, 3, shiny::span(class = "form-control inshiny-text-box", `aria-hidden` = "true"))
    insert_child(widget, 4, shiny::span(class = "inshiny-text-rightpadding", `aria-hidden` = "true"))

    return (widget)
}
