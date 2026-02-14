# number is stable

    Code
      cc(inline_number("number_id", value = 42, min = 1, max = 100, step = 2,
        default = 99, placeholder = "Enter a number", meaning = "Favourite number"))
    Output
      <span>
        <div class="inshiny-arrows">
          <span class="inshiny-inc" data-target-id="number_id"></span>
          <span class="inshiny-dec" data-target-id="number_id"></span>
        </div>
        <span class="inshiny-text-container">
          <span id="number_id" class="inshiny-nofocus inshiny-text-form inshiny-number-form" contenteditable tabindex="0" aria-placeholder="Enter a number" aria-label="Favourite number" role="spinbutton" aria-valuenow="42" aria-valuemin="1" aria-valuemax="100" data-default="99" data-min="1" data-max="100" data-step="2">42</span>
          <span class="inshiny-text-placeholder text-info" aria-hidden="true">Enter a number</span>
          <span class="form-control inshiny-text-box" aria-hidden="true"></span>
          <span class="inshiny-text-rightpadding" aria-hidden="true"></span>
        </span>
      </span>

