#' Inline select list input
#'
#' A select list input similar to [shiny::selectInput()] that can be
#' included in an [inline()] wrapper.
#'
#' @inheritParams inline_text
#' @param choices Vector or list of values to select from. Provide one of the
#'     following:
#'
#' * Use an unnamed character vector, such as `c("dog", "cat", "bee")`, for the
#'     most basic case, where you have a list of strings you want the user to
#'     select from.
#' * Use a named character vector, such as `c("Dog" = "dog",
#'     "Nice Kitty" = "cat", "Bee" = "bee")` if you want the options
#'     displayed to the user (the names; here, Dog, Nice Kitty, and Bee) to
#'     differ from the values passed to Shiny (the values; here, `"dog"`,
#'     `"cat"`, and `"bee"`).
#' * Use a named list, where each element is a "sub-list", to group the items
#'     under headings; the names at the top level of the list will be the
#'     heading titles and the "sub-lists" are the items appearing under that
#'     heading. For example, if you pass
#'     `list(Mammals = c("Dog" = "dog", "Nice Kitty" = "cat"),
#'     Invertebrates = c("Bee" = "bee"))` then Dog and Nice Kitty will appear
#'     under the Mammals heading, while Bee will appear under the Invertebrates
#'     heading, and the value passed to the Shiny server will be either
#'     `"dog"`, `"cat"`, or `"bee"`.
#' @param selected The initially selected option's value. If `NULL`, use the
#'     first item in `choices`.
#' @param multiple Whether to allow multiple selections. As of inshiny version
#'     0.1.0, the version of [inline_select] with `multiple = TRUE` looks and
#'     behaves a bit differently from the version of [inline_select] with
#'     `multiple = FALSE`. The package authors are working on eliminating this
#'     inconsistency.
#' @inherit inline_text return
#' @seealso [shiny::selectInput] for how the select input works with your Shiny server.
#' @examples
#' ui <- bslib::page_fixed(
#'     shiny::h1("Pet registration form"),
#'     inline("My ",
#'         inline_select("species", c("dog", "cat"), meaning = "Pet species"),
#'         "'s name is ",
#'         inline_select("name", list("Dog names" = c("Fido", "Rex"),
#'             "Cat names" = c("Felix", "Boots")), selected = "Rex"),
#'         ".")
#' )
#' @export
inline_select = function(id, choices, selected = NULL, multiple = FALSE, meaning = NULL)
{
    if (multiple) {
        return (inline_selectize(id, choices, selected, multiple, meaning))
    }

    drop_id = paste0("inshiny-list-drop-", id);
    menu_id = paste0("inshiny-list-menu-", id);

    # Format choices
    details = select_details(id, choices, selected, multiple);

    # Get textbox; this handles restoreInput
    textbox = inline_text(id, details$selected, placeholder = NULL, meaning = meaning)

    # Modify textbox
    textbox = coalesce(textbox)
    change_attrib(textbox, NULL, "id", drop_id)
    change_attrib(textbox, NULL, "data-bs-toggle", "dropdown")
    change_attrib(textbox, NULL, "data-bs-auto-close", "outside")
    change_attrib(textbox, NULL, "aria-expanded", "false")
    append_class(textbox, 1, "inshiny-list-form")
    append_class(textbox, 1, "inshiny-with-options")

    # TODO TEMP no data-default/data-value, remove contenteditable
    # change_attrib(textbox, 1, "data-default", details$selected)
    # change_attrib(textbox, 1, "data-value", details$selected)
    change_attrib(textbox, 1, "contenteditable", NULL)

    # Make menu
    menu = shiny::tags$ul(
        id = menu_id,
        class = "dropdown-menu p-1 rounded-3 border shadow inshiny-menu",
        style = "min-width: 1rem; max-height: 18.5rem; overflow-y: auto",
        details$items)

    shiny::span(class = "dropdown-center",
        textbox,
        menu
    )
}

# Format choices and selected for inline_select
select_details = function(id, choices, selected, multiple)
{
    # Build shiny::selectInput to get formatted options
    widget = shiny::selectInput(inputId = id, label = NULL, choices = choices,
        selected = selected, multiple = multiple, selectize = FALSE)

    # Check structure is as expected
    check_tags(widget, shiny::div(
        shiny::tags$label(),
        shiny::div(
            shiny::tags$select()
        )
    ), "shiny::selectInput()")

    # Extract formatted options
    options = widget$children[[2]]$children[[1]]$children[[1]];

    # Modify options to use Bootstrap dropdown menu instead of option tags
    options = stringr::str_split_1(options, "\n")
    templ0 = '<li><a class="dropdown-item inshiny-item" href="#" data-list="TX" data-item="\\1">\\2</a></li>';
    templ1 = '<li><a class="dropdown-item inshiny-item active" href="#" data-list="TX" data-item="\\1" selected>\\2</a></li>';
    templ0 = stringr::str_replace(templ0, "TX", id)
    templ1 = stringr::str_replace(templ1, "TX", id)

    # Get selected item(s)
    selected = stringr::str_match(options,
        '^<option value="([^"]*)" selected>([^<]*)</option>$')[,2]
    selected = selected[!is.na(selected)]

    # Continue modifying options
    items = stringr::str_replace_all(options, c(
        '^<option value="([^"]*)">([^<]*)</option>$' = templ0,
        '^<option value="([^"]*)" selected>([^<]*)</option>$' = templ1,
        '^<optgroup label="([^"]*)">$' = '<li><h6 class="dropdown-header">\\1</h6></li>'
    ))
    items = items[items != "</optgroup>"]
    items = shiny::HTML(paste0(items, collapse = "\n"))

    return (list(items = items, selected = selected))
}

# Select input that supports multiple selections.
inline_selectize = function(id, choices, selected = NULL, multiple = FALSE,
    meaning = NULL)
{
    # Make base select
    widget = shiny::selectInput(inputId = id, label = NULL, choices = choices,
        selected = selected, multiple = multiple)
    dep = attr(widget, "html_dependencies")

    # Check structure is as expected
    check_tags(widget, shiny::div(
        shiny::tags$label(),
        shiny::div(
            shiny::tags$select(),
            shiny::tags$script()
        )
    ), "shiny::selectInput()")

    # Modify select
    # TODO ARIA: https://developer.mozilla.org/en-US/docs/Web/Accessibility/ARIA/Reference/Roles/listbox_role
    widget = coalesce(widget)$children[[2]]
    append_class(widget, NULL, "inshiny-sel")
    change_attrib(widget, 1, "aria-label", meaning)

    # Construct spacer with set width
    spacer = shiny::span(class = "inshiny-sel-spacer", style = "width: 500px")

    # The sel-container limits the dimensions of the button to the text height.
    # The sel is the select itself, inset within the sel-container.
    # The sel-spacer stretches the sel-container horizontally so there is
    # enough room for the button's label to fit inside.
    structure(shiny::span(class = "inshiny-sel-container",
        widget,
        spacer
    ), html_dependencies = dep)
}

