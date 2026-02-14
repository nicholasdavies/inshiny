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

#########################
# TAG EDITING FUNCTIONS #
#########################

# These are used extensively in inshiny to "start from" a Shiny or bslib widget
# and then edit them to work with inshiny. The intention is for this to make it
# easier to maintain the package in the event that the Shiny or bslib
# implementations of the base widgets changes.

.tag.idx = list(
    nil = NULL,
    name = which(names(shiny::a()) == "name"),
    attribs = which(names(shiny::a()) == "attribs"),
    children = which(names(shiny::a()) == "children")
)

# Turns e.g. c(1, 4), "name" into c(3, 1, 3, 4, 1) - for indexing children of shiny.tags
idx2 = function(idx, final = "nil")
{
    if (length(idx)) {
        idx = rep(idx, each = 2)
        idx[seq(1, length(idx), 2)] = .tag.idx$children
    }
    return (c(idx, .tag.idx[[final]]))
}

attrib = function(html, idx, name)
{
    html[[idx2(idx, "attribs")]][[name]]
}

do_assign = function(a, b, env)
{
    assignment = rlang::expr(a <- b)
    assignment[2] <- list(rlang::get_expr(rlang::enquo(a)))
    assignment[3] <- list(rlang::get_expr(rlang::enquo(b)))
    eval(assignment, env)
}

change_name = function(html, idx, name, .env = parent.frame())
{
    lhs = substitute(html)
    do_assign(
        (!!lhs)[[!!idx2(idx, "name")]],
        !!name,
        .env
    )
    return (invisible())
}

change_attrib = function(html, idx, name, val, .env = parent.frame())
{
    if (rlang::is_scalar_logical(val) && !is.na(val)) {
        val = if (val) "true" else "false"
    }
    lhs = substitute(html)
    do_assign(
        (!!lhs)[[!!idx2(idx, "attribs")]][[!!name]],
        !!val,
        .env
    )
    return (invisible())
}

append_class = function(html, idx, classes, .env = parent.frame())
{
    class = attrib(html, idx, "class")
    for (cl in classes) {
        if (is.null(class)) {
            class = cl
        } else if (!grepl(cl, class, fixed = TRUE)) {
            class = paste(class, cl)
        }
    }
    do.call(change_attrib, list(substitute(html), idx, "class", class, .env))
}

remove_class = function(html, idx, classes, .env = parent.frame())
{
    class = attrib(html, idx, "class")
    for (cl in classes) {
        class = stringr::str_squish(stringr::str_remove_all(class, cl))
    }
    if (class == "") class = NULL
    do.call(change_attrib, list(substitute(html), idx, "class", class, .env))
}

insert_child = function(html, idx, child, .env = parent.frame())
{
    lhs = substitute(html)
    idx2 = idx2(idx)
    idx_head = idx2[-length(idx2)]
    idx_tail = idx2[length(idx2)]
    idx_pre = rlang::seq2(1, idx_tail - 1)
    idx_post = rlang::seq2(idx_tail, length(html[[idx_head]]))
    do_assign(
        (!!lhs)[[!!idx_head]],
        c(  (!!lhs)[[!!idx_head]][!!idx_pre],
            list(!!child),
            (!!lhs)[[!!idx_head]][!!idx_post]  ),
        .env
    )
    return (invisible())
}

replace_child = function(html, idx, child, .env = parent.frame())
{
    lhs = substitute(html)
    do_assign(
        (!!lhs)[[!!idx2(idx)]],
        !!child,
        .env
    )
    return (invisible())
}

remove_child = function(html, idx, .env = parent.frame())
{
    do.call(replace_child, list(substitute(html), idx, NULL, .env))
}
