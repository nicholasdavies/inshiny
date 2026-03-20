# button is stable

    Code
      cc(inline_button("btn_id", label = "Play", icon = shiny::icon("play"), meaning = "Play button",
      accent = "danger"))
    Output
      <span class="btn btn-danger inshiny-btn-container">
        <button id="btn_id" class="btn action-button btn-danger inshiny-btn" aria-label="Play button" type="button">
          <span class="action-icon">
            <i class="fas fa-play" role="presentation" aria-label="play icon"></i>
          </span>
          <span class="action-label">Play</span>
        </button>
        <span class="inshiny-btn-spacer">
          <span class="action-icon">
            <i class="fas fa-play" role="presentation" aria-label="play icon"></i>
          </span>
          <span class="action-label">Play</span>
        </span>
      </span>

