# Changelog

## inshiny (development version)

- inshiny widgets can now be used with Shiny’s
  [`uiOutput()`](https://rdrr.io/pkg/shiny/man/htmlOutput.html) and
  [`renderUI()`](https://rdrr.io/pkg/shiny/man/renderUI.html).

- [`update_inline()`](https://nicholasdavies.github.io/inshiny/reference/update_inline.md)
  now works with widgets inside a Shiny module.

- [`update_inline()`](https://nicholasdavies.github.io/inshiny/reference/update_inline.md)
  no longer reports an error when no widget with the given id has been
  rendered. As with Shiny’s own update functions, the update is ignored.

- [`update_inline()`](https://nicholasdavies.github.io/inshiny/reference/update_inline.md)
  now works with a multiple select, i.e. one created with
  `inline_select(multiple = TRUE)`. Accordingly, `selected` can now name
  more than one option.

- Fixed a bug in which a multiple select was not made wide enough for
  its contents when a selected choice was more than one word long.

- Fixed a bug in which an HTML element passed as the `placeholder` of a
  text-based widget was displayed as escaped markup instead of being
  rendered. The `aria-placeholder` attribute now carries the plain text
  of such a placeholder, rather than its markup.

## inshiny 0.1.4

CRAN release: 2026-03-31

- Added max_width parameter for text-based widgets.

- Fixed a problem with the caret not appearing in text-based widgets.

## inshiny 0.1.3

CRAN release: 2026-03-20

- Updated tests for shiny 1.13.0.

- Made the arrow elements within inline_number() optional and fixed a
  spacing issue when inline_number() appeared in a flex layout.

- Fixed some slight spacing differences when inline elements appeared in
  a page_sidebar() versus a page_fixed().

- Fixed a bug in which borders around input elements wouldn’t appear
  within a card or accordion panel.

## inshiny 0.1.2

CRAN release: 2026-02-14

- Changed to use htmltools::tagQuery for tag editing, and modified
  check_tags() so it only runs during continuous integration. These are
  changes in internal details that doesn’t affect users of the package,
  done to make the package more robust to future changes to Shiny and to
  move the onus of keeping this package accurate onto myself rather than
  Shiny developers. Thanks to [@schloerke](https://github.com/schloerke)
  who raised this in PR
  [\#1](https://github.com/nicholasdavies/inshiny/issues/1) and issue
  [\#2](https://github.com/nicholasdavies/inshiny/issues/2).

## inshiny 0.1.1

CRAN release: 2025-12-03

- Bug fix: updated to work with the newly released shiny 1.12.0.

## inshiny 0.1.0

CRAN release: 2025-09-09

- Initial CRAN submission.
