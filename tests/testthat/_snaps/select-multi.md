# select is stable

    Code
      cc(inline_select("select_id", list(`Dog names` = c("Fido", "Rex"), `Cat names` = c(
        "Felix", "Boots")), selected = "Rex", multiple = TRUE, meaning = "Select a pet name"))
    Output
      <span class="inshiny-sel-container">
        <div class="inshiny-sel">
          <select id="select_id" class="shiny-input-select" multiple="multiple" aria-label="Select a pet name"><optgroup label="Dog names">
      <option value="Fido">Fido</option>
      <option value="Rex" selected>Rex</option>
      </optgroup>
      <optgroup label="Cat names">
      <option value="Felix">Felix</option>
      <option value="Boots">Boots</option>
      </optgroup></select>
          <script type="application/json" data-for="select_id">{"plugins":["selectize-plugin-a11y"]}</script>
        </div>
        <span class="inshiny-sel-spacer" style="width: 500px"></span>
      </span>

