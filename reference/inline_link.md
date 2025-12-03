# Inline action link

A link widget similar to
[`shiny::actionLink()`](https://rdrr.io/pkg/shiny/man/actionButton.html)
that can be included in an
[`inline()`](https://nicholasdavies.github.io/inshiny/reference/inline.md)
wrapper.

## Usage

``` r
inline_link(id, label, icon = NULL, meaning = label, accent = NULL)
```

## Arguments

- id:

  The `input` slot that will be used to access the value.

- label:

  The text appearing within the link. This can be a character string or
  any other HTML, or `NULL` for no text (but then you will probably at
  least want an `icon`).

- icon:

  An optional [`shiny::icon()`](https://rdrr.io/pkg/shiny/man/icon.html)
  which will appear to the left of the link.

- meaning:

  A descriptive label, for people using assistive technology such as
  screen readers.

- accent:

  A Bootstrap "accent" (such as `"primary"`, `"danger"`, etc.) that will
  be used to set the class of the link (such as `"link-primary"`, etc.),
  or `NULL` for no special styling. See [Bootstrap 5 link
  utilities](https://getbootstrap.com/docs/5.3/utilities/link/) for all
  the options. If you provide multiple accents in a character vector,
  each one will be appended to `"link-"` and added to the link.

## Value

An inline widget to be included in an
[`inline()`](https://nicholasdavies.github.io/inshiny/reference/inline.md)
wrapper.

## See also

[shiny::actionLink](https://rdrr.io/pkg/shiny/man/actionButton.html) for
how the link works with your Shiny server.

## Examples

``` r
ui <- bslib::page_fixed(
    shiny::h1("Link examples"),
    inline("These are ", inline_link("link1", "some"), " ",
        inline_link("link2", "increasingly", accent = "danger"), " ",
        inline_link("link3", "fancy", accent = c("success", "underline-warning", "offset-2")), " ",
        inline_link("link4", "links", icon = shiny::icon("link"), accent = "info"), "!")
)
```
