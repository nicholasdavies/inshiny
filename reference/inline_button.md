# Inline action button

A button widget similar to
[`shiny::actionButton()`](https://rdrr.io/pkg/shiny/man/actionButton.html)
that can be included in an
[`inline()`](https://nicholasdavies.github.io/inshiny/reference/inline.md)
wrapper.

## Usage

``` r
inline_button(id, label, icon = NULL, meaning = label, accent = NULL)
```

## Arguments

- id:

  The `input` slot that will be used to access the value.

- label:

  The text appearing within the button. This can be a character string
  or any other HTML, or `NULL` for no text (but then you will probably
  at least want an `icon`).

- icon:

  An optional [`shiny::icon()`](https://rdrr.io/pkg/shiny/man/icon.html)
  which will appear to the left of the button.

- meaning:

  A descriptive label, for people using assistive technology such as
  screen readers.

- accent:

  A Bootstrap "accent" (such as `"primary"`, `"danger"`, etc.) that will
  be used to set the class of the button (such as `"btn-primary"`,
  etc.), or `NULL` for the default (`"btn-default"`). See [Bootstrap 5
  buttons](https://getbootstrap.com/docs/5.3/components/buttons/) for
  all the options. If you provide multiple accents in a character
  vector, each one will be appended to `"btn-"` and added to the button.

## Value

An inline widget to be included in an
[`inline()`](https://nicholasdavies.github.io/inshiny/reference/inline.md)
wrapper.

## See also

[shiny::actionButton](https://rdrr.io/pkg/shiny/man/actionButton.html)
for how the button works with your Shiny server.

## Examples

``` r
ui <- bslib::page_fixed(
    shiny::h1("A wonderful button"),
    inline("To update, please feel free to press the ",
        inline_button("mybutton",
            label = shiny::span(style = "font-style:italic", "button"),
            icon = shiny::icon("play"),
            meaning = "Update button", accent = "success"),
        "."
    )
)
```
