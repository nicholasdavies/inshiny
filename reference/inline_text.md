# Inline text input

A single line text input similar to
[`shiny::textInput()`](https://rdrr.io/pkg/shiny/man/textInput.html)
that can be included in an
[`inline()`](https://nicholasdavies.github.io/inshiny/reference/inline.md)
wrapper.

## Usage

``` r
inline_text(id, value = "", placeholder = "Enter text", meaning = NULL)
```

## Arguments

- id:

  The `input` slot that will be used to access the value.

- value:

  The initial text contents (a character string).

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

[shiny::textInput](https://rdrr.io/pkg/shiny/man/textInput.html) for how
the text input works with your Shiny server.

## Examples

``` r
ui <- bslib::page_fixed(
    shiny::h1("Hello!"),
    inline("My name is ", inline_text("myname", "Sisyphus",
        placeholder = "Enter your name", meaning = "Your name"), ".")
)
```
