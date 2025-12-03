# Inline on/off switch

An on/off switch widget similar to
[`bslib::input_switch()`](https://rstudio.github.io/bslib/reference/input_switch.html)
that can be included in an
[`inline()`](https://nicholasdavies.github.io/inshiny/reference/inline.md)
wrapper.

## Usage

``` r
inline_switch(id, value, on = "On", off = "Off", meaning = NULL)
```

## Arguments

- id:

  The `input` slot that will be used to access the value.

- value:

  Whether the switch is initially off or on; `FALSE` for off, `TRUE` for
  on.

- on, off:

  Labels that will appear to the right of the switch when the switch is
  on or off, respectively. These can be character strings or HTML
  elements. For example, you can style these with a
  [span](https://rstudio.github.io/htmltools/reference/builder.html) and
  apply one of the [Bootstrap 5 text color
  classes](https://getbootstrap.com/docs/5.3/utilities/colors/) (see
  examples). `NULL` for no labels.

- meaning:

  A descriptive label, for people using assistive technology such as
  screen readers.

## Value

An inline widget to be included in an
[`inline()`](https://nicholasdavies.github.io/inshiny/reference/inline.md)
wrapper.

## See also

[bslib::input_switch](https://rstudio.github.io/bslib/reference/input_switch.html)
for how the switch works with your Shiny server.

## Examples

``` r
ui <- bslib::page_fixed(
    shiny::h1("Switch test"),
    inline("The server is now ",
        inline_switch("myswitch", TRUE,
            on = shiny::span(class = "text-success", "powered ON"),
            off = shiny::span(class = "text-danger", "powered OFF"),
            meaning = "Server power switch"),
        "."
    )
)
```
