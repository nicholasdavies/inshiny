// STYLE HELPERS

// Helper function to get style of tag (tag_name, e.g. "input") of class
// class_name, compared to an unclassed tag (comparator_name, e.g. "div")
// optionally with focus (true/false)
// Not currently used but here for reference
function getStyle(tag_name, class_name, comparator_name, focus)
{
    // Create a temporary element
    const el = document.createElement(tag_name);
    el.className = class_name;
    el.style.position = "absolute";
    el.style.left = "-9999px";
    document.body.appendChild(el);

    // Comparator element
    const comp = document.createElement(comparator_name);
    comp.style.position = "absolute";
    comp.style.left = "-9999px";
    document.body.appendChild(comp);

    // If requested, force focus
    if (focus) {
        el.tabIndex = -1;
        el.focus();
    }

    // Read the computed style and how it differs from comparator style
    const style = getComputedStyle(el);
    const style_comp = getComputedStyle(comp);

    // Build CSS text
    let cssText = "";
    for (let i = 0; i < style.length; i++) {
        const prop = style[i];
        const val = style.getPropertyValue(prop);
        const val_comp = style_comp.getPropertyValue(prop);
        if (val != val_comp) {
            cssText += `${prop}: ${val}; `;
        }
    }

    // Clean up
    document.body.removeChild(el);
    document.body.removeChild(comp);

    return cssText;
}

// Get a specific CSS property for a CSS class, optionally with :focus
function getStyleProperty(tag_name, class_name, property_name, focus)
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

$(document).on("shiny:connected", function() {
    // INLINE NUMBER WIDGET

    // Send initial value for .inshiny-form-text elements
    //$(".inshiny-form-text").each(function() {
    //    Shiny.setInputValue($(this).attr("id"),
    //        $(this).text(), { priority: "event" });
    //});

    // Click-up event
    $(".inc").on("mousedown", function(e) {
        var target_id = $(e.target).data("target-id");
        var $target = $("#" + target_id);
        var num = Number($target.text());
        $target.text(num + 1);
    });

    // Click-down event
    $(".dec").on("mousedown", function(e) {
        var target_id = $(e.target).data("target-id");
        var $target = $("#" + target_id);
        var num = Number($target.text());
        $target.text(num - 1);
    });
})
