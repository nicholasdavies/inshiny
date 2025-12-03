# Inline select list input

A select list input similar to
[`shiny::selectInput()`](https://rdrr.io/pkg/shiny/man/selectInput.html)
that can be included in an
[`inline()`](https://nicholasdavies.github.io/inshiny/reference/inline.md)
wrapper.

## Usage

``` r
inline_select(id, choices, selected = NULL, multiple = FALSE, meaning = NULL)
```

## Arguments

- id:

  The `input` slot that will be used to access the value.

- choices:

  Vector or list of values to select from. Provide one of the following:

  - Use an unnamed character vector, such as `c("dog", "cat", "bee")`,
    for the most basic case, where you have a list of strings you want
    the user to select from.

  - Use a named character vector, such as
    `c("Dog" = "dog", "Nice Kitty" = "cat", "Bee" = "bee")` if you want
    the options displayed to the user (the names; here, Dog, Nice Kitty,
    and Bee) to differ from the values passed to Shiny (the values;
    here, `"dog"`, `"cat"`, and `"bee"`).

  - Use a named list, where each element is a "sub-list", to group the
    items under headings; the names at the top level of the list will be
    the heading titles and the "sub-lists" are the items appearing under
    that heading. For example, if you pass
    `list(Mammals = c("Dog" = "dog", "Nice Kitty" = "cat"), Invertebrates = c("Bee" = "bee"))`
    then Dog and Nice Kitty will appear under the Mammals heading, while
    Bee will appear under the Invertebrates heading, and the value
    passed to the Shiny server will be either `"dog"`, `"cat"`, or
    `"bee"`.

- selected:

  The initially selected option's value. If `NULL`, use the first item
  in `choices`.

- multiple:

  Whether to allow multiple selections. As of inshiny version 0.1.0, the
  version of inline_select with `multiple = TRUE` looks and behaves a
  bit differently from the version of inline_select with
  `multiple = FALSE`. The package authors are working on eliminating
  this inconsistency.

- meaning:

  A descriptive label, for people using assistive technology such as
  screen readers.

## Value

An inline widget to be included in an
[`inline()`](https://nicholasdavies.github.io/inshiny/reference/inline.md)
wrapper.

## See also

[shiny::selectInput](https://rdrr.io/pkg/shiny/man/selectInput.html) for
how the select input works with your Shiny server.

## Examples

``` r
ui <- bslib::page_fixed(
    shiny::h1("Pet registration form"),
    inline("My ",
        inline_select("species", c("dog", "cat"), meaning = "Pet species"),
        "'s name is ",
        inline_select("name", list("Dog names" = c("Fido", "Rex"),
            "Cat names" = c("Felix", "Boots")), selected = "Rex"),
        ".")
)
```
