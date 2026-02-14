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
    widget = coalesce(shiny::textInput(inputId = id, label = NULL, value = value,
        width = NULL, placeholder = placeholder, updateOn = "change"))

    # Check structure is as expected
    check_tags(widget, shiny::div(shiny::tags$label(), shiny::tags$input()),
        "shiny::textInput()")

    # Modify text input
    # ARIA: https://developer.mozilla.org/en-US/docs/Web/Accessibility/ARIA/Reference/Roles/textbox_role
    tq = htmltools::tagQuery(widget)
    tq$each(rename_tag("span"))$ # change outer div to span
        removeClass("form-group")$
        removeClass("shiny-input-container")$ # remove padding
        addClass("inshiny-text-container") # text container class

    tq$find("label")$remove() # remove label
    tq$find("input")$
        each(rename_tag("span"))$ # input to span
        removeClass("shiny-input-text")$
        removeClass("form-control")$ # remove shiny input classes
        addClass("inshiny-nofocus")$
        addClass("inshiny-text-form")$ # add inshiny input classes
        removeAttrs(c("type", "value", "placeholder", "data-update-on"))$ # remove attributes
        addAttrs(
            "contenteditable" = NA, # add contenteditable
            "tabindex" = 0, # ensure tabbable
            "role" = "textbox", # accessibility
            "aria-placeholder" = placeholder, # accessibility
            "aria-label" = meaning # accessibility
        )
    widget = tq$allTags()
    widget$children[[1]]$children = list(value)
    widget$children = c(widget$children,
        list(
            shiny::span(class = "inshiny-text-placeholder text-info", `aria-hidden` = "true", placeholder),
            shiny::span(class = "form-control inshiny-text-box", `aria-hidden` = "true"),
            shiny::span(class = "inshiny-text-rightpadding", `aria-hidden` = "true")
        )
    )

    return (widget)
}
