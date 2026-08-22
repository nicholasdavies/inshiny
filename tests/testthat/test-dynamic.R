# These tests drive a real app in a headless browser to check that widgets
# created by renderUI behave the same as widgets present from the start.

# Widget ids, without the panel prefix
dynamic_ids = c("text", "number", "slider", "switch", "date", "select",
    "selectm", "link", "button")

# Start the test app
dynamic_app = function()
{
    skip_on_cran()
    skip_if_not_installed("shinytest2")
    skip_if(is.null(chromote::find_chrome()),
        "No Chrome-based browser available.")

    shinytest2::AppDriver$new(test_path("apps", "dynamic"),
        name = "dynamic", load_timeout = 30000)
}

# Values of every widget in a panel, in the order of dynamic_ids
panel_values = function(app, p)
{
    values = app$get_values()$input
    unname(values[paste0(p, "_", dynamic_ids)])
}

test_that("dynamic widgets report the same initial values as static ones", {
    app = dynamic_app()
    on.exit(app$stop())

    expect_equal(panel_values(app, "d"), panel_values(app, "s"))
})

test_that("dynamic text and number widgets report edits", {
    app = dynamic_app()
    on.exit(app$stop())

    app$run_js("(function() {
        document.getElementById('d_text').textContent = 'Edited';
        document.getElementById('d_number').textContent = '44';
    })()")
    app$wait_for_idle()

    expect_equal(app$get_value(input = "d_text"), "Edited")
    expect_equal(app$get_value(input = "d_number"), 44)
})

test_that("dynamic number widget validates like the static one", {
    app = dynamic_app()
    on.exit(app$stop())

    app$run_js("(function() {
        document.getElementById('s_number').textContent = 'abc';
        document.getElementById('d_number').textContent = 'abc';
    })()")
    app$wait_for_idle()

    invalid = function(p) app$get_js(sprintf(
        "$('#%s_number').siblings('.inshiny-text-box').hasClass('inshiny-invalid')", p))

    # Invalid input is marked as such and falls back to the default
    expect_true(invalid("d"))
    expect_equal(invalid("d"), invalid("s"))
    expect_equal(app$get_value(input = "d_number"),
        app$get_value(input = "s_number"))
})

test_that("dynamic slider and date widgets are bound to their controls", {
    app = dynamic_app()
    on.exit(app$stop())

    expect_true(app$get_js("!!$('#inshiny-slider-d_slider').data('ionRangeSlider')"))
    expect_true(app$get_js("!!$('#inshiny-datepicker-d_date').data().datepicker"))

    # Moving the slider changes the number it is bound to
    app$run_js("(function() {
        $('#inshiny-slider-d_slider').data('ionRangeSlider').update({ from: 73 });
    })()")
    app$wait_for_idle()
    expect_equal(app$get_value(input = "d_slider"), 73)

    # Choosing a date in the datepicker changes the date it is bound to
    app$run_js("(function() {
        $('#inshiny-datepicker-d_date').data().datepicker
            .setUTCDate(new Date(Date.UTC(2025, 7, 20)));
    })()")
    app$wait_for_idle()
    expect_equal(app$get_value(input = "d_date"), as.Date("2025-08-20"))
})

test_that("dynamic select widgets work", {
    app = dynamic_app()
    on.exit(app$stop())

    # Single select: choosing an item reports its value
    app$run_js("(function() {
        $('#inshiny-list-menu-d_select .inshiny-item').eq(2).trigger('click');
    })()")
    app$wait_for_idle()
    expect_equal(app$get_value(input = "d_select"), "gamma")

    # Multiple select: the spacer is sized as it is for the static widget
    width = function(p) app$get_js(sprintf(
        "$('#%s_selectm').closest('.inshiny-sel').find('.selectize-input').outerWidth()", p))
    expect_equal(width("d"), width("s"))
})

test_that("dynamic widgets are spaced like static ones", {
    app = dynamic_app()
    on.exit(app$stop())

    # Distance between the tops of two consecutive lines of widgets
    gap = function(p) app$get_js(sprintf("(function() {
        var a = document.getElementById('%s_text').closest('.inshiny-inline');
        var b = document.getElementById('%s_number').closest('.inshiny-inline');
        return b.getBoundingClientRect().top - a.getBoundingClientRect().top;
    })()", p, p))

    expect_equal(gap("d"), gap("s"))
})

test_that("a multiple select is resized when its selection changes", {
    app = dynamic_app()
    on.exit(app$stop())

    app$click("update_d")
    app$wait_for_idle()

    # The control is wide enough for the items it holds, so that they stay on
    # one line rather than wrapping
    contents_fit = app$get_js("(function() {
        var $input = $('#d_selectm').closest('.inshiny-sel').find('.selectize-input');
        var width = 0;
        $input.children().each(function() { width += $(this).outerWidth(true); });
        return $input.outerWidth() >= width;
    })()")

    expect_true(contents_fit)
})

test_that("update_inline reaches dynamic widgets", {
    app = dynamic_app()
    on.exit(app$stop())

    app$click("update_s")
    app$click("update_d")
    app$wait_for_idle()

    expect_equal(panel_values(app, "d"), panel_values(app, "s"))
    expect_equal(app$get_value(input = "d_text"), "Updated")
    expect_equal(app$get_value(input = "d_number"), 42)
    expect_equal(app$get_value(input = "d_date"), as.Date("2025-08-15"))
    expect_equal(app$get_value(input = "d_select"), "epsilon")
    expect_equal(app$get_value(input = "d_selectm"), c("Duster 360", "Merc 240D"))
})

test_that("update_inline works for a multiple select", {
    app = dynamic_app()
    on.exit(app$stop())

    app$click("update_s")
    app$wait_for_idle()

    expect_equal(app$get_value(input = "s_selectm"), c("Duster 360", "Merc 240D"))

    # All of the new choices are available to choose from; selectize holds
    # these itself, as the select tag only carries the selected ones
    expect_equal(app$get_js(
        "Object.keys($('#s_selectm')[0].selectize.options).sort().join(',')"),
        "Duster 360,Mazda RX4,Merc 240D")
})

test_that("dynamic widgets can be removed and re-inserted", {
    app = dynamic_app()
    on.exit(app$stop())

    app$set_inputs(show = FALSE)
    app$wait_for_idle()
    expect_false(app$get_js("!!document.getElementById('d_text')"))

    app$set_inputs(show = TRUE)
    app$wait_for_idle()
    expect_true(app$get_js("!!document.getElementById('d_text')"))

    # The slider and datepicker are bound again after re-insertion
    expect_true(app$get_js("!!$('#inshiny-slider-d_slider').data('ionRangeSlider')"))
    expect_true(app$get_js("!!$('#inshiny-datepicker-d_date').data().datepicker"))

    expect_equal(panel_values(app, "d"), panel_values(app, "s"))
})
