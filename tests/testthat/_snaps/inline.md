# inline is stable

    Code
      cc(inline("This is a ", shiny::span(style = "color: red", "test"), ".", class = "mb-2",
      style = "font-weight: bold"))
    Output
      <div class="inshiny-inline mb-2" style="font-weight: bold"><span class="inshiny-span">This is a </span><span style="color: red">test</span><span class="inshiny-span">.</span></div>

