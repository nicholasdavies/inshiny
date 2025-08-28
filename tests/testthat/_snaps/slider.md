# slider is stable

    Code
      cc(inline_slider("slider_id", value = 42, min = 1, max = 100, default = 99,
        placeholder = "Enter a number", meaning = "Favourite number"))
    Output
      <span class="dropdown-center">
        <span class="inshiny-text-container" data-bs-toggle="dropdown" data-bs-auto-close="outside" aria-expanded="false">
          <span id="slider_id" class="inshiny-nofocus inshiny-text-form inshiny-number-form inshiny-with-slider" contenteditable tabindex="0" role="spinbutton" aria-placeholder="Enter a number" aria-label="Favourite number" aria-valuenow="42" aria-valuemin="1" aria-valuemax="100" data-default="99" data-min="1" data-max="100" data-step="1">42</span>
          <span class="inshiny-text-placeholder text-info" aria-hidden="true">Enter a number</span>
          <span class="form-control inshiny-text-box" aria-hidden="true"></span>
          <span class="inshiny-text-rightpadding" aria-hidden="true"></span>
        </span>
        <div class="dropdown-menu p-3 rounded-3 border shadow">
          <div class="shiny-input-container">
            <label class="control-label shiny-label-null inshiny-slider" id="inshiny-slider-slider_id-label" for="inshiny-slider-slider_id"></label>
            <input class="js-range-slider" id="inshiny-slider-slider_id" data-skin="shiny" data-min="1" data-max="100" data-from="42" data-step="1" data-grid="true" data-grid-num="9.9" data-grid-snap="false" data-prettify-separator="," data-prettify-enabled="true" data-keyboard="true" data-data-type="number"/>
          </div>
        </div>
      </span>

