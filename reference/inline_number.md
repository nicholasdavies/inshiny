# Inline number input

A single line numeric input similar to
[`shiny::numericInput()`](https://rdrr.io/pkg/shiny/man/numericInput.html)
that can be included in an
[`inline()`](https://nicholasdavies.github.io/inshiny/reference/inline.md)
wrapper.

## Usage

``` r
inline_number(
  id,
  value,
  min = NULL,
  max = NULL,
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

  Minimum and maximum values. Use `NULL` for no limit.

- step:

  A step value for incrementing and decrementing the number using the up
  or down arrow keys or with the clickable arrows on the widget. The
  Page Up and Page Down keys increment or decrement the number by 10
  steps, and the Home and End keys set the number to the minimum or
  maximum respectively. The default step is 1.

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

[shiny::numericInput](https://rdrr.io/pkg/shiny/man/numericInput.html)
for how the number input works with your Shiny server.

## Examples

``` r
ui <- bslib::page_fixed(
    shiny::h1("Breakfast app (beta)"),
    inline("Make me an omelette with ",
        inline_number("eggs", 6, min = 2, max = 12, step = 1,
            placeholder = "6 (default)", meaning = "Number of eggs"),
        " eggs.")
)
```
