
# inshiny: Compact inline widgets for Shiny apps

<!-- badges: start -->
[![R-CMD-check](https://github.com/nicholasdavies/inshiny/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/nicholasdavies/inshiny/actions/workflows/R-CMD-check.yaml)
[![Codecov test coverage](https://codecov.io/gh/nicholasdavies/inshiny/graph/badge.svg)](https://app.codecov.io/gh/nicholasdavies/inshiny)
<!-- badges: end -->

`inshiny` provides a basic set of compact widgets for Shiny apps which occupy 
minimum space and appear "inline" with explanatory text.

Consult the [Introduction](https://nicholasdavies.github.io/inshiny/articles/inshiny.html)
vignette for a brief guide to `inshiny`. 

Note that `inshiny` does not currently support use with Shiny's `uiOutput` and 
`renderUI`.

## Installation

You can install the released version of inshiny from
[CRAN](https://CRAN.R-project.org/package=inshiny) with:

``` r
install.packages("inshiny")
```

You can install the development version of inshiny from
[GitHub](https://github.com/nicholasdavies/inshiny) with:

``` r
# install.packages("devtools")
devtools::install_github("nicholasdavies/inshiny")
```

## Example

This demonstrates the basic features of `inshiny`:

``` r
library(inshiny)
library(shiny)
library(bslib)

# Shiny UI
ui = page_fixed(
    theme = bs_theme(version = 5, preset = "quartz"),

    h1("A Tale of Two Cities by Charles Dickens"),
    h2("Configurable Edition"),

    inline("It was the year of Our Lord ",
        inline_date("tale_date", "1775-07-01"),
        ". Spiritual revelations were conceded to ",
        inline_select("tale_country", c("England", "France", "Spain")),
        " at that favoured period, as at this. ",
        "Mrs. Southcott had recently attained her ",
        inline_number("tale_age", 25), "th blessed birthday, ",
        "of whom a prophetic private in the Life Guards had heralded the sublime appearance ",
        "by announcing that arrangements were made for the swallowing up of London and ",
        inline_text("tale_borough", "Westminster"), ". ",
        "Even the Cock-lane ghost had been laid only a round ",
        inline_slider("tale_years", 12, 2, 100), " of years, ",
        "after rapping out its messages, as the spirits of this very year last past ",
        "(supernaturally deficient in originality) ",
        inline_button("tale_button", "rapped out"), " theirs. ",
        "Mere messages in the earthly order of events had lately come to the ",
        "English Crown and People, from a congress of British subjects in ",
        inline_switch("tale_usa", FALSE, " THE USA", " America"), ": ",
        "which, strange to relate, have proved more important to the human race ",
        "than any communications yet received through any of the chickens ",
        "of the Cock-lane brood.")
)

# Shiny server
server = function(input, output) { }

# Run app
shinyApp(ui, server)

```

