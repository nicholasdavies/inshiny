# date is stable

    Code
      cc(inline_date("date_id", value = as.Date("2025-08-28"), min = "2025-01-01",
      max = NULL, placeholder = "Enter date", meaning = "Date to select", format = "dd/mm/yyyy",
      startview = "year", weekstart = 1, language = "en", autoclose = TRUE,
      datesdisabled = c("2025-12-25", "2026-12-25"), daysofweekdisabled = c(0, 6)))
    Output
      <span class="dropdown-center">
        <span class="inshiny-text-container" id="inshiny-date-drop-date_id" data-bs-toggle="dropdown" data-bs-auto-close="outside" aria-expanded="false">
          <span id="date_id" class="inshiny-nofocus inshiny-text-form inshiny-date-form inshiny-with-datepicker" contenteditable tabindex="0" role="textbox" aria-placeholder="Enter date" aria-label="Date to select" data-default="2025-08-28" data-value="2025-08-28">2025-08-28</span>
          <span class="inshiny-text-placeholder text-info" aria-hidden="true">Enter date</span>
          <span class="form-control inshiny-text-box" aria-hidden="true"></span>
          <span class="inshiny-text-rightpadding" aria-hidden="true"></span>
        </span>
        <div class="dropdown-menu p-3 rounded-3 border shadow">
          <div title="Date format: dd/mm/yyyy" data-date-language="en" data-date-week-start="1" data-date-format="dd/mm/yyyy" data-date-start-view="year" data-min-date="2025-01-01" data-initial-date="2025-08-28" data-date-autoclose="false" data-date-dates-disabled="[&quot;2025-12-25&quot;,&quot;2026-12-25&quot;]" data-date-days-of-week-disabled="[0,6]" id="inshiny-datepicker-date_id" data-autoclose="true" class="inshiny-datepicker"></div>
        </div>
      </span>

