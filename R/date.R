#' Inline date input with calendar
#'
#' A date input with a calendar pop-up similar to [shiny::dateInput()] that
#' can be included in an [inline()] wrapper.
#'
#' @inheritParams inline_text
#' @param value The initially selected date. Either a Date object; a
#'     character string in `"yyyy-mm-dd"` format (*not* in the calendar's
#'     display format); or `NULL` to use the current date in the client's
#'     time zone.
#' @param min,max The minimum and maximum allowed date. Either a Date object,
#'     a character string in `"yyyy-mm-dd"` format, or `NULL` for no limit.
#' @param placeholder The character string or HTML element that will appear in
#'     the textbox when it is empty, as a prompt.
#' @param format The format of the date to display in the browser; defaults to
#'     "yyyy-mm-dd". Note that this is only for display purposes. Changing the
#'     display format does not allow you to specify `value`, `min`, `max`, or
#'     `datesdisabled` in that format; those have to stay formatted as
#'     `"yyyy-mm-dd"` or as Date objects. See [shiny::dateInput] for format
#'     details.
#' @param startview The view shown when the textbox is first clicked. Can be
#'     `"month"`, the default, for the usual monthly calendar view, `"year"`,
#'     or `"decade"`.
#' @param weekstart Which day is the start of the week; an integer from 0
#'     (Sunday) to 6 (Saturday).
#' @param language The language used for month and day names, with `"en"`
#'     (English) as the default. See [shiny::dateInput] for options.
#' @param autoclose Whether to close the calendar once a date has been
#'     selected.
#' @param datesdisabled Dates that should be disabled (a character or Date
#'     vector). Strings should be in the `"yyyy-mm-dd"` format.
#' @param daysofweekdisabled Days of the week that should be disabled; an
#'     integer vector in which 0 is Sunday, and 6 is Saturday.
#' @inherit inline_text return
#' @seealso [shiny::dateInput] for how the date input works with your Shiny server.
#' @examples
#' ui <- bslib::page_fixed(
#'     shiny::h1("Select a date"),
#'     inline("Run simulation starting on ",
#'         inline_date("start_date", NULL, meaning = "Simulation start date",
#'             format = "dd/mm/yyyy", daysofweekdisabled = c(0, 6)),
#'         " (weekdays only)."
#'     )
#' )
#' @export
inline_date = function(id, value = NULL, min = NULL, max = NULL,
    placeholder = "Enter date", meaning = NULL,
    format = "yyyy-mm-dd", startview = "month", weekstart = 0, language = "en",
    autoclose = TRUE, datesdisabled = NULL, daysofweekdisabled = NULL)
{
    value = convert_date(value);
    min = convert_date(min);
    max = convert_date(max);
    datesdisabled = convert_date(datesdisabled);

    if ((!is.null(min) && value < min) ||
        (!is.null(max) && value > max)) {
        stop("value must lie between min and max.")
    }

    datepicker_id = paste0("inshiny-datepicker-", id);
    drop_id = paste0("inshiny-date-drop-", id);

    # Get textbox
    textbox = inline_text(id, value, placeholder = placeholder, meaning = meaning)

    # Modify textbox
    tq = htmltools::tagQuery(textbox)
    tq$addAttrs(
        "id" = drop_id,
        "data-bs-toggle" = "dropdown",
        "data-bs-auto-close" = "outside",
        "aria-expanded" = "false"
    )

    tq$find(".inshiny-text-form")$ # get edit box
        addClass("inshiny-date-form")$
        addClass("inshiny-with-datepicker")$
        addAttrs(
            "data-default" = value,
            "data-value" = value
        )
    textbox = tq$allTags()

    # Get datepicker widget.
    # Note: autoclose set below (as data-autoclose, not data-date-autoclose).
    datepicker = coalesce(shiny::dateInput(datepicker_id, label = NULL, value = value,
        min = min, max = max, format = format, startview = startview,
        weekstart = weekstart, language = language, width = NULL, autoclose = FALSE,
        datesdisabled = datesdisabled, daysofweekdisabled = daysofweekdisabled))

    # Check structure is as expected
    check_tags(datepicker, shiny::div(shiny::tags$label(), shiny::tags$input()),
        "shiny::dateInput()")

    # Modify widget
    dependencies = datepicker$children[[3]]
    datepicker = datepicker$children[[2]]

    tq = htmltools::tagQuery(datepicker)
    tq$each(rename_tag("div"))$ # top-level <input>: change to <div>
        addAttrs("id" = datepicker_id, "data-autoclose" = boolean(autoclose))$
        removeAttrs(c("type", "aria-labelledby"))$
        removeClass("form-control")$
        addClass("inshiny-datepicker")
    datepicker = tq$allTags()

    shiny::span(class = "dropdown-center",
        textbox,
        shiny::div(
            class = "dropdown-menu p-3 rounded-3 border shadow", # TODO do I want shadow?
            datepicker,
            dependencies
        )
    )
}

convert_date = function(date)
{
    nm = as.character(substitute(date))

    if (is.null(date)) { return (NULL) }
    date = as.Date(date);
    if (any(is.na(date))) {
        stop("Invalid date(s) for ", nm)
    }
    return (date)
}
