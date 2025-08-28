# text is stable

    Code
      cc(inline_text("text_id", value = "Hello.", placeholder = "Enter some text",
        meaning = "Text input"))
    Output
      <span class="inshiny-text-container">
        <span id="text_id" class="inshiny-nofocus inshiny-text-form" contenteditable tabindex="0" role="textbox" aria-placeholder="Enter some text" aria-label="Text input">Hello.</span>
        <span class="inshiny-text-placeholder text-info" aria-hidden="true">Enter some text</span>
        <span class="form-control inshiny-text-box" aria-hidden="true"></span>
        <span class="inshiny-text-rightpadding" aria-hidden="true"></span>
      </span>

