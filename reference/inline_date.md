# Inline date input with calendar

A date input with a calendar pop-up similar to
[`shiny::dateInput()`](https://rdrr.io/pkg/shiny/man/dateInput.html)
that can be included in an
[`inline()`](https://nicholasdavies.github.io/inshiny/reference/inline.md)
wrapper.

## Usage

``` r
inline_date(
  id,
  value = NULL,
  min = NULL,
  max = NULL,
  placeholder = "Enter date",
  meaning = NULL,
  format = "yyyy-mm-dd",
  startview = "month",
  weekstart = 0,
  language = "en",
  autoclose = TRUE,
  datesdisabled = NULL,
  daysofweekdisabled = NULL
)
```

## Arguments

- id:

  The `input` slot that will be used to access the value.

- value:

  The initially selected date. Either a Date object; a character string
  in `"yyyy-mm-dd"` format (*not* in the calendar's display format); or
  `NULL` to use the current date in the client's time zone.

- min, max:

  The minimum and maximum allowed date. Either a Date object, a
  character string in `"yyyy-mm-dd"` format, or `NULL` for no limit.

- placeholder:

  The character string or HTML element that will appear in the textbox
  when it is empty, as a prompt.

- meaning:

  A descriptive label, for people using assistive technology such as
  screen readers.

- format:

  The format of the date to display in the browser; defaults to
  "yyyy-mm-dd". Note that this is only for display purposes. Changing
  the display format does not allow you to specify `value`, `min`,
  `max`, or `datesdisabled` in that format; those have to stay formatted
  as `"yyyy-mm-dd"` or as Date objects. See
  [shiny::dateInput](https://rdrr.io/pkg/shiny/man/dateInput.html) for
  format details.

- startview:

  The view shown when the textbox is first clicked. Can be `"month"`,
  the default, for the usual monthly calendar view, `"year"`, or
  `"decade"`.

- weekstart:

  Which day is the start of the week; an integer from 0 (Sunday) to 6
  (Saturday).

- language:

  The language used for month and day names, with `"en"` (English) as
  the default. See
  [shiny::dateInput](https://rdrr.io/pkg/shiny/man/dateInput.html) for
  options.

- autoclose:

  Whether to close the calendar once a date has been selected.

- datesdisabled:

  Dates that should be disabled (a character or Date vector). Strings
  should be in the `"yyyy-mm-dd"` format.

- daysofweekdisabled:

  Days of the week that should be disabled; an integer vector in which 0
  is Sunday, and 6 is Saturday.

## Value

An inline widget to be included in an
[`inline()`](https://nicholasdavies.github.io/inshiny/reference/inline.md)
wrapper.

## See also

[shiny::dateInput](https://rdrr.io/pkg/shiny/man/dateInput.html) for how
the date input works with your Shiny server.

## Examples

``` r
ui <- bslib::page_fixed(
    shiny::h1("Select a date"),
    inline("Run simulation starting on ",
        inline_date("start_date", NULL, meaning = "Simulation start date",
            format = "dd/mm/yyyy", daysofweekdisabled = c(0, 6)),
        " (weekdays only)."
    )
)
```
