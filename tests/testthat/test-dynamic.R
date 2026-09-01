# These tests drive a real app in a headless browser to check that widgets
# created by renderUI behave the same as widgets present from the start.
# Starting an app takes several seconds, so checks that do not interfere with
# each other share one.

# Widget ids, without the panel prefix
dynamic_ids = c("text", "number", "slider", "switch", "date", "select",
    "selectm", "link", "button")

# Start one of the test apps in tests/testthat/apps
test_app = function(name = "dynamic")
{
    skip_on_cran()
    skip_if_not_installed("shinytest2")
    skip_if_not_installed("chromote")
    skip_if(is.null(chromote::find_chrome()),
        "No Chrome-based browser available.")

    # Chromote allows 10 seconds for each command it sends to the browser,
    # which a loaded machine can exceed while an app is starting
    browser = chromote::default_chromote_object()
    browser$default_timeout = 60

    shinytest2::AppDriver$new(test_path("apps", name),
        name = name, load_timeout = 60000)
}

# Collect anything the app logs as an error, for tests that need to check that
# an action is ignored rather than failing
catch_errors = function(app)
{
    app$run_js("(function() {
        window.__errors = [];
        var log_error = console.error;
        console.error = function() {
            window.__errors.push(Array.prototype.slice.call(arguments).join(' '));
            log_error.apply(console, arguments);
        };
    })()")
}

# Values of every widget in a panel, in the order of dynamic_ids
panel_values = function(app, p)
{
    values = app$get_values()$input
    unname(values[paste0(p, "_", dynamic_ids)])
}

test_that("dynamic widgets match static widgets as rendered", {
    app = test_app()
    on.exit(app$stop())

    expect_equal(panel_values(app, "d"), panel_values(app, "s"))

    # The slider and date widgets are bound to their own controls
    expect_true(app$get_js("!!$('#inshiny-slider-d_slider').data('ionRangeSlider')"))
    expect_true(app$get_js("!!$('#inshiny-datepicker-d_date').data().datepicker"))

    # A multiple select is sized as its static counterpart is
    width = function(p) app$get_js(sprintf(
        "$('#%s_selectm').closest('.inshiny-sel').find('.selectize-input').outerWidth()", p))
    expect_equal(width("d"), width("s"))

    # Consecutive lines of widgets are spaced as they are in the static panel
    gap = function(p) app$get_js(sprintf("(function() {
        var a = document.getElementById('%s_text').closest('.inshiny-inline');
        var b = document.getElementById('%s_number').closest('.inshiny-inline');
        return b.getBoundingClientRect().top - a.getBoundingClientRect().top;
    })()", p, p))
    expect_equal(gap("d"), gap("s"))
})

test_that("dynamic widgets respond to input", {
    app = test_app()
    on.exit(app$stop())

    # Text and number widgets report what is typed into them
    app$run_js("(function() {
        document.getElementById('d_text').textContent = 'Edited';
        document.getElementById('d_number').textContent = '44';
    })()")
    app$wait_for_idle()
    expect_equal(app$get_value(input = "d_text"), "Edited")
    expect_equal(app$get_value(input = "d_number"), 44)

    # Invalid input is marked as such and falls back to the default
    app$run_js("(function() {
        document.getElementById('s_number').textContent = 'abc';
        document.getElementById('d_number').textContent = 'abc';
    })()")
    app$wait_for_idle()
    invalid = function(p) app$get_js(sprintf(
        "$('#%s_number').siblings('.inshiny-text-box').hasClass('inshiny-invalid')", p))
    expect_true(invalid("d"))
    expect_equal(invalid("d"), invalid("s"))
    expect_equal(app$get_value(input = "d_number"),
        app$get_value(input = "s_number"))

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

    # Choosing an item in a single select reports its value
    app$run_js("(function() {
        $('#inshiny-list-menu-d_select .inshiny-item').eq(2).trigger('click');
    })()")
    app$wait_for_idle()
    expect_equal(app$get_value(input = "d_select"), "gamma")

    # A multiple select keeps its open menu against the widget, which widens
    # as items are chosen
    menu_gap = function() app$get_js("(function() {
        var $sel = $('#d_selectm').closest('.inshiny-sel');
        var $widget = $sel.find('.selectize-control');
        var $menu = $sel.find('.selectize-dropdown');
        return Math.round($menu[0].getBoundingClientRect().top -
                          $widget[0].getBoundingClientRect().bottom);
    })()")

    app$run_js("(function() { $('#d_selectm')[0].selectize.open(); })()")
    app$wait_for_idle()
    expect_lt(menu_gap(), 10)

    app$run_js("(function() { $('#d_selectm')[0].selectize.addItem('beta'); })()")
    app$wait_for_idle()
    expect_lt(menu_gap(), 10)
})

test_that("update_inline reaches every kind of widget", {
    app = test_app()
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
    expect_equal(app$get_value(input = "s_selectm"), c("Duster 360", "Merc 240D"))

    # All of the new choices are available to choose from; selectize holds
    # these itself, as the select tag only carries the selected ones
    expect_equal(app$get_js(
        "Object.keys($('#s_selectm')[0].selectize.options).sort().join(',')"),
        "Duster 360,Mazda RX4,Merc 240D")

    # The multiple select is wide enough for the items it holds, so that they
    # stay on one line rather than wrapping
    expect_true(app$get_js("(function() {
        var $input = $('#d_selectm').closest('.inshiny-sel').find('.selectize-input');
        var width = 0;
        $input.children().each(function() { width += $(this).outerWidth(true); });
        return $input.outerWidth() >= width;
    })()"))

    # The placeholder is an HTML element, which is rendered as such, while the
    # attribute a screen reader reads carries its text alone
    expect_equal(app$get_js("$('#d_text').attr('aria-placeholder')"),
        "Enter your name")
    expect_equal(app$get_js(
        "$('#d_text').siblings('.inshiny-text-placeholder').find('span.text-danger').length"),
        1)
})

test_that("dynamic widgets can be removed and re-inserted", {
    app = test_app()
    on.exit(app$stop())

    app$set_inputs(show = FALSE)
    app$wait_for_idle()
    expect_false(app$get_js("!!document.getElementById('d_text')"))

    # An update naming a widget that is not rendered is ignored
    catch_errors(app)
    app$click("update_d")
    app$wait_for_idle()
    expect_equal(app$get_js("window.__errors"), list())

    app$set_inputs(show = TRUE)
    app$wait_for_idle()
    expect_true(app$get_js("!!document.getElementById('d_text')"))

    # The slider and datepicker are bound again after re-insertion
    expect_true(app$get_js("!!$('#inshiny-slider-d_slider').data('ionRangeSlider')"))
    expect_true(app$get_js("!!$('#inshiny-datepicker-d_date').data().datepicker"))

    expect_equal(panel_values(app, "d"), panel_values(app, "s"))

    # The same update is applied once the widgets are back
    app$click("update_d")
    app$wait_for_idle()
    expect_equal(app$get_value(input = "d_text"), "Updated")
})

test_that("update_inline reaches a widget inside a module", {
    app = test_app("module")
    on.exit(app$stop())

    expect_equal(app$get_value(input = "mod-txt"), "before")
    expect_false(app$get_value(input = "mod-sw"))

    app$click("mod-go")
    app$wait_for_idle()

    expect_equal(app$get_value(input = "mod-txt"), "after")
    expect_true(app$get_value(input = "mod-sw"))
})

test_that("widgets keep working when moved between uiOutputs", {
    app = test_app("move")
    on.exit(app$stop())

    app$set_inputs(where = TRUE)
    app$wait_for_idle()

    # The widgets that arrived in the second panel are bound to their controls,
    # rather than to the copies that were on their way out of the first
    expect_true(app$get_js("!!$('#inshiny-slider-sl').data('ionRangeSlider')"))
    expect_true(app$get_js(
        "!!($('#inshiny-datepicker-dt').data() && $('#inshiny-datepicker-dt').data().datepicker)"))

    # Moving the slider drives the number it belongs to
    app$run_js("(function() {
        $('#inshiny-slider-sl').data('ionRangeSlider').update({ from: 23 });
    })()")
    app$wait_for_idle()
    expect_equal(app$get_value(input = "sl"), 23)

    # Choosing a date drives the date widget it belongs to
    app$run_js("(function() {
        $('#inshiny-datepicker-dt').data().datepicker
            .setUTCDate(new Date(Date.UTC(2025, 7, 11)));
    })()")
    app$wait_for_idle()
    expect_equal(app$get_value(input = "dt"), as.Date("2025-08-11"))

    # An update reaches them where they now are
    catch_errors(app)
    app$click("go")
    app$wait_for_idle()

    expect_equal(app$get_js("window.__errors"), list())
    expect_equal(app$get_value(input = "sl"), 30)
    expect_equal(app$get_value(input = "dt"), as.Date("2025-08-20"))
    expect_equal(app$get_value(input = "se"), "epsilon")
    expect_equal(app$get_value(input = "nu"), 8)
    expect_true(app$get_value(input = "sw"))
})
