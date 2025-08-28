#' Container for inline widgets
#'
#' Wrapper for a line (or paragraph) containing a mix of explanatory text and
#' inshiny inline widgets.
#'
#' @param ... Unnamed arguments: Inline widgets (such as [inline_text()]),
#'     character strings, or [HTML tags][htmltools::tag] that will appear next
#'     to each other in a line or paragraph. These are pasted together with no
#'     spaces between them, so add extra spaces to your character strings if
#'     needed. Named arguments (e.g. `style`) are additional attributes for the
#'     HTML [div][htmltools::div] tag wrapping the line.
#' @param class Extra classes to apply to the line. The default, `"mb-1"`, is a
#'     Bootstrap 5 class that adds a small amount of margin to the bottom of
#'     the line. You can use `"mb-0"` through `"mb-5"`, other
#'     [Bootstrap 5 spacing classes](https://getbootstrap.com/docs/5.3/utilities/spacing/),
#'     or anything else. For multiple classes, provide one space-separated
#'     string.
#' @return An HTML element to be included in your Shiny UI definition.
#' @examples
#' ui <- bslib::page_fixed(
#'     shiny::h1("Hello!"),
#'     inline("My name is ", inline_text("myname", "Sisyphus"), "."),
#'     inline("Please enter your name carefully.", style = "font-weight:bold")
#' )
#' @export
inline = function(..., class = "mb-1")
{
    args = list(...)
    named = rlang::have_name(args)

    elements = lapply(args[!named],
        function(e) if (inherits(e, "shiny.tag")) e else shiny::span(e, class = "inshiny-span")
    )

    noWS(
        shiny::div(
            class = paste("inshiny-inline", class),
            !!!args[named],
            !!!elements,
            use_inshiny()
        )
    )
}
