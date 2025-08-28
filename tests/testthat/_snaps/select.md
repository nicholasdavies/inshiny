# select is stable

    Code
      cc(inline_select("select_id", list(`Dog names` = c("Fido", "Rex"), `Cat names` = c(
        "Felix", "Boots")), selected = "Rex", multiple = FALSE, meaning = "Select a pet name"))
    Output
      <span class="dropdown-center">
        <span class="inshiny-text-container" id="inshiny-list-drop-select_id" data-bs-toggle="dropdown" data-bs-auto-close="outside" aria-expanded="false">
          <span id="select_id" class="inshiny-nofocus inshiny-text-form inshiny-list-form inshiny-with-options" tabindex="0" role="textbox" aria-placeholder="&amp;nbsp;" aria-label="Select a pet name">Rex</span>
          <span class="inshiny-text-placeholder text-info" aria-hidden="true">&nbsp;</span>
          <span class="form-control inshiny-text-box" aria-hidden="true"></span>
          <span class="inshiny-text-rightpadding" aria-hidden="true"></span>
        </span>
        <ul id="inshiny-list-menu-select_id" class="dropdown-menu p-1 rounded-3 border shadow inshiny-menu" style="min-width: 1rem; max-height: 18.5rem; overflow-y: auto"><li><h6 class="dropdown-header">Dog names</h6></li>
      <li><a class="dropdown-item inshiny-item" href="#" data-list="select_id" data-item="Fido">Fido</a></li>
      <li><a class="dropdown-item inshiny-item active" href="#" data-list="select_id" data-item="Rex" selected>Rex</a></li>
      <li><h6 class="dropdown-header">Cat names</h6></li>
      <li><a class="dropdown-item inshiny-item" href="#" data-list="select_id" data-item="Felix">Felix</a></li>
      <li><a class="dropdown-item inshiny-item" href="#" data-list="select_id" data-item="Boots">Boots</a></li></ul>
      </span>

---

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

