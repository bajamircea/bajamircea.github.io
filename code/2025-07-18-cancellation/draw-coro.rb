#!/usr/bin/env ruby

require_relative '../util/svg.rb'

# for commits
color_neutral = "#2d93ad"
color_neutral2 = "#6ac3d9"

color_green= "#8ea604"
color_green2 = "#a8ac03"
color_green3 = "#c2b102"
color_green4 = "#dcb601"

color_orange = "#f5bb00"
color_red = "#ee6055"
color_stop_red = "#ce2029"

color_white = "#ffffff"
color_blue = "#2d93ad"
color_pink = "#ff36ab"
color_pink1 = "#ffcdea"
color_pink2 = "#ff9bd5"
color_pink3 = "#ff69c0"
color_purple = "#9665ac"

color_grey = "#cccccc"

$crt_id = 0

def make_id(arg)
  return "svg20250603-" + $crt_id.to_s + "-" + arg
end

image = svg({
  id: make_id("box"),
  width: "100%",
  viewBox: "0 0 800 300",
  }) do

  style().add_text(<<-CSS)
    ##{make_id("box")} {
      border: 1px solid #e8e8e8;
      background-color: #f5f5f5;
    }
    .#{make_id("stop_border")} {
      stroke: #000000;
      stroke-width: 4;
      fill: none;
    }
    .#{make_id("stop_sign")} {
      stroke: #ffffff;
      stroke-width: 16;
      fill: #{color_stop_red};
    }
    .#{make_id("stop_word")} {
      stroke: #ffffff;
      stroke-width: 16;
      fill: none;
    }
  CSS

  path(
    class: make_id("stop_sign"),
    d: "M 113 15 h 138 l 100 100 v 136 l -100 100 h -138 l -100 -100 v -136 z",
  )
  path(
    class: make_id("stop_border"),
    d: "M 110 10 h 144 l 100 100 v 144 l -100 100 h -144 l -100 -100 v -144 z",
  )

  path(
    class: make_id("stop_word"),
    d: "M 100 160"\
       "q 0 -20 -20 -20 q -20 0 -20 20 q 0 10 20 20"\
       "q 20 10 20 20 q 0 20 -20 20 q -20 0 -20 -20",
  )
  path(
    class: make_id("stop_word"),
    d: "M 115 140 h 60 h -30 v 88",
  )
  ellipse(
    class: make_id("stop_word"),
    cx: 215, cy: 180, rx: 30, ry: 40,
  )
  path(
    class: make_id("stop_word"),
    d: "M 275 228 v -88 h 20 a 20 20 0 0 1 0 40 h -20",
  )

end

# puts(image.render)

save_to_file("_includes/assets/2025-07-18-cancellation-leaves", "00-cover.svg", image.render)

$crt_id += 1

