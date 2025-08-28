#' @keywords internal
"_PACKAGE"

## usethis namespace: start
## usethis namespace: end
NULL

#' Manually include inshiny scripts and stylesheet
#'
#' For inshiny to work, you need to link your Shiny app to inshiny's JavaScript
#' code and CSS stylesheets. If you use inshiny's function [inline()] anywhere
#' in your Shiny UI definition, which you probably do, this happens
#' automatically. Otherwise, you can add a call to [use_inshiny()] to your UI.
#'
#' @return An [htmltools::htmlDependency()] object to include in your UI.
#' @examples
#' ui <- bslib::page(
#'     use_inshiny(),
#'     shiny::h1("My slider app"),
#'     inline_slider("slider", 50, 0, 100)
#' )
#' @export
use_inshiny = function()
{
    htmltools::htmlDependency(
        name = "inshiny",
        version = utils::packageVersion("inshiny"),
        src = "www/inshiny",
        package = "inshiny",
        script = "inshiny.js",
        stylesheet = "inshiny.css"
    )
}
