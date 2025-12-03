# Inline slider input

A numeric input with a slider pop-up similar to
[`shiny::sliderInput()`](https://rdrr.io/pkg/shiny/man/sliderInput.html)
that can be included in an
[`inline()`](https://nicholasdavies.github.io/inshiny/reference/inline.md)
wrapper.

## Usage

``` r
inline_slider(
  id,
  value,
  min,
  max,
  step = NULL,
  default = value,
  placeholder = "Enter number",
  meaning = NULL
)
```

## Arguments

- id:

  The `input` slot that will be used to access the value.

- value:

  The initial number.

- min, max:

  Minimum and maximum values. Both are required.

- step:

  A step value that the slider will use to jump between values between
  min and max.

- default:

  A default value to be used if the input is invalid or empty.

- placeholder:

  The character string or HTML element that will appear in the textbox
  when it is empty, as a prompt.

- meaning:

  A descriptive label, for people using assistive technology such as
  screen readers.

## Value

An inline widget to be included in an
[`inline()`](https://nicholasdavies.github.io/inshiny/reference/inline.md)
wrapper.

## See also

[shiny::sliderInput](https://rdrr.io/pkg/shiny/man/sliderInput.html) for
how the slider input works with your Shiny server.

## Examples

``` r
ui <- bslib::page_fixed(
    shiny::h1("Pep talk"),
    inline("When you go out there tonight, give ",
        inline_slider("amount", 10, 0, 110, step = 1, default = 50,
            placeholder = "Enter a percentage.", meaning = "Percent to give"),
        "%.")
)
```
