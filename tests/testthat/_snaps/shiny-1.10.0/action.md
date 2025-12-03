# link is stable

    Code
      cc(inline_link("link_id", label = "Link", icon = shiny::icon("gears"), meaning = "A link",
      accent = c("success", "underline-warning")))
    Output
      <a id="link_id" href="#" class="action-button inshiny-link link-success link-underline-warning" aria-label="A link">
        <i class="fas fa-gears" role="presentation" aria-label="gears icon"></i>
        Link
      </a>

# button is stable

    Code
      cc(inline_button("btn_id", label = "Play", icon = shiny::icon("play"), meaning = "Play button",
      accent = "danger"))
    Output
      <span class="btn btn-danger inshiny-btn-container">
        <button id="btn_id" type="button" class="btn action-button btn-danger inshiny-btn" aria-label="Play button">
          <i class="fas fa-play" role="presentation" aria-label="play icon"></i>
          Play
        </button>
        <span class="inshiny-btn-spacer">
          <i class="fas fa-play" role="presentation" aria-label="play icon"></i>
          Play
        </span>
      </span>

