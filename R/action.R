#' Inline action link
#'
#' A link widget similar to [shiny::actionLink()] that can be included in an
#' [inline()] wrapper.
#'
#' @inheritParams inline_text
#' @param label The text appearing within the link. This can be a character
#'     string or any other HTML, or `NULL` for no text (but then you will
#'     probably at least want an `icon`).
#' @param icon An optional [shiny::icon()] which will appear to the left of the
#'     link.
#' @param accent A Bootstrap "accent" (such as `"primary"`, `"danger"`, etc.)
#'     that will be used to set the class of the link (such as `"link-primary"`,
#'     etc.), or `NULL` for no special styling. See
#'     [Bootstrap 5 link utilities](https://getbootstrap.com/docs/5.3/utilities/link/)
#'     for all the options. If you provide multiple accents in a character
#'     vector, each one will be appended to `"link-"` and added to the link.
#' @inherit inline_text return
#' @seealso [shiny::actionLink] for how the link works with your Shiny server.
#' @examples
#' ui <- bslib::page_fixed(
#'     shiny::h1("Link examples"),
#'     inline("These are ", inline_link("link1", "some"), " ",
#'         inline_link("link2", "increasingly", accent = "danger"), " ",
#'         inline_link("link3", "fancy", accent = c("success", "underline-warning", "offset-2")), " ",
#'         inline_link("link4", "links", icon = shiny::icon("link"), accent = "info"), "!")
#' )
#' @export
inline_link = function(id, label, icon = NULL, meaning = label, accent = NULL)
{
    # Make base link
    # ARIA: https://developer.mozilla.org/en-US/docs/Web/Accessibility/ARIA/Reference/Roles/link_role
    widget = coalesce(shiny::actionLink(inputId = id, label = label, icon = icon,
        `aria-label` = meaning, class = if (!is.null(accent)) {
                paste0("inshiny-link ", paste0("link-", accent, collapse = " "))
            } else "inshiny-link"))

    # Check structure is as expected
    check_tags(widget, shiny::a(any_tags()), "shiny::actionLink()")

    return (widget)
}

#' Inline action button
#'
#' A button widget similar to [shiny::actionButton()] that can be included in an
#' [inline()] wrapper.
#'
#' @inheritParams inline_text
#' @param label The text appearing within the button. This can be a character
#'     string or any other HTML, or `NULL` for no text (but then you will
#'     probably at least want an `icon`).
#' @param icon An optional [shiny::icon()] which will appear to the left of the
#'     button.
#' @param accent A Bootstrap "accent" (such as `"primary"`, `"danger"`, etc.)
#'     that will be used to set the class of the button (such as `"btn-primary"`,
#'     etc.), or `NULL` for the default (`"btn-default"`). See
#'     [Bootstrap 5 buttons](https://getbootstrap.com/docs/5.3/components/buttons/)
#'     for all the options. If you provide multiple accents in a character
#'     vector, each one will be appended to `"btn-"` and added to the button.
#' @inherit inline_text return
#' @seealso [shiny::actionButton] for how the button works with your Shiny server.
#' @examples
#' ui <- bslib::page_fixed(
#'     shiny::h1("A wonderful button"),
#'     inline("To update, please feel free to press the ",
#'         inline_button("mybutton",
#'             label = shiny::span(style = "font-style:italic", "button"),
#'             icon = shiny::icon("play"),
#'             meaning = "Update button", accent = "success"),
#'         "."
#'     )
#' )
#' @export
inline_button = function(id, label, icon = NULL, meaning = label, accent = NULL)
{
    # Build accent class
    accent_class = if (is.null(accent)) "btn-default" else paste0("btn-", accent, collapse = " ")

    # Make base button
    # ARIA: https://developer.mozilla.org/en-US/docs/Web/Accessibility/ARIA/Reference/Roles/button_role
    widget = coalesce(shiny::actionButton(inputId = id, label = label, icon = icon,
        `aria-label` = meaning))

    # Check structure is as expected
    check_tags(widget, shiny::tags$button(any_tags()), "shiny::actionButton()")

    # Modify button
    tq = htmltools::tagQuery(widget)
    tq$removeClass("btn-default")$
        addClass(accent_class)$
        addClass("inshiny-btn")$
        removeAttrs("type")$
        addAttrs("type" = "button")
    widget = tq$allTags()

    # Construct spacer with same contents as button
    spacer = shiny::span(class = "inshiny-btn-spacer")
    spacer$children = widget$children

    # The btn-container limits the dimensions of the button to the text height.
    # The btn is the button itself, inset within the btn-container.
    # The btn-spacer stretches the btn-container horizontally so there is
    # enough room for the button's label to fit inside.
    shiny::span(class = paste0("btn ", accent_class, " inshiny-btn-container"),
        widget,
        spacer
    )
}
