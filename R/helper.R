# Helper to rename a tag using tagQuery
rename_tag = function(new_name) function(el, i) {
    el$name = new_name
    el
}

# Helper to render TRUE or FALSE as "true" or "false" for ARIA
boolean = function(tf)
{
    if (is.na(tf))
        "mixed"
    else if (tf)
        "true"
    else
        "false"
}

# Returns TRUE if we are in continuous integration.
in_CI = function()
{
    Sys.getenv("CI") != ""
}

# Some helper functions for argument validation.
is_number = function(x)
{
    rlang::is_scalar_double(x) && is.finite(x)
}

is_number_or_null = function(x)
{
    is_number(x) || is.null(x)
}

# Remove all whitespace from some html.
noWS = function(html)
{
    if (inherits(html, "shiny.tag")) {
        for (i in seq_along(html$children)) {
            html$children[[i]] = noWS(html$children[[i]])
        }
        html$.noWS = c("inside", "before", "after")
    }
    return (html)
}

any_tags = function()
{
    shiny::tag("any", list())
}

# Confirm that an html object conforms to the same structure as a template.
check_tags = function(html, template, name)
{
    if (in_CI()) {
        if (!inherits(html, "shiny.tag") || !inherits(template, "shiny.tag")) {
            stop("Unexpected tag structure from ", name,
                ". Please contact the package maintainer.")
        }

        result = check_tags0(list(html), list(template))
        if (!result) {
            stop("Unexpected tag structure from ", name,
                ". Please contact the package maintainer.")
        }
    }
}

check_tags0 = function(html, template)
{
    # Allow skip
    if (length(template) == 1 && template[[1]]$name == "any") return (TRUE)

    # Check number of tags
    tags_idx = which(vapply(html, function(t) inherits(t, "shiny.tag"), logical(1)))
    if (length(tags_idx) != length(template)) return (FALSE)

    # Check names of tags
    for (i in seq_along(template))
    {
        j = tags_idx[i]
        if (html[[j]]$name != template[[i]]$name) return (FALSE)
        if (!check_tags0(html[[j]]$children, template[[i]]$children)) return (FALSE)
    }

    return (TRUE)
}

# Coalesce all classes on an HTML tag
coalesce = function(html)
{
    if (!inherits(html, "shiny.tag")) {
        return (html)
    }

    class_idx = which(names(html$attribs) == "class")
    if (length(class_idx) > 1) {
        newclass = paste(html$attribs[class_idx], collapse = " ")
        html$attribs[[class_idx[1]]] = newclass
        html$attribs = html$attribs[-class_idx[-1]]
    }

    if (anyDuplicated(names(html$attribs))) {
        stop("Multiple non-class attribs on tag ", html$name,
        ": ", paste(duplicated(names(html$attribs)), collapse = ", "))
    }

    for (i in rev(seq_along(html$children))) {
        if (is.null(html$children[[i]])) {
            html$children[[i]] = NULL # prune any NULL children
        } else {
            html$children[[i]] = coalesce(html$children[[i]])
        }
    }

    return (html)
}
