// HELPER FUNCTIONS

// Get a specific CSS property for a CSS class, optionally with :focus
function get_css_property(tag_name, class_name, property_name, focus)
{
    // Create a temporary element
    const el = document.createElement(tag_name);
    el.className = class_name;
    el.style.position = "absolute";
    el.style.left = "-9999px";
    document.body.appendChild(el);

    if (focus) {
        // Force focus
        el.tabIndex = -1;
        el.focus();
    }

    // Read the computed property
    const prop = getComputedStyle(el).getPropertyValue(property_name);

    // Clean up
    document.body.removeChild(el);

    return prop;
}

// Remove data and attribute
function rm_data($target, key) {
    $target.removeData(key);
    $target.removeAttr("data-" + key);
}

// Does str represent a valid finite number, also not an empty string?
function is_number(str) {
    return str.trim() !== "" && isFinite(str);
}

// Format a Date as ISO yyyy-mm-dd.
function format_date_iso(date) {
    var str = date.toISOString();
    return str.slice(0, str.indexOf("T"));
}

// Format date according to datepicker format; date can be a Date or a string
function format_date_dp(date, dp_id)
{
    var $dp = $("#" + dp_id);
    if (typeof(date) === "string") {
        date = new Date(date);
    } else if (!(date instanceof Date)) {
        throw new Error("Unknown date object.")
    }
    return $dp.bsDatepicker.DPGlobal.formatDate(date,
        $dp.data("dateFormat"),
        $dp.data("dateLanguage"));
}

// Parse date_str according to datepicker format
function parse_date_dp(date_str, dp_id)
{
    var $dp = $("#" + dp_id);
    return $dp.bsDatepicker.DPGlobal.parseDate(date_str,
        $dp.data("dateFormat"),
        $dp.data("dateLanguage"),
        $dp.data("assumeNearbyYear"));
}

// Adjust number for numeric input by [by] steps (-1, +1, etc.)
// by = -99 or +99 interpreted as move to minimum or maximum.
function adjust_number(target_id, by) {
    var $target = $("#" + target_id);
    var num;
    if (is_number($target.text())) {
        num = Number($target.text());
        if (by == -99) {
            const min = $target.data("min");
            if (min) num = Number(min);
        } else if (by == 99) {
            const max = $target.data("max");
            if (max) num = Number(max);
        } else {
            const min = Number($target.data("min") || 0);
            const step = Number($target.data("step") || 1);
            var n1 = ((num - min) / step); // Number of steps above min
            var n2 = n1 % 1;  // Fractional part of n1
            if (n2 < 0) n2++; // Account for negative n2 (in case of no min)

            if (n2 < 1e-12) {
                num = Math.floor(n1 + by) * step + min;
            } else if (n2 > 1 - 1e-12) {
                num = Math.ceil(n1 + by) * step + min;
            } else {
                if (by > 0) {
                    num = Math.ceil(n1) * step + min;
                } else {
                    num = Math.floor(n1) * step + min;
                }
            }
            if ($target.data("max")) {
                num = Math.min(Number($target.data("max")), num);
            }
            if ($target.data("min")) {
                num = Math.max(min, num);
            }
        }
    } else {
        num = Number($target.data("default"));
    }

    // Note: here and in similar lines, I am using [0].textContent rather than
    // jQuery's text() as the latter triggers two mutationobserver calls --
    // first it deletes all children of the node, then creates a new text node.
    $target[0].textContent = num.toPrecision(15) / 1;
    // Note: mutation observer handles change to Shiny message & aria-valuenow
}

// Bind a number input to its slider
function bind_slider(id) {
    var slider = $("#" + "inshiny-slider-" + id).data("ionRangeSlider");
    var $number = $("#" + id);

    function update_textbox(data) {
        if (!$number.data("dontChange")) {
            $number[0].textContent = data.from;
        }
    }

    // Keep label synced while dragging and on programmatic updates
    slider.update({
        onChange: update_textbox,
        onUpdate: update_textbox
    });
}

// Bind a date input to its datepicker
function bind_datepicker(id) {
    var datepicker_id = "inshiny-datepicker-" + id;
    var $datepicker = $("#" + datepicker_id);
    var datepicker = $datepicker.bsDatepicker();
    var $date = $("#" + id);

    // Fix bug in Shiny <1.11.1 with datesdisabled
    var dd = $("#" + datepicker_id).attr("data-date-dates-disabled");
    if (dd !== null) {
        const regex = /\d{4}-\d{2}-\d{2}/g;
        dd = (dd.match(regex) || []).map((ymd) => format_date_dp(ymd, datepicker_id));
        $("#" + datepicker_id).data().datepicker.setDatesDisabled(dd);
    }

    // Set initial date to today if needed
    if ($date.data("value") === undefined) {
        $date.data("value", Date())
    }

    // Set initial date to match datepicker format
    $date[0].textContent = format_date_dp($date.data("value"), datepicker_id);

    // Set datepicker's initial date
    $datepicker.data().datepicker.update($date[0].textContent);

    // Attach event handler so that date input changes with datepicker selection
    datepicker.on("changeDate", function(e) {
        if ($datepicker.data("autoclose")) {
            const $dropdown = $("#inshiny-date-drop-" + id);
            const dropdown = bootstrap.Dropdown.getInstance($dropdown) ||
                new bootstrap.Dropdown($dropdown);
            dropdown.hide();
        }
        $date.data("value", e.format("yyyy-mm-dd"));
        $date[0].textContent = e.format();
    });
}

// Set switch label
function set_switch_label($switch) {
    if ($switch.is(":checked")) {
        $("#" + $switch.data("label-id")).html($switch.data("on-label"));
        $switch.attr("aria-checked", "true")
    } else {
        $("#" + $switch.data("label-id")).html($switch.data("off-label"));
        $switch.attr("aria-checked", "false")
    }
}

// Resize selectize spacer
function resize_select($el) {
    var width = 0;
    $el.children().each(function() {
        width += $(this).outerWidth(true);
    });
    var $spacer = $el.parent().parent().siblings(".inshiny-sel-spacer");
    width = "calc(" + width + "px + 1.5rem)";
    $spacer.outerWidth(width, true);
}


// GENERAL SETUP

// Auto-dropup dropdowns when too close to bottom
$(document).on("shown.bs.dropdown", ".dropdown-center", function() {
    // calculate the required sizes, spaces
    var $ul = $(this).children(".dropdown-menu");
    var $button = $(this).children(":not(.dropdown-menu)");
    var ulOffset = $ul.offset();
    // how much space would be left on the top if the dropdown opened that direction
    var spaceUp = (ulOffset.top - $button.height() - $ul.height()) - $(window).scrollTop();
    // how much space is left at the bottom
    var spaceDown = $(window).scrollTop() + $(window).height() - (ulOffset.top + $ul.height());
    // switch to dropup only if there is no space at the bottom AND there is space at the top, or there isn't either but it would be still better fit
    if (spaceDown < 0 && (spaceUp >= 0 || spaceUp > spaceDown)) {
        $(this).addClass("dropup dropup-center");
    }
}).on("hidden.bs.dropdown", ".dropdown-center", function() {
    // always reset after close
    $(this).removeClass("dropup dropup-center");
});


// WIDGET SETUP
$(document).on("shiny:connected", function() {

    // STYLES

    // Create form text colour style
    const form_color = get_css_property("input", "form-control", "color", false);
    var form_style = document.createElement("style");
    form_style.type = "text/css";
    form_style.innerHTML = ".inshiny-text-form { color: " + form_color + "; }";
    document.head.appendChild(form_style);

    // Create fake focus style
    // In Boostrap themes, box-shadow is the only element of .focus-ring besides outline: 0.
    // We also change the border-color to --bs-primary.
    const box_shadow = get_css_property("input", "focus-ring", "box-shadow", true);
    var focus_style = document.createElement("style");
    focus_style.type = "text/css";
    focus_style.innerHTML = ".inshiny-focus { box-shadow: " + box_shadow + "; border-color: var(--bs-primary); }";
    document.head.appendChild(focus_style);


    // INLINE TEXT WIDGET

    // Send initial value for .inshiny-text-form and related elements
    $(".inshiny-text-form").not(".inshiny-number-form").not("inshiny-date-form").each(function() {
        Shiny.setInputValue($(this).attr("id"),
            $(this).text(), { priority: "event" });
    });
    $(".inshiny-number-form").each(function() {
        Shiny.setInputValue($(this).attr("id"),
            Number($(this).text()), { priority: "event" });
    });
    $(".inshiny-date-form").each(function() {
        Shiny.setInputValue($(this).attr("id") + ":shiny.date",
            $(this).data("value"), { priority: "event" });
    });

    // Prevent newline
    $(".inshiny-text-form").on("keydown", function(e) {
        if (e.which == 13) { // return
            e.preventDefault();
        }
    });

    // Prevent newlines in paste
    $(document).on("paste", ".inshiny-text-form", function (event) {
        event.preventDefault();

        // Strip newlines
        var text = (event.originalEvent.clipboardData || window.clipboardData).getData("text");
        text = text.replace(/\r?\n|\r/g, " ");

        // Insert text at caret
        const selection = window.getSelection();
        if (!selection.rangeCount) return;
        const range = selection.getRangeAt(0);
        range.deleteContents();
        range.insertNode(document.createTextNode(text));

        // Move caret after inserted text
        range.collapse(false);
        selection.removeAllRanges();
        selection.addRange(range);
    });

    // Create an observer instance
    // I use this rather than jQuery's on change event because the
    // inshiny-text-form elements are spans, and the change event only works
    // for input, select, and textarea elements.
    var observer = new MutationObserver(function(mutations) {
        mutations.forEach(function(mutation) {
            // Always grab the current text content of the observed element
            var el = mutation.target.nodeType === 3   // text node
                ? mutation.target.parentElement
                : mutation.target;
            var $el = $(el);
            var content = el.textContent || "";
            var handler = "";

            // Get datepicker, if present
            var datepicker;
            if ($el.hasClass("inshiny-with-datepicker")) {
                var datepicker_id = "inshiny-datepicker-" + $el.attr("id");
                datepicker = $("#" + datepicker_id).data().datepicker;
            }

            if (content === "") {
                // If content is empty, display placeholder
                $el.siblings(".inshiny-text-placeholder").css("display", "inline");
                if ($el.hasClass("inshiny-number-form")) {
                    // If number: remove invalid class (placeholder covers this)
                    // and set content to default, update aria "valuenow".
                    $el.siblings(".inshiny-text-box").removeClass("inshiny-invalid");
                    content = Number($el.data("default"));
                    $el.attr("aria-valuenow", content);
                } else if ($el.hasClass("inshiny-date-form")) {
                    // If number: remove invalid class (placeholder covers this)
                    // and set content to default (in datepicker's format),
                    // update "value" to default (in ISO format).
                    $el.siblings(".inshiny-text-box").removeClass("inshiny-invalid");
                    content = $el.data("default");
                    $el.data("value", $el.data("default"));
                }
            } else {
                // If content is present, remove placeholder
                $el.siblings(".inshiny-text-placeholder").css("display", "none");

                // Check validity for different inputs
                if ($el.hasClass("inshiny-number-form")) {
                    // Number: is number, and not outside range
                    var num = Number(content);
                    var min = $el.data("min");
                    var max = $el.data("max");
                    if (!is_number(content) || (min !== undefined && num < min) ||
                            (max !== undefined && num > max)) {
                        $el.siblings(".inshiny-text-box").addClass("inshiny-invalid");
                        content = Number($el.data("default"));
                    } else {
                        $el.siblings(".inshiny-text-box").removeClass("inshiny-invalid");
                        content = num; // format as number
                    }
                    $el.attr("aria-valuenow", content);
                } else if ($el.hasClass("inshiny-date-form")) {
                    // Date: textbox contents can be parsed and then reformatted
                    // and still the same, and date not disallowed or outside range.
                    var proposed_date = parse_date_dp(content, datepicker_id);
                    var formatted = format_date_dp(proposed_date, datepicker_id);
                    if (datepicker.dateIsDisabled(proposed_date) ||
                            !datepicker.dateWithinRange(proposed_date) ||
                            content != formatted) {
                        $el.siblings(".inshiny-text-box").addClass("inshiny-invalid");
                        content = $el.data("default");
                        $el.data("value", $el.data("default"));
                    } else {
                        $el.siblings(".inshiny-text-box").removeClass("inshiny-invalid");
                        content = format_date_iso(proposed_date);
                        $el.data("value", format_date_iso(proposed_date));
                    }
                }
            }

            // If this is a number form with associated slider, update the slider
            if ($el.hasClass("inshiny-with-slider")) {
                var slider = $("#" + "inshiny-slider-" + $el.attr("id")).data("ionRangeSlider");
                if (slider.result.from != content) {
                    $el.data("dontChange", true);
                    slider.update({ from: content });
                    $el.data("dontChange", false);
                }
            }
            // Similarly, update any associated datepicker
            if ($el.hasClass("inshiny-with-datepicker")) {
                if (format_date_iso(datepicker.getUTCDate()) != content) {
                    datepicker.update(format_date_dp(content, datepicker_id));
                }
                handler = ":shiny.date";
            }

            Shiny.setInputValue(el.id + handler, content, { priority: "event" });
        });
    });

    // Configuration of the observer
    var config = {
        subtree: true,
        characterData: true,
        childList: true
    };

    // Observe all changes to .inshiny-text-form elements
    $(".inshiny-text-form").each(function() {
        observer.observe(this, config);
    });

    // Focus event
    $(".inshiny-text-form").on("focus", function(e) {
        $(e.target).siblings(".inshiny-text-box").addClass("inshiny-focus");
    });

    // Blur event
    $(".inshiny-text-form").on("blur", function(e) {
        $(e.target).siblings(".inshiny-text-box").removeClass("inshiny-focus");
    });

    // Defer focus to form-text
    $(".inshiny-text-placeholder").on("click", function(e) {
        $(e.target).siblings(".inshiny-text-form")[0].focus();
    });

    $(".inshiny-text-rightpadding").on("click", function(e) {
        let sel = window.getSelection();
        sel.selectAllChildren($(e.target).siblings(".inshiny-text-form")[0]);
        sel.collapseToEnd();
    });


    // INLINE NUMBER WIDGET

    // Click-up event
    $(".inshiny-inc").on("mousedown", function(e) {
        adjust_number($(e.target).data("target-id"), +1);
    });

    // Click-down event
    $(".inshiny-dec").on("mousedown", function(e) {
        adjust_number($(e.target).data("target-id"), -1);
    });

    // Arrow keys up/down
    $(".inshiny-number-form").on("keydown", function(e) {
        if (e.which == 38) {
            adjust_number(e.target.id, +1); // Up arrow
        } else if (e.which == 40) {
            adjust_number(e.target.id, -1); // Down arrow
        } else if (e.which == 33) {
            adjust_number(e.target.id, +10); // Page up
        } else if (e.which == 34) {
            adjust_number(e.target.id, -10); // Page down
        } else if (e.which == 35) {
            adjust_number(e.target.id, +99); // End
        } else if (e.which == 36) {
            adjust_number(e.target.id, -99); // Home
        } else {
            return;
        }
        e.preventDefault();
    })


    // INLINE SLIDER WIDGET

    // Bind number forms to their sliders
    $(".inshiny-with-slider").each(function() {
        bind_slider(this.id);
    });


    // INLINE CALENDAR WIDGET

    // Bind date forms to their datepickers
    $(".inshiny-with-datepicker").each(function() {
        bind_datepicker(this.id);
    });


    // INLINE SWITCH WIDGET

    // Toggle labels and aria-checked on switch toggle
    $(".inshiny-switch").on("change", function() {
        set_switch_label($(this));
    });


    // INLINE LIST WIDGET

    function list_select($option) {
        var item = $option.data("item");
        var list = $option.data("list");
        $("#" + list)[0].textContent = item;

        $option.parent().parent().children().children().removeClass("active");
        $option.addClass("active");

        var $dropdown = $("#inshiny-list-drop-" + list);
        const dropdown = bootstrap.Dropdown.getInstance($dropdown) ||
            new bootstrap.Dropdown($dropdown);
        dropdown.hide();
    }

    // Note, these two item select handlers are attached to the menu
    // and delegated to each item. This ensures changes to choices don't
    // get lost and avoids the need to attach one handler for each item.
    $(".inshiny-menu").on("click", ".inshiny-item", function(e) {
        list_select($(e.target));
    });

    $(".inshiny-menu").on("keydown", ".inshiny-item", function(e) {
        // Enter or space
        if (e.which == 13 || e.which == 32) {
            list_select($(e.target));
            e.preventDefault();
        }
    });

    // This below causes the dropdown to open on keyboard select. This is
    // obviously useful to have and otherwise it's not there. We have to only
    // take keyboard focus events here (hence :focus-visible) as otherwise this
    // interferes with data-bs-toggle on mouse events.
    $(".inshiny-list-form").on("focus", function(e) {
        if (e.target.matches(":focus-visible")) {
            var $dropdown = $("#inshiny-list-drop-" + e.target.id);
            const dropdown = bootstrap.Dropdown.getInstance($dropdown) ||
                new bootstrap.Dropdown($dropdown);
            dropdown.show();
        }
    });


    // INLINE SELECTIZE WIDGET

    // Set initial width of each select element
    $(".inshiny-sel .selectize-input").each(function() {
        resize_select($(this));
    });

    // Keep track of changes to select elements
    var resize_observer = new MutationObserver(function(mutations) {
        mutations.forEach(function(mutation) {
            resize_select($(mutation.target));
        });
    });

    // Configuration of the observer
    var resize_config = {
        subtree: true,
        characterData: true,
        childList: true
    };

    // Observe all changes to .inshiny-text-form elements
    $(".inshiny-sel .selectize-input").each(function() {
        resize_observer.observe(this, resize_config);
    });
})


// WIDGET UPDATING

Shiny.addCustomMessageHandler("inshiny-update", function(message) {
    // if x is null or undefined, return d, else x
    deflt = function(x, d) {
        return x == null ? d : x;
    }
    // if x is undefined, return d, else x
    defln = function(x, d) {
        return x === undefined ? d : x;
    }
    var $target = $("#" + message.id)

    if ($target.hasClass("inshiny-link") || $target.hasClass("inshiny-btn")) {
        // link, button: label, icon, accent
        // get existing icon & label, replace with any new ones
        var $icon = $target.children("i:first[role=presentation]");
        var $label = $target.contents().not($icon);
        var icon = $icon.length ? $icon.prop("outerHTML") : "";
        var label = $label.length ? $label.clone().wrapAll("<div>").parent().html() : "";
        if (message.icon !== undefined)  icon = message.icon || "";
        if (message.label !== undefined) label = message.label || "";
        var new_content = icon + " " + label.trim();
        $target[0].innerHTML = new_content;

        // element-specific actions
        if ($target.hasClass("inshiny-link")) {
            // link - replace accent
            if (message.accent !== undefined) {
                $target.removeClass(function(i, n) { return (n.match(/(^|\s)link-\S+/g) || []).join(' '); });
                if (message.accent !== null) {
                    $target.addClass("link-" + message.accent);
                }
            }
        } else {
            // button - modify spacer and replace accent
            $target.siblings(".inshiny-btn-spacer")[0].innerHTML = new_content;
            if (message.accent !== undefined) {
                $target.removeClass(function(i, n) { return (n.match(/(^|\s)btn-\S+/g) || []).join(' '); });
                $target.addClass("btn-" + deflt(message.accent, "default"));
            }
        }
    } else if ($target.hasClass("inshiny-switch")) {
        // switch: value, on, off
        $target.data({
            "on-label":  deflt(message.on,  $target.data("on-label")),
            "off-label": deflt(message.off, $target.data("off-label"))
        });
        if (message.value != null) {
            $target.prop("checked", message.value);
        }
        set_switch_label($target);
    } else if ($target.hasClass("inshiny-text-form")) {
        if ($target.hasClass("inshiny-date-form")) {
            // date: value (NULL), min (NULL), max (NULL), datesdisabled (NULL), daysofweekdisabled (NULL)
            var datepicker_id = "inshiny-datepicker-" + message.id;
            var datepicker = $("#" + datepicker_id).data().datepicker;
            var curr_date = datepicker.getUTCDate();
            if (message.min !== undefined) {
                if (message.min === null) datepicker.setStartDate(null);
                else datepicker.setStartDate(new Date(message.min));
            }
            if (message.max !== undefined) {
                if (message.max === null) datepicker.setEndDate(null);
                else datepicker.setEndDate(new Date(message.max));
            }
            if (message.datesdisabled !== undefined) {
                if (message.datesdisabled === null) {
                    datepicker.setDatesDisabled(null);
                } else {
                    var ddis;
                    if (!Array.isArray(message.datesdisabled)) {
                        ddis = [new Date(message.datesdisabled)];
                    } else {
                        ddis = message.datesdisabled.map(x => new Date(x))
                    }
                    datepicker.setDatesDisabled(ddis);
                }
            }
            if (message.daysofweekdisabled !== undefined) {
                datepicker.setDaysOfWeekDisabled(message.daysofweekdisabled);
            }
            datepicker.setUTCDate(curr_date); // need to reset this after above changes
            if (message.value === null) {
                $target.text(format_date_dp(Date(), datepicker_id)); // current date
            } else if (message.value !== undefined) {
                $target.text(format_date_dp(message.value, datepicker_id)); // accepts Date or string
            }
        } else if ($target.hasClass("inshiny-list-form")) {
            // select: choices
            if (message.choices != null) {
                $("#inshiny-list-menu-" + message.id)[0].innerHTML = message.choices;
                /// $menu.children().children().each(function() { $(this).data("item", $(this).attr("data-item")); });
            }
        } else if ($target.hasClass("inshiny-with-slider")) {
            // slider: min, max, step (NULL), default
            var min = Number(deflt(message.min, $target.data("min")));
            var max = Number(deflt(message.max, $target.data("max")));
            var step = defln(message.step, $target.data("step"));
            if (step === null) { // auto choose step if null -- same method as in slider.R.
                let range = max - min;
                if (range < 2 || max != Math.floor(max) || min != Math.floor(min)) {
                    step = Math.pow(10, Math.round(Math.log10(range / 100)));
                } else {
                    step = 1;
                }
            }
            // numeric input
            $target.data({
                "min":     min,
                "max":     max,
                "step":    step,
                "default": deflt(message.default, $target.data("default"))
            });
            $target.attr({
                "aria-valuemin": min,
                "aria-valuemax": max
            })
            // slider
            $("#inshiny-slider-" + message.id).data("ionRangeSlider").update({
                min: min,
                max: max,
                step: step
            })
        } else if ($target.hasClass("inshiny-number-form")) {
            // numeric: min (NULL), max (NULL), step (NULL), default
            $target.data({
                "min":     deflt(message.min,     $target.data("min")),
                "max":     deflt(message.max,     $target.data("max")),
                "step":    deflt(message.step,    $target.data("step")),
                "default": deflt(message.default, $target.data("default"))
            });
            if (message.min === null)  rm_data($target, "min");
            if (message.max === null)  rm_data($target, "max");
            if (message.step === null) rm_data($target, "step");
            $target.attr({
                "aria-valuemin": defln(message.min, $target.attr("aria-valuemin")),
                "aria-valuemax": defln(message.max, $target.attr("aria-valuemax"))
            })
        }
        // all text except date: value, placeholder
        if (message.value != null && !$target.hasClass("inshiny-date-form")) {
            $target.text(message.value);
        }
        if (message.placeholder != null) {
            $target.attr("aria-placeholder", message.placeholder);
            $target.siblings(".inshiny-text-placeholder")[0].innerHTML = message.placeholder;
        }
    } else {
        throw new Error("Element with id " + message.id + " is not a recognised inshiny widget.")
    }

    // For all widgets
    if (message.meaning !== undefined) {
        $target.attr("aria-label", message.meaning);
    }
});
