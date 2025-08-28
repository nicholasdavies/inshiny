# switch is stable

    Code
      cc(inline_switch("switch_id", value = FALSE, on = shiny::span("On", class = "text-success"),
      off = shiny::span("Off", class = "text-danger"), meaning = "On/off switch"))
    Output
      <span data-require-bs-version="5" data-require-bs-caller="input_switch()">
        <span class="bslib-input-switch form-switch form-check inshiny-switch-container">
          <input id="switch_id" class="form-check-input inshiny-switch" type="checkbox" role="switch" aria-label="On/off switch" aria-checked="false" data-label-id="inshiny-switch-label-switch_id" data-on-label="&lt;span class=&quot;text-success&quot;&gt;On&lt;/span&gt;" data-off-label="&lt;span class=&quot;text-danger&quot;&gt;Off&lt;/span&gt;"/>
        </span>
        <span id="inshiny-switch-label-switch_id">
          <span class="text-danger">Off</span>
        </span>
      </span>

