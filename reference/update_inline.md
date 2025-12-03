# Update an inline widget

Use this in your server code to change the parameters of an existing
inline widget. Most, but not all, parameters from the corresponding
`inline_*` functions can be changed. Note that while Shiny has a
separate update function for each type of widget (e.g.
[shiny::updateTextInput](https://rdrr.io/pkg/shiny/man/updateTextInput.html)
for [shiny::textInput](https://rdrr.io/pkg/shiny/man/textInput.html),
etc.), the inshiny package has this single function to update all types
of inline widgets. This function can only be called in a reactive
context, and can only be called on `inline_*` widgets, not on "built-in"
Shiny widgets.

## Usage

``` r
update_inline(
  id,
  session = shiny::getDefaultReactiveDomain(),
  value,
  placeholder,
  meaning,
  label,
  icon,
  accent,
  min,
  max,
  step,
  default,
  on,
  off,
  datesdisabled,
  daysofweekdisabled,
  choices,
  selected
)
```

## Arguments

- id:

  The `id` of the inline widget to change.

- session:

  The currently active Shiny session. In almost all cases you can leave
  this to its default value.

- value:

  (date, number, select, slider, switch, text) The current value of the
  widget.

- placeholder:

  (date, number, slider, text) The character string or HTML element that
  will appear when the widget's textbox is empty, as a prompt.

- meaning:

  (all widgets) The descriptive label for people using assistive
  technology such as screen readers.

- label, icon:

  (button, link) The label and icon that appear in the button or link.

- accent:

  (button, link) The Boostrap accent to apply to the button or link.

- min, max:

  (date, number, slider) The minimum and maximum allowable value.

- step:

  (number, slider) The increment or decrement by which to change the
  value.

- default:

  (number, slider) The default value to assume when the input is blank
  or invalid.

- on, off:

  (switch) Labels to use for when the switch is on or off.

- datesdisabled, daysofweekdisabled:

  (date) Dates to make unselectable.

- choices, selected:

  (select) Options to choose from and current selection.

## Value

Nothing.

## Details

See the documentation for each inline widget for details of how each
parameter is interpreted.

When adjusting `min`, `max`, `datesdisabled`, or `daysofweekdisabled`,
it is recommended that you also send an update to `value` with the
current value of `input[[id]]` or any new value as applicable. This will
ensure that any invalid value gets highlighted in the app as invalid
after accounting for the new bounds and disallowed values.

## Examples

``` r
# Example UI setup
ui <- bslib::page_fixed(
    inline(
        inline_button("mybutton", "Button"),
        inline_date("mydate"),
        inline_link("mylink", "Link"),
        inline_number("mynumber", 42),
        inline_select("myselect", letters),
        inline_slider("myslider", 42, 0, 100),
        inline_switch("myswitch", TRUE),
        inline_text("mytext")
    )
)

# This covers all updatable attributes except `meaning` (all widgets) and
# `placeholder` (date, number, slider, text).
server <- function(input, output) {
    update_inline("mybutton", label = "Click me", icon = shiny::icon("recycle"),
        accent = "info")
    update_inline("mydate", value = "2026-01-01", min = "2025-01-01",
        max = "2026-12-31", datesdisabled = "2025-12-25",
        daysofweekdisabled = c(0, 6))
    update_inline("mylink", label = "Click me", icon = shiny::icon("recycle"),
        accent = "info")
    update_inline("mynumber", value = 25, min = 20, max = 50, step = 5,
        default = 25)
    update_inline("myselect", choices = letters[1:5], selected = "c")
    update_inline("myslider", value = 25, min = 20, max = 50, step = 5,
        default = 25)
    update_inline("myswitch", value = TRUE, on = "Present", off = "Absent")
    update_inline("mytext", value = "Howdy")
}
```
