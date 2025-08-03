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
    .#{make_id("l1")} {
      stroke: #{color_blue};
      stroke-width: 3;
      fill: none;
    }
    .#{make_id("arrow")} {
      stroke: #{color_blue};
      stroke-width: 1;
      fill: #{color_blue};
    }
    .#{make_id("l2")} {
      stroke: #{color_green};
      stroke-width: 3;
      fill: none;
    }
    .#{make_id("arrow2")} {
      stroke: #{color_green};
      stroke-width: 1;
      fill: #{color_green};
    }
    .#{make_id("l3")} {
      stroke: #{color_purple};
      stroke-width: 3;
      fill: none;
    }
    .#{make_id("arrow3")} {
      stroke: #{color_purple};
      stroke-width: 1;
      fill: #{color_purple};
    }
    .#{make_id("l4")} {
      stroke: #{color_red};
      stroke-width: 3;
      fill: none;
    }
    .#{make_id("box_white")} {
      stroke: #000000;
      stroke-width: 2;
      fill: #{color_white};
    }
  CSS

  defs() do
    marker(
      id: make_id("arrow"),
      viewBox: "0, 0, 10, 10",
      refX: 5, refY: 5,
      markerWidth: 6, markerHeight: 6,
      orient: "auto-start-reverse",
    ) do
      path(
        d: "M 0 0 L 10 5 L 0 10 L 2.5 5 Z",
        class: make_id("arrow")
      )
    end
    marker(
      id: make_id("arrow2"),
      viewBox: "0, 0, 10, 10",
      refX: 5, refY: 5,
      markerWidth: 6, markerHeight: 6,
      orient: "auto-start-reverse",
    ) do
      path(
        d: "M 0 0 L 10 5 L 0 10 L 2.5 5 Z",
        class: make_id("arrow2")
      )
    end
    marker(
      id: make_id("arrow3"),
      viewBox: "0, 0, 10, 10",
      refX: 5, refY: 5,
      markerWidth: 6, markerHeight: 6,
      orient: "auto-start-reverse",
    ) do
      path(
        d: "M 0 0 L 10 5 L 0 10 L 2.5 5 Z",
        class: make_id("arrow3")
      )
    end
  end

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

  path(
    class: make_id("l1"),
    d: "M 540 30 c 0 20 -10 20 -50 20 s -50 0 -50 20",
    marker_end: "url(##{make_id("arrow")})"
  )
  path(
    class: make_id("l2"),
    d: "M 540 30 v 40",
    marker_end: "url(##{make_id("arrow2")})"
  )
  path(
    class: make_id("l3"),
    d: "M 540 30 c 0 20 10 20 50 20 s 50 0 50 20",
    marker_end: "url(##{make_id("arrow3")})"
  )

  path(
    class: make_id("l1"),
    d: "M 440 113 c 0 20 10 20 50 20 s 50 0 50 20"
  )
  path(
    class: make_id("l3"),
    d: "M 640 113 c 0 20 -10 20 -50 20 s -50 0 -50 20"
  )
  path(
    class: make_id("l2"),
    d: "M 540 113 v 40",
    marker_end: "url(##{make_id("arrow2")})"
  )

  path(
    class: make_id("box_white"),
    d: "M 410 82 h 60 v 30 l -60 10 z"
  )
  rect(x: 510, y: 82, width: 60, height: 30, class: make_id("box_white"))
  path(
    class: make_id("box_white"),
    d: "M 610 82 h 60 v 30 l -60 10 z"
  )

  line(
    class: make_id("l4"),
    x1: 415, y1: 115, x2: 425, y2: 105
  )
  line(
    class: make_id("l4"),
    x1: 415, y1: 105, x2: 425, y2: 115
  )
  line(
    class: make_id("l4"),
    x1: 615, y1: 115, x2: 625, y2: 105
  )
  line(
    class: make_id("l4"),
    x1: 615, y1: 105, x2: 625, y2: 115
  )

end

# puts(image.render)

save_to_file("_includes/assets/2025-08-03-cancellation", "00-cover.svg", image.render)

$crt_id += 1

