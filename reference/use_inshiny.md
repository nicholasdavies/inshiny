# Manually include inshiny scripts and stylesheet

For inshiny to work, you need to link your Shiny app to inshiny's
JavaScript code and CSS stylesheets. If you use inshiny's function
[`inline()`](https://nicholasdavies.github.io/inshiny/reference/inline.md)
anywhere in your Shiny UI definition, which you probably do, this
happens automatically. Otherwise, you can add a call to `use_inshiny()`
to your UI.

## Usage

``` r
use_inshiny()
```

## Value

An
[`htmltools::htmlDependency()`](https://rstudio.github.io/htmltools/reference/htmlDependency.html)
object to include in your UI.

## Examples

``` r
ui <- bslib::page(
    use_inshiny(),
    shiny::h1("My slider app"),
    inline_slider("slider", 50, 0, 100)
)
```
