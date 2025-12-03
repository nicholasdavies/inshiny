# Container for inline widgets

Wrapper for a line (or paragraph) containing a mix of explanatory text
and inshiny inline widgets.

## Usage

``` r
inline(..., class = "mb-1")
```

## Arguments

- ...:

  Unnamed arguments: Inline widgets (such as
  [`inline_text()`](https://nicholasdavies.github.io/inshiny/reference/inline_text.md)),
  character strings, or [HTML
  tags](https://rstudio.github.io/htmltools/reference/builder.html) that
  will appear next to each other in a line or paragraph. These are
  pasted together with no spaces between them, so add extra spaces to
  your character strings if needed. Named arguments (e.g. `style`) are
  additional attributes for the HTML
  [div](https://rstudio.github.io/htmltools/reference/builder.html) tag
  wrapping the line.

- class:

  Extra classes to apply to the line. The default, `"mb-1"`, is a
  Bootstrap 5 class that adds a small amount of margin to the bottom of
  the line. You can use `"mb-0"` through `"mb-5"`, other [Bootstrap 5
  spacing
  classes](https://getbootstrap.com/docs/5.3/utilities/spacing/), or
  anything else. For multiple classes, provide one space-separated
  string.

## Value

An HTML element to be included in your Shiny UI definition.

## Examples

``` r
ui <- bslib::page_fixed(
    shiny::h1("Hello!"),
    inline("My name is ", inline_text("myname", "Sisyphus"), "."),
    inline("Please enter your name carefully.", style = "font-weight:bold")
)
```
