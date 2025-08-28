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
    // INLINE TEXT WIDGET

    // Send initial value for .inshiny-form-text elements
    $(".inshiny-form-text").each(function() {
        Shiny.setInputValue($(this).attr("id"),
            $(this).text(), { priority: "event" });
    });

    // Create an observer instance
    var observer = new MutationObserver(function(mutations) {
        mutations.forEach(function(mutation) {
            Shiny.setInputValue(mutation.target.parentElement.id,
                mutation.target.data, { priority: "event" });
        });
    });

    // Configuration of the observer
    var config = {
        subtree: true,
        characterData: true
    };

    // Observe all changes to .inshiny-form-text elements
    $(".inshiny-form-text").each(function() {
        observer.observe(this, config);
    });

    // Focus event
    $(".inshiny-form-text").on("focus", function(e) {
        $(e.target).next().addClass("inshiny-focus");
    });

    // Blur event
    $(".inshiny-form-text").on("blur", function(e) {
        $(e.target).next().removeClass("inshiny-focus");
    });

    // Create form text colour style
    const form_color = getStyleProperty("input", "form-control", "color", false);
    var form_style = document.createElement("style");
    form_style.type = "text/css";
    form_style.innerHTML = ".inshiny-form-text { color: " + form_color + "; }";
    document.head.appendChild(form_style);

    // Create invalid styles
    const invalid_color = getStyleProperty("div", "text-bg-danger", "color", false);
    const invalid_bgcolor = getStyleProperty("div", "text-bg-danger", "background-color", false);
    var invalid_style = document.createElement("style");
    invalid_style.type = "text/css";
    invalid_style.innerHTML = ".inshiny-invalid-color { color: " + invalid_color + "; }" +
        "\n.inshiny-invalid-bgcolor { background-color: " + invalid_bgcolor + "; }";
    document.head.appendChild(invalid_style);

    // Create fake focus style
    // In Boostrap themes, box-shadow is the only element of .focus-ring besides outline: 0.
    // We also change the border-color to --bs-primary.
    const box_shadow = getStyleProperty("input", "focus-ring", "box-shadow", true);
    var focus_style = document.createElement("style");
    focus_style.type = "text/css";
    focus_style.innerHTML = ".inshiny-focus { box-shadow: " + box_shadow + "; border-color: var(--bs-primary); }";
    document.head.appendChild(focus_style);
})
