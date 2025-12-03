# link is stable

    Code
      cc(inline_link("link_id", label = "Link", icon = shiny::icon("gears"), meaning = "A link",
      accent = c("success", "underline-warning")))
    Output
      <a id="link_id" href="#" class="action-button action-link inshiny-link link-success link-underline-warning" aria-label="A link">
        <span class="action-icon">
          <i class="fas fa-gears" role="presentation" aria-label="gears icon"></i>
        </span>
        <span class="action-label">Link</span>
      </a>

# button is stable

    Code
      cc(inline_button("btn_id", label = "Play", icon = shiny::icon("play"), meaning = "Play button",
      accent = "danger"))
    Output
      <span class="btn btn-danger inshiny-btn-container">
        <button id="btn_id" type="button" class="btn action-button btn-danger inshiny-btn" aria-label="Play button">
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

