#!/usr/bin/env ruby

require_relative '../util/svg.rb'

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
  return "svg20251118-" + $crt_id.to_s + "-" + arg
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

save_to_file("_includes/assets/2025-11-18-cancellation-propagation", "00-cover.svg", image.render)

$crt_id += 1

image = svg({
  id: make_id("box"),
  width: "100%",
  viewBox: "0 0 800 180",
  }) do

  style().add_text(<<-CSS)
    ##{make_id("box")} {
      border: 1px solid #e8e8e8;
      background-color: #f5f5f5;
    }
    .#{make_id("t1")} {
      font-family: sans-serif;
      font-size: 16px;
      text-anchor: middle;
      dominant-baseline: middle;
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
    class: make_id("l1"),
    d: "M 140 30 c 0 20 -10 20 -50 20 s -50 0 -50 20",
    marker_end: "url(##{make_id("arrow")})"
  )
  path(
    class: make_id("l2"),
    d: "M 140 30 v 40",
    marker_end: "url(##{make_id("arrow2")})"
  )
  path(
    class: make_id("l3"),
    d: "M 140 30 c 0 20 10 20 50 20 s 50 0 50 20",
    marker_end: "url(##{make_id("arrow3")})"
  )

  path(
    class: make_id("l1"),
    d: "M 40 113 c 0 20 10 20 50 20 s 50 0 50 20"
  )
  path(
    class: make_id("l3"),
    d: "M 240 113 c 0 20 -10 20 -50 20 s -50 0 -50 20"
  )
  path(
    class: make_id("l2"),
    d: "M 140 113 v 40",
    marker_end: "url(##{make_id("arrow2")})"
  )

  path(
    class: make_id("box_white"),
    d: "M 10 82 h 60 v 30 l -60 10 z"
  )
  rect(x: 110, y: 82, width: 60, height: 30, class: make_id("box_white"))
  path(
    class: make_id("box_white"),
    d: "M 210 82 h 60 v 30 l -60 10 z"
  )

  line(
    class: make_id("l4"),
    x1: 15, y1: 115, x2: 25, y2: 105
  )
  line(
    class: make_id("l4"),
    x1: 15, y1: 105, x2: 25, y2: 115
  )
  line(
    class: make_id("l4"),
    x1: 215, y1: 115, x2: 225, y2: 105
  )
  line(
    class: make_id("l4"),
    x1: 215, y1: 105, x2: 225, y2: 115
  )

  text(
    class: make_id("t1"),
    x: 140, y: 15
  ).add_text("wait_any")
end

# puts(image.render)

save_to_file("_includes/assets/2025-11-18-cancellation-propagation", "01-wait_any-structured.svg", image.render)

$crt_id += 1

image = svg({
  id: make_id("box"),
  width: "100%",
  viewBox: "0 0 800 320",
  }) do

  style().add_text(<<-CSS)
    ##{make_id("box")} {
      border: 1px solid #e8e8e8;
      background-color: #f5f5f5;
    }
    .#{make_id("t1")} {
      font-family: sans-serif;
      font-size: 16px;
      text-anchor: left;
      dominant-baseline: middle;
    }
    .#{make_id("l0")} {
      stroke: #{color_orange};
      stroke-width: 3;
      fill: none;
    }
    .#{make_id("arrow0")} {
      stroke: #{color_orange};
      stroke-width: 1;
      fill: #{color_orange};
    }
    .#{make_id("l1")} {
      stroke: #{color_blue};
      stroke-width: 3;
      fill: none;
    }
    .#{make_id("arrow1")} {
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
    .#{make_id("box_white")} {
      stroke: #000000;
      stroke-width: 2;
      fill: #{color_white};
    }
  CSS

  defs() do
    marker(
      id: make_id("arrow0"),
      viewBox: "0, 0, 10, 10",
      refX: 5, refY: 5,
      markerWidth: 6, markerHeight: 6,
      orient: "auto-start-reverse",
    ) do
      path(
        d: "M 0 0 L 10 5 L 0 10 L 2.5 5 Z",
        class: make_id("arrow0")
      )
    end
    marker(
      id: make_id("arrow1"),
      viewBox: "0, 0, 10, 10",
      refX: 5, refY: 5,
      markerWidth: 6, markerHeight: 6,
      orient: "auto-start-reverse",
    ) do
      path(
        d: "M 0 0 L 10 5 L 0 10 L 2.5 5 Z",
        class: make_id("arrow1")
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

  rect(x: -20, y: 152, width: 60, height: 30, class: make_id("box_white"))

  rect(x: 70, y: 5, width: 180, height: 310, class: make_id("box_white"))
  path(
    class: make_id("l0"),
    d: "M 10 158 c 20 -70 70 -40 70 -18",
    marker_end: "url(##{make_id("arrow0")})"
  )
  path(
    class: make_id("l0"),
    d: "M 80 183 c -5 30 -40 30 -66 -16",
    marker_end: "url(##{make_id("arrow0")})"
  )

  rect(x: 270, y: 52, width: 60, height: 30, class: make_id("box_white"))
  path(
    class: make_id("l1"),
    d: "M 230 58 c 20 -70 70 -40 70 -18",
    marker_end: "url(##{make_id("arrow1")})"
  )
  path(
    class: make_id("l1"),
    d: "M 300 83 c -5 30 -40 30 -66 -16",
    marker_end: "url(##{make_id("arrow1")})"
  )
  path(
    class: make_id("l1"),
    d: "M 300 58 c 20 -70 70 -40 70 -18",
    marker_end: "url(##{make_id("arrow1")})"
  )
  path(
    class: make_id("l1"),
    d: "M 370 83 c -5 30 -40 30 -66 -16",
    marker_end: "url(##{make_id("arrow1")})"
  )

  rect(x: 340, y: 52, width: 60, height: 30, class: make_id("box_white"))
  path(
    class: make_id("l1"),
    d: "M 370 58 c 20 -70 70 -40 70 -18",
    marker_end: "url(##{make_id("arrow1")})"
  )
  path(
    class: make_id("l1"),
    d: "M 440 83 c -5 30 -40 30 -66 -16",
    marker_end: "url(##{make_id("arrow1")})"
  )

  rect(x: 410, y: 52, width: 60, height: 30, class: make_id("box_white"))

  rect(x: 270, y: 152, width: 60, height: 30, class: make_id("box_white"))
  path(
    class: make_id("l2"),
    d: "M 230 158 c 20 -70 70 -40 70 -18",
    marker_end: "url(##{make_id("arrow2")})"
  )
  path(
    class: make_id("l2"),
    d: "M 300 183 c -5 30 -40 30 -66 -16",
    marker_end: "url(##{make_id("arrow2")})"
  )
  path(
    class: make_id("l2"),
    d: "M 300 158 c 20 -70 70 -40 70 -18",
    marker_end: "url(##{make_id("arrow2")})"
  )
  path(
    class: make_id("l2"),
    d: "M 370 183 c -5 30 -40 30 -66 -16",
    marker_end: "url(##{make_id("arrow2")})"
  )

  rect(x: 340, y: 152, width: 60, height: 30, class: make_id("box_white"))
  path(
    class: make_id("l2"),
    d: "M 370 158 c 20 -70 70 -40 70 -18",
    marker_end: "url(##{make_id("arrow2")})"
  )
  path(
    class: make_id("l2"),
    d: "M 440 183 c -5 30 -40 30 -66 -16",
    marker_end: "url(##{make_id("arrow2")})"
  )

  rect(x: 410, y: 152, width: 60, height: 30, class: make_id("box_white"))

  rect(x: 270, y: 252, width: 60, height: 30, class: make_id("box_white"))
  path(
    class: make_id("l3"),
    d: "M 230 258 c 20 -70 70 -40 70 -18",
    marker_end: "url(##{make_id("arrow3")})"
  )
  path(
    class: make_id("l3"),
    d: "M 300 283 q -100 40 -210 -90",
    marker_end: "url(##{make_id("arrow3")})"
  )
  path(
    class: make_id("l3"),
    d: "M 300 258 c 20 -70 70 -40 70 -18",
    marker_end: "url(##{make_id("arrow3")})"
  )
  path(
    class: make_id("l3"),
    d: "M 370 283 c -5 30 -40 30 -66 -16",
    marker_end: "url(##{make_id("arrow3")})"
  )

  rect(x: 340, y: 252, width: 60, height: 30, class: make_id("box_white"))
  path(
    class: make_id("l3"),
    d: "M 370 258 c 20 -70 70 -40 70 -18",
    marker_end: "url(##{make_id("arrow3")})"
  )
  path(
    class: make_id("l3"),
    d: "M 440 283 c -5 30 -40 30 -66 -16",
    marker_end: "url(##{make_id("arrow3")})"
  )

  rect(x: 410, y: 252, width: 60, height: 30, class: make_id("box_white"))

  text(
    class: make_id("t1"),
    x: 10, y: 85
  ).add_text("parent")
  text(
    class: make_id("t1"),
    x: 10, y: 105
  ).add_text("chain")

  text( class: make_id("t1"),
    x: 80, y: 25
  ).add_text("wait_any")
  text( class: make_id("t1"),
    x: 90, y: 45
  ).add_text("stop_source: false")
  text( class: make_id("t1"),
    x: 90, y: 65
  ).add_text("pending: 3")
  text(
    class: make_id("t1"),
    x: 490, y: 65
  ).add_text("child chain 1")
  text( class: make_id("t1"),
    x: 490, y: 165
  ).add_text("child chain 2")
  text( class: make_id("t1"),
    x: 490, y: 265
  ).add_text("child chain 3")
end

# puts(image.render)

save_to_file("_includes/assets/2025-11-18-cancellation-propagation", "02-wait_any-chains.svg", image.render)

$crt_id += 1

image = svg({
  id: make_id("box"),
  width: "100%",
  viewBox: "0 0 800 320",
  }) do

  style().add_text(<<-CSS)
    ##{make_id("box")} {
      border: 1px solid #e8e8e8;
      background-color: #f5f5f5;
    }
    .#{make_id("t1")} {
      font-family: sans-serif;
      font-size: 16px;
      text-anchor: left;
      dominant-baseline: middle;
    }
    .#{make_id("l0")} {
      stroke: #{color_orange};
      stroke-width: 3;
      fill: none;
    }
    .#{make_id("arrow0")} {
      stroke: #{color_orange};
      stroke-width: 1;
      fill: #{color_orange};
    }
    .#{make_id("l1")} {
      stroke: #{color_blue};
      stroke-width: 3;
      fill: none;
    }
    .#{make_id("arrow1")} {
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
    .#{make_id("box_white")} {
      stroke: #000000;
      stroke-width: 2;
      fill: #{color_white};
    }
  CSS

  defs() do
    marker(
      id: make_id("arrow0"),
      viewBox: "0, 0, 10, 10",
      refX: 5, refY: 5,
      markerWidth: 6, markerHeight: 6,
      orient: "auto-start-reverse",
    ) do
      path(
        d: "M 0 0 L 10 5 L 0 10 L 2.5 5 Z",
        class: make_id("arrow0")
      )
    end
    marker(
      id: make_id("arrow1"),
      viewBox: "0, 0, 10, 10",
      refX: 5, refY: 5,
      markerWidth: 6, markerHeight: 6,
      orient: "auto-start-reverse",
    ) do
      path(
        d: "M 0 0 L 10 5 L 0 10 L 2.5 5 Z",
        class: make_id("arrow1")
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

  rect(x: -20, y: 152, width: 60, height: 30, class: make_id("box_white"))

  rect(x: 70, y: 5, width: 180, height: 310, class: make_id("box_white"))
  path(
    class: make_id("l0"),
    d: "M 10 158 c 20 -70 70 -40 70 -18",
    marker_end: "url(##{make_id("arrow0")})"
  )

  rect(x: 270, y: 52, width: 60, height: 30, class: make_id("box_white"))
  path(
    class: make_id("l1"),
    d: "M 230 58 c 20 -70 70 -40 70 -18",
    marker_end: "url(##{make_id("arrow1")})"
  )
  rect(x: 340, y: 52, width: 60, height: 30, class: make_id("box_white"))
  path(
    class: make_id("l1"),
    d: "M 300 58 c 20 -70 70 -40 70 -18",
    marker_end: "url(##{make_id("arrow1")})"
  )
  rect(x: 410, y: 52, width: 60, height: 30, class: make_id("box_white"))
  path(
    class: make_id("l1"),
    d: "M 370 58 c 20 -70 70 -40 70 -18",
    marker_end: "url(##{make_id("arrow1")})"
  )


  rect(x: 270, y: 152, width: 60, height: 30, class: make_id("box_white"))
  path(
    class: make_id("l2"),
    d: "M 230 158 c 20 -70 70 -40 70 -18",
    marker_end: "url(##{make_id("arrow2")})"
  )
  rect(x: 340, y: 152, width: 60, height: 30, class: make_id("box_white"))
  path(
    class: make_id("l2"),
    d: "M 300 158 c 20 -70 70 -40 70 -18",
    marker_end: "url(##{make_id("arrow2")})"
  )
  rect(x: 410, y: 152, width: 60, height: 30, class: make_id("box_white"))
  path(
    class: make_id("l2"),
    d: "M 370 158 c 20 -70 70 -40 70 -18",
    marker_end: "url(##{make_id("arrow2")})"
  )


  rect(x: 270, y: 252, width: 60, height: 30, class: make_id("box_white"))
  path(
    class: make_id("l3"),
    d: "M 230 258 c 20 -70 70 -40 70 -18",
    marker_end: "url(##{make_id("arrow3")})"
  )
  rect(x: 340, y: 252, width: 60, height: 30, class: make_id("box_white"))
  path(
    class: make_id("l3"),
    d: "M 300 258 c 20 -70 70 -40 70 -18",
    marker_end: "url(##{make_id("arrow3")})"
  )
  rect(x: 410, y: 252, width: 60, height: 30, class: make_id("box_white"))
  path(
    class: make_id("l3"),
    d: "M 370 258 c 20 -70 70 -40 70 -18",
    marker_end: "url(##{make_id("arrow3")})"
  )

  text(
    class: make_id("t1"),
    x: 10, y: 85
  ).add_text("parent")
  text(
    class: make_id("t1"),
    x: 10, y: 105
  ).add_text("chain")

  text( class: make_id("t1"),
    x: 80, y: 25
  ).add_text("wait_any")
  text( class: make_id("t1"),
    x: 90, y: 45
  ).add_text("stop_source: false")
  text( class: make_id("t1"),
    x: 90, y: 65
  ).add_text("pending: 3")
  text(
    class: make_id("t1"),
    x: 490, y: 65
  ).add_text("child chain 1")
  text( class: make_id("t1"),
    x: 490, y: 165
  ).add_text("child chain 2")
  text( class: make_id("t1"),
    x: 490, y: 265
  ).add_text("child chain 3")
end

# puts(image.render)

save_to_file("_includes/assets/2025-11-18-cancellation-propagation", "03-wait_any-start.svg", image.render)

$crt_id += 1

image = svg({
  id: make_id("box"),
  width: "100%",
  viewBox: "0 0 800 320",
  }) do

  style().add_text(<<-CSS)
    ##{make_id("box")} {
      border: 1px solid #e8e8e8;
      background-color: #f5f5f5;
    }
    .#{make_id("t1")} {
      font-family: sans-serif;
      font-size: 16px;
      text-anchor: left;
      dominant-baseline: middle;
    }
    .#{make_id("t2")} {
      font-family: sans-serif;
      font-size: 16px;
      text-anchor: left;
      dominant-baseline: middle;
      fill: #{color_red};
    }
    .#{make_id("l0")} {
      stroke: #{color_orange};
      stroke-width: 3;
      fill: none;
    }
    .#{make_id("arrow0")} {
      stroke: #{color_orange};
      stroke-width: 1;
      fill: #{color_orange};
    }
    .#{make_id("l1")} {
      stroke: #{color_blue};
      stroke-width: 3;
      fill: none;
    }
    .#{make_id("arrow1")} {
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
    .#{make_id("box_white")} {
      stroke: #000000;
      stroke-width: 2;
      fill: #{color_white};
    }
  CSS

  defs() do
    marker(
      id: make_id("arrow0"),
      viewBox: "0, 0, 10, 10",
      refX: 5, refY: 5,
      markerWidth: 6, markerHeight: 6,
      orient: "auto-start-reverse",
    ) do
      path(
        d: "M 0 0 L 10 5 L 0 10 L 2.5 5 Z",
        class: make_id("arrow0")
      )
    end
    marker(
      id: make_id("arrow1"),
      viewBox: "0, 0, 10, 10",
      refX: 5, refY: 5,
      markerWidth: 6, markerHeight: 6,
      orient: "auto-start-reverse",
    ) do
      path(
        d: "M 0 0 L 10 5 L 0 10 L 2.5 5 Z",
        class: make_id("arrow1")
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

  rect(x: -20, y: 152, width: 60, height: 30, class: make_id("box_white"))

  rect(x: 70, y: 5, width: 180, height: 310, class: make_id("box_white"))
  path(
    class: make_id("l0"),
    d: "M 10 158 c 20 -70 70 -40 70 -18",
    marker_end: "url(##{make_id("arrow0")})"
  )

  rect(x: 270, y: 52, width: 60, height: 30, class: make_id("box_white"))
  path(
    class: make_id("l1"),
    d: "M 230 58 c 20 -70 70 -40 70 -18",
    marker_end: "url(##{make_id("arrow1")})"
  )
  rect(x: 340, y: 52, width: 60, height: 30, class: make_id("box_white"))
  path(
    class: make_id("l1"),
    d: "M 300 58 c 20 -70 70 -40 70 -18",
    marker_end: "url(##{make_id("arrow1")})"
  )
  rect(x: 410, y: 52, width: 60, height: 30, class: make_id("box_white"))
  path(
    class: make_id("l1"),
    d: "M 370 58 c 20 -70 70 -40 70 -18",
    marker_end: "url(##{make_id("arrow1")})"
  )


  rect(x: 270, y: 152, width: 60, height: 30, class: make_id("box_white"))
  path(
    class: make_id("l2"),
    d: "M 300 183 c -5 30 -40 30 -66 -16",
    marker_end: "url(##{make_id("arrow2")})"
  )


  rect(x: 270, y: 252, width: 60, height: 30, class: make_id("box_white"))
  path(
    class: make_id("l3"),
    d: "M 230 258 c 20 -70 70 -40 70 -18",
    marker_end: "url(##{make_id("arrow3")})"
  )
  rect(x: 340, y: 252, width: 60, height: 30, class: make_id("box_white"))
  path(
    class: make_id("l3"),
    d: "M 300 258 c 20 -70 70 -40 70 -18",
    marker_end: "url(##{make_id("arrow3")})"
  )
  rect(x: 410, y: 252, width: 60, height: 30, class: make_id("box_white"))
  path(
    class: make_id("l3"),
    d: "M 370 258 c 20 -70 70 -40 70 -18",
    marker_end: "url(##{make_id("arrow3")})"
  )

  circle(cx: 220, cy: 146, r: 7, class: make_id("l2"))

  text(
    class: make_id("t1"),
    x: 10, y: 85
  ).add_text("parent")
  text(
    class: make_id("t1"),
    x: 10, y: 105
  ).add_text("chain")

  text( class: make_id("t1"),
    x: 80, y: 25
  ).add_text("wait_any")
  text( class: make_id("t2"),
    x: 90, y: 45
  ).add_text("stop_source: true")
  text( class: make_id("t1"),
    x: 90, y: 65
  ).add_text("pending: 2")
  text(
    class: make_id("t1"),
    x: 490, y: 65
  ).add_text("child chain 1")
  text( class: make_id("t1"),
    x: 490, y: 165
  ).add_text("child chain 2")
  text( class: make_id("t1"),
    x: 490, y: 265
  ).add_text("child chain 3")
end

# puts(image.render)

save_to_file("_includes/assets/2025-11-18-cancellation-propagation", "04-wait_any-first-completes.svg", image.render)

$crt_id += 1

image = svg({
  id: make_id("box"),
  width: "100%",
  viewBox: "0 0 800 320",
  }) do

  style().add_text(<<-CSS)
    ##{make_id("box")} {
      border: 1px solid #e8e8e8;
      background-color: #f5f5f5;
    }
    .#{make_id("t1")} {
      font-family: sans-serif;
      font-size: 16px;
      text-anchor: left;
      dominant-baseline: middle;
    }
    .#{make_id("t2")} {
      font-family: sans-serif;
      font-size: 16px;
      text-anchor: left;
      dominant-baseline: middle;
      fill: #{color_red};
    }
    .#{make_id("l0")} {
      stroke: #{color_orange};
      stroke-width: 3;
      fill: none;
    }
    .#{make_id("arrow0")} {
      stroke: #{color_orange};
      stroke-width: 1;
      fill: #{color_orange};
    }
    .#{make_id("l1")} {
      stroke: #{color_blue};
      stroke-width: 3;
      fill: none;
    }
    .#{make_id("arrow1")} {
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
      id: make_id("arrow0"),
      viewBox: "0, 0, 10, 10",
      refX: 5, refY: 5,
      markerWidth: 6, markerHeight: 6,
      orient: "auto-start-reverse",
    ) do
      path(
        d: "M 0 0 L 10 5 L 0 10 L 2.5 5 Z",
        class: make_id("arrow0")
      )
    end
    marker(
      id: make_id("arrow1"),
      viewBox: "0, 0, 10, 10",
      refX: 5, refY: 5,
      markerWidth: 6, markerHeight: 6,
      orient: "auto-start-reverse",
    ) do
      path(
        d: "M 0 0 L 10 5 L 0 10 L 2.5 5 Z",
        class: make_id("arrow1")
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

  rect(x: -20, y: 152, width: 60, height: 30, class: make_id("box_white"))

  rect(x: 70, y: 5, width: 180, height: 310, class: make_id("box_white"))
  path(
    class: make_id("l0"),
    d: "M 10 158 c 20 -70 70 -40 70 -18",
    marker_end: "url(##{make_id("arrow0")})"
  )
  line(
    class: make_id("l4"),
    x1: 210, y1: 65, x2: 220, y2: 55
  )
  line(
    class: make_id("l4"),
    x1: 210, y1: 55, x2: 220, y2: 65
  )

  rect(x: 270, y: 52, width: 60, height: 30, class: make_id("box_white"))
  path(
    class: make_id("l1"),
    d: "M 300 83 c -5 30 -40 30 -66 -16",
    marker_end: "url(##{make_id("arrow1")})"
  )

  rect(x: 270, y: 252, width: 60, height: 30, class: make_id("box_white"))
  path(
    class: make_id("l3"),
    d: "M 230 258 c 20 -70 70 -40 70 -18",
    marker_end: "url(##{make_id("arrow3")})"
  )
  rect(x: 340, y: 252, width: 60, height: 30, class: make_id("box_white"))
  path(
    class: make_id("l3"),
    d: "M 300 258 c 20 -70 70 -40 70 -18",
    marker_end: "url(##{make_id("arrow3")})"
  )
  rect(x: 410, y: 252, width: 60, height: 30, class: make_id("box_white"))
  path(
    class: make_id("l3"),
    d: "M 370 258 c 20 -70 70 -40 70 -18",
    marker_end: "url(##{make_id("arrow3")})"
  )

  circle(cx: 220, cy: 146, r: 7, class: make_id("l2"))

  text(
    class: make_id("t1"),
    x: 10, y: 85
  ).add_text("parent")
  text(
    class: make_id("t1"),
    x: 10, y: 105
  ).add_text("chain")

  text( class: make_id("t1"),
    x: 80, y: 25
  ).add_text("wait_any")
  text( class: make_id("t2"),
    x: 90, y: 45
  ).add_text("stop_source: true")
  text( class: make_id("t1"),
    x: 90, y: 65
  ).add_text("pending: 1")
  text(
    class: make_id("t1"),
    x: 490, y: 65
  ).add_text("child chain 1")
  text( class: make_id("t1"),
    x: 490, y: 265
  ).add_text("child chain 3")
end

# puts(image.render)

save_to_file("_includes/assets/2025-11-18-cancellation-propagation", "05-wait_any-second-completes.svg", image.render)

$crt_id += 1

image = svg({
  id: make_id("box"),
  width: "100%",
  viewBox: "0 0 800 320",
  }) do

  style().add_text(<<-CSS)
    ##{make_id("box")} {
      border: 1px solid #e8e8e8;
      background-color: #f5f5f5;
    }
    .#{make_id("t1")} {
      font-family: sans-serif;
      font-size: 16px;
      text-anchor: left;
      dominant-baseline: middle;
    }
    .#{make_id("t2")} {
      font-family: sans-serif;
      font-size: 16px;
      text-anchor: left;
      dominant-baseline: middle;
      fill: #{color_red};
    }
    .#{make_id("l0")} {
      stroke: #{color_orange};
      stroke-width: 3;
      fill: none;
    }
    .#{make_id("arrow0")} {
      stroke: #{color_orange};
      stroke-width: 1;
      fill: #{color_orange};
    }
    .#{make_id("l1")} {
      stroke: #{color_blue};
      stroke-width: 3;
      fill: none;
    }
    .#{make_id("arrow1")} {
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
      id: make_id("arrow0"),
      viewBox: "0, 0, 10, 10",
      refX: 5, refY: 5,
      markerWidth: 6, markerHeight: 6,
      orient: "auto-start-reverse",
    ) do
      path(
        d: "M 0 0 L 10 5 L 0 10 L 2.5 5 Z",
        class: make_id("arrow0")
      )
    end
    marker(
      id: make_id("arrow1"),
      viewBox: "0, 0, 10, 10",
      refX: 5, refY: 5,
      markerWidth: 6, markerHeight: 6,
      orient: "auto-start-reverse",
    ) do
      path(
        d: "M 0 0 L 10 5 L 0 10 L 2.5 5 Z",
        class: make_id("arrow1")
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

  rect(x: -20, y: 152, width: 60, height: 30, class: make_id("box_white"))

  rect(x: 70, y: 5, width: 180, height: 310, class: make_id("box_white"))
  path(
    class: make_id("l0"),
    d: "M 100 183 c -5 30 -40 30 -66 -16",
    marker_end: "url(##{make_id("arrow0")})"
  )

  rect(x: 270, y: 252, width: 60, height: 30, class: make_id("box_white"))
  path(
    class: make_id("l3"),
    d: "M 300 283 q -100 40 -190 -90",
    marker_end: "url(##{make_id("arrow3")})"
  )

  line(
    class: make_id("l4"),
    x1: 100, y1: 175, x2: 110, y2: 165
  )
  line(
    class: make_id("l4"),
    x1: 100, y1: 165, x2: 110, y2: 175
  )

  circle(cx: 20, cy: 165, r: 6, class: make_id("l2"))

  text(
    class: make_id("t1"),
    x: 10, y: 85
  ).add_text("parent")
  text(
    class: make_id("t1"),
    x: 10, y: 105
  ).add_text("chain")

  text( class: make_id("t1"),
    x: 80, y: 25
  ).add_text("wait_any")
  text( class: make_id("t2"),
    x: 90, y: 45
  ).add_text("stop_source: true")
  text( class: make_id("t2"),
    x: 90, y: 65
  ).add_text("pending: 0")
  text( class: make_id("t1"),
    x: 490, y: 265
  ).add_text("child chain 3")
end

# puts(image.render)

save_to_file("_includes/assets/2025-11-18-cancellation-propagation", "06-wait_any-last-completes.svg", image.render)

$crt_id += 1

image = svg({
  id: make_id("box"),
  width: "100%",
  viewBox: "0 0 800 88",
  }) do

  style().add_text(<<-CSS)
    ##{make_id("box")} {
      border: 1px solid #e8e8e8;
      background-color: #f5f5f5;
    }
    .#{make_id("t1")} {
      font-family: sans-serif;
      font-size: 16px;
      text-anchor: left;
      dominant-baseline: middle;
    }
    .#{make_id("l1")} {
      stroke: #{color_blue};
      stroke-width: 3;
      fill: none;
    }
    .#{make_id("arrow1")} {
      stroke: #{color_blue};
      stroke-width: 1;
      fill: #{color_blue};
    }
    .#{make_id("box_white")} {
      stroke: #000000;
      stroke-width: 2;
      fill: #{color_white};
    }
  CSS

  defs() do
    marker(
      id: make_id("arrow1"),
      viewBox: "0, 0, 10, 10",
      refX: 5, refY: 5,
      markerWidth: 6, markerHeight: 6,
      orient: "auto-start-reverse",
    ) do
      path(
        d: "M 0 0 L 10 5 L 0 10 L 2.5 5 Z",
        class: make_id("arrow1")
      )
    end
  end

  rect(x: 10, y: 5, width: 180, height: 78, class: make_id("box_white"))

  rect(x: 210, y: 52, width: 60, height: 30, class: make_id("box_white"))
  path(
    class: make_id("l1"),
    d: "M 170 58 c 20 -70 70 -40 70 -18",
    marker_end: "url(##{make_id("arrow1")})"
  )
  rect(x: 280, y: 52, width: 60, height: 30, class: make_id("box_white"))
  path(
    class: make_id("l1"),
    d: "M 240 58 c 20 -70 70 -40 70 -18",
    marker_end: "url(##{make_id("arrow1")})"
  )
  rect(x: 350, y: 52, width: 60, height: 30, class: make_id("box_white"))
  path(
    class: make_id("l1"),
    d: "M 310 58 c 20 -70 70 -40 70 -18",
    marker_end: "url(##{make_id("arrow1")})"
  )
  rect(x: 420, y: 52, width: 60, height: 30, class: make_id("box_white"))
  path(
    class: make_id("l1"),
    d: "M 380 58 c 20 -70 70 -40 70 -18",
    marker_end: "url(##{make_id("arrow1")})"
  )

  text( class: make_id("t1"),
    x: 20, y: 25
  ).add_text("run")
  text( class: make_id("t1"),
    x: 30, y: 45
  ).add_text("stop_source: false")
  text( class: make_id("t1"),
    x: 30, y: 65
  ).add_text("done: false")
end

# puts(image.render)

save_to_file("_includes/assets/2025-11-18-cancellation-propagation", "07-from-root.svg", image.render)

$crt_id += 1

image = svg({
  id: make_id("box"),
  width: "100%",
  viewBox: "0 0 800 88",
  }) do

  style().add_text(<<-CSS)
    ##{make_id("box")} {
      border: 1px solid #e8e8e8;
      background-color: #f5f5f5;
    }
    .#{make_id("t1")} {
      font-family: sans-serif;
      font-size: 16px;
      text-anchor: left;
      dominant-baseline: middle;
    }
    .#{make_id("t2")} {
      font-family: sans-serif;
      font-size: 16px;
      text-anchor: left;
      dominant-baseline: middle;
      fill: #{color_red};
    }
    .#{make_id("l1")} {
      stroke: #{color_blue};
      stroke-width: 3;
      fill: none;
    }
    .#{make_id("arrow1")} {
      stroke: #{color_blue};
      stroke-width: 1;
      fill: #{color_blue};
    }
    .#{make_id("box_white")} {
      stroke: #000000;
      stroke-width: 2;
      fill: #{color_white};
    }
  CSS

  defs() do
    marker(
      id: make_id("arrow1"),
      viewBox: "0, 0, 10, 10",
      refX: 5, refY: 5,
      markerWidth: 6, markerHeight: 6,
      orient: "auto-start-reverse",
    ) do
      path(
        d: "M 0 0 L 10 5 L 0 10 L 2.5 5 Z",
        class: make_id("arrow1")
      )
    end
  end

  rect(x: 10, y: 5, width: 180, height: 78, class: make_id("box_white"))

  rect(x: 210, y: 52, width: 60, height: 30, class: make_id("box_white"))
  path(
    class: make_id("l1"),
    d: "M 170 58 c 20 -70 70 -40 70 -18",
    marker_end: "url(##{make_id("arrow1")})"
  )
  rect(x: 280, y: 52, width: 60, height: 30, class: make_id("box_white"))
  path(
    class: make_id("l1"),
    d: "M 240 58 c 20 -70 70 -40 70 -18",
    marker_end: "url(##{make_id("arrow1")})"
  )
  rect(x: 350, y: 52, width: 60, height: 30, class: make_id("box_white"))
  path(
    class: make_id("l1"),
    d: "M 310 58 c 20 -70 70 -40 70 -18",
    marker_end: "url(##{make_id("arrow1")})"
  )
  rect(x: 420, y: 52, width: 60, height: 30, class: make_id("box_white"))
  path(
    class: make_id("l1"),
    d: "M 380 58 c 20 -70 70 -40 70 -18",
    marker_end: "url(##{make_id("arrow1")})"
  )

  text( class: make_id("t1"),
    x: 20, y: 25
  ).add_text("run")
  text( class: make_id("t2"),
    x: 30, y: 45
  ).add_text("stop_source: true")
  text( class: make_id("t1"),
    x: 30, y: 65
  ).add_text("done: false")
end

# puts(image.render)

save_to_file("_includes/assets/2025-11-18-cancellation-propagation", "08-from-root-stopped.svg", image.render)

$crt_id += 1

image = svg({
  id: make_id("box"),
  width: "100%",
  viewBox: "0 0 800 110",
  }) do

  style().add_text(<<-CSS)
    ##{make_id("box")} {
      border: 1px solid #e8e8e8;
      background-color: #f5f5f5;
    }
    .#{make_id("t1")} {
      font-family: sans-serif;
      font-size: 16px;
      text-anchor: left;
      dominant-baseline: middle;
    }
    .#{make_id("t2")} {
      font-family: sans-serif;
      font-size: 16px;
      text-anchor: left;
      dominant-baseline: middle;
      fill: #{color_red};
    }
    .#{make_id("l1")} {
      stroke: #{color_blue};
      stroke-width: 3;
      fill: none;
    }
    .#{make_id("arrow1")} {
      stroke: #{color_blue};
      stroke-width: 1;
      fill: #{color_blue};
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
      id: make_id("arrow1"),
      viewBox: "0, 0, 10, 10",
      refX: 5, refY: 5,
      markerWidth: 6, markerHeight: 6,
      orient: "auto-start-reverse",
    ) do
      path(
        d: "M 0 0 L 10 5 L 0 10 L 2.5 5 Z",
        class: make_id("arrow1")
      )
    end
  end

  rect(x: 10, y: 5, width: 180, height: 78, class: make_id("box_white"))

  rect(x: 210, y: 52, width: 60, height: 30, class: make_id("box_white"))
  path(
    class: make_id("l1"),
    d: "M 170 58 c 20 -70 70 -40 70 -18",
    marker_end: "url(##{make_id("arrow1")})"
  )
  rect(x: 280, y: 52, width: 60, height: 30, class: make_id("box_white"))
  path(
    class: make_id("l1"),
    d: "M 240 58 c 20 -70 70 -40 70 -18",
    marker_end: "url(##{make_id("arrow1")})"
  )
  rect(x: 350, y: 52, width: 60, height: 30, class: make_id("box_white"))
  path(
    class: make_id("l1"),
    d: "M 310 58 c 20 -70 70 -40 70 -18",
    marker_end: "url(##{make_id("arrow1")})"
  )
  rect(x: 420, y: 52, width: 60, height: 30, class: make_id("box_white"))
  path(
    class: make_id("l1"),
    d: "M 450 83 c -5 30 -40 30 -66 -16",
    marker_end: "url(##{make_id("arrow1")})"
  )

  line(
    class: make_id("l4"),
    x1: 365, y1: 65, x2: 375, y2: 55
  )
  line(
    class: make_id("l4"),
    x1: 365, y1: 55, x2: 375, y2: 65
  )

  text( class: make_id("t1"),
    x: 20, y: 25
  ).add_text("run")
  text( class: make_id("t2"),
    x: 30, y: 45
  ).add_text("stop_source: true")
  text( class: make_id("t1"),
    x: 30, y: 65
  ).add_text("done: false")
end

# puts(image.render)

save_to_file("_includes/assets/2025-11-18-cancellation-propagation", "09-from-root-downhill.svg", image.render)

$crt_id += 1

image = svg({
  id: make_id("box"),
  width: "100%",
  viewBox: "0 0 800 110",
  }) do

  style().add_text(<<-CSS)
    ##{make_id("box")} {
      border: 1px solid #e8e8e8;
      background-color: #f5f5f5;
    }
    .#{make_id("t1")} {
      font-family: sans-serif;
      font-size: 16px;
      text-anchor: left;
      dominant-baseline: middle;
    }
    .#{make_id("t2")} {
      font-family: sans-serif;
      font-size: 16px;
      text-anchor: left;
      dominant-baseline: middle;
      fill: #{color_red};
    }
    .#{make_id("l1")} {
      stroke: #{color_blue};
      stroke-width: 3;
      fill: none;
    }
    .#{make_id("arrow1")} {
      stroke: #{color_blue};
      stroke-width: 1;
      fill: #{color_blue};
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
      id: make_id("arrow1"),
      viewBox: "0, 0, 10, 10",
      refX: 5, refY: 5,
      markerWidth: 6, markerHeight: 6,
      orient: "auto-start-reverse",
    ) do
      path(
        d: "M 0 0 L 10 5 L 0 10 L 2.5 5 Z",
        class: make_id("arrow1")
      )
    end
  end

  rect(x: 10, y: 5, width: 180, height: 78, class: make_id("box_white"))

  rect(x: 210, y: 52, width: 60, height: 30, class: make_id("box_white"))
  path(
    class: make_id("l1"),
    d: "M 170 58 c 20 -70 70 -40 70 -18",
    marker_end: "url(##{make_id("arrow1")})"
  )
  rect(x: 280, y: 52, width: 60, height: 30, class: make_id("box_white"))
  path(
    class: make_id("l1"),
    d: "M 240 58 c 20 -70 70 -40 70 -18",
    marker_end: "url(##{make_id("arrow1")})"
  )
  rect(x: 350, y: 52, width: 60, height: 30, class: make_id("box_white"))
  path(
    class: make_id("l1"),
    d: "M 380 83 c -5 30 -40 30 -66 -16",
    marker_end: "url(##{make_id("arrow1")})"
  )

  line(
    class: make_id("l4"),
    x1: 295, y1: 65, x2: 305, y2: 55
  )
  line(
    class: make_id("l4"),
    x1: 295, y1: 55, x2: 305, y2: 65
  )

  text( class: make_id("t1"),
    x: 20, y: 25
  ).add_text("run")
  text( class: make_id("t2"),
    x: 30, y: 45
  ).add_text("stop_source: true")
  text( class: make_id("t1"),
    x: 30, y: 65
  ).add_text("done: false")
end

# puts(image.render)

save_to_file("_includes/assets/2025-11-18-cancellation-propagation", "10-from-root-downhill2.svg", image.render)

$crt_id += 1

image = svg({
  id: make_id("box"),
  width: "100%",
  viewBox: "0 0 800 110",
  }) do

  style().add_text(<<-CSS)
    ##{make_id("box")} {
      border: 1px solid #e8e8e8;
      background-color: #f5f5f5;
    }
    .#{make_id("t1")} {
      font-family: sans-serif;
      font-size: 16px;
      text-anchor: left;
      dominant-baseline: middle;
    }
    .#{make_id("t2")} {
      font-family: sans-serif;
      font-size: 16px;
      text-anchor: left;
      dominant-baseline: middle;
      fill: #{color_red};
    }
    .#{make_id("l0")} {
      stroke: #000000;
      stroke-width: 3;
      fill: none;
    }
    .#{make_id("arrow0")} {
      stroke: #000000;
      stroke-width: 1;
      fill: #000000;
    }
    .#{make_id("l1")} {
      stroke: #{color_blue};
      stroke-width: 3;
      fill: none;
    }
    .#{make_id("arrow1")} {
      stroke: #{color_blue};
      stroke-width: 1;
      fill: #{color_blue};
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
      id: make_id("arrow0"),
      viewBox: "0, 0, 10, 10",
      refX: 5, refY: 5,
      markerWidth: 6, markerHeight: 6,
      orient: "auto-start-reverse",
    ) do
      path(
        d: "M 0 0 L 10 5 L 0 10 L 2.5 5 Z",
        class: make_id("arrow0")
      )
    end
    marker(
      id: make_id("arrow1"),
      viewBox: "0, 0, 10, 10",
      refX: 5, refY: 5,
      markerWidth: 6, markerHeight: 6,
      orient: "auto-start-reverse",
    ) do
      path(
        d: "M 0 0 L 10 5 L 0 10 L 2.5 5 Z",
        class: make_id("arrow1")
      )
    end
  end

  rect(x: 10, y: 5, width: 180, height: 78, class: make_id("box_white"))
  line(x1: 100, y1: 83, x2: 100, y2: 98, class: make_id("l0"),
    marker_end: "url(##{make_id("arrow0")})")

  rect(x: 210, y: 52, width: 60, height: 30, class: make_id("box_white"))
  path(
    class: make_id("l1"),
    d: "M 240 83 c -5 30 -40 30 -66 -16",
    marker_end: "url(##{make_id("arrow1")})"
  )

  line(
    class: make_id("l4"),
    x1: 155, y1: 65, x2: 165, y2: 55
  )
  line(
    class: make_id("l4"),
    x1: 155, y1: 55, x2: 165, y2: 65
  )

  text( class: make_id("t1"),
    x: 20, y: 25
  ).add_text("run")
  text( class: make_id("t2"),
    x: 30, y: 45
  ).add_text("stop_source: true")
  text( class: make_id("t2"),
    x: 30, y: 65
  ).add_text("done: true")
end

# puts(image.render)

save_to_file("_includes/assets/2025-11-18-cancellation-propagation", "11-from-root-completed.svg", image.render)

$crt_id += 1

image = svg({
  id: make_id("box"),
  width: "100%",
  viewBox: "0 0 800 88",
  }) do

  style().add_text(<<-CSS)
    ##{make_id("box")} {
      border: 1px solid #e8e8e8;
      background-color: #f5f5f5;
    }
    .#{make_id("t1")} {
      font-family: sans-serif;
      font-size: 16px;
      text-anchor: left;
      dominant-baseline: middle;
    }
    .#{make_id("t2")} {
      font-family: sans-serif;
      font-size: 16px;
      text-anchor: left;
      dominant-baseline: middle;
      fill: #{color_red};
    }
    .#{make_id("l1")} {
      stroke: #{color_blue};
      stroke-width: 3;
      fill: none;
    }
    .#{make_id("arrow1")} {
      stroke: #{color_blue};
      stroke-width: 1;
      fill: #{color_blue};
    }
    .#{make_id("l2")} {
      stroke: #{color_purple};
      stroke-width: 3;
      fill: none;
    }
    .#{make_id("arrow2")} {
      stroke: #{color_purple};
      stroke-width: 1;
      fill: #{color_purple};
    }
    .#{make_id("box_white")} {
      stroke: #000000;
      stroke-width: 2;
      fill: #{color_white};
    }
    .#{make_id("box_orange")} {
      stroke: #000000;
      stroke-width: 2;
      fill: #{color_orange};
    }
  CSS

  defs() do
    marker(
      id: make_id("arrow1"),
      viewBox: "0, 0, 10, 10",
      refX: 5, refY: 5,
      markerWidth: 6, markerHeight: 6,
      orient: "auto-start-reverse",
    ) do
      path(
        d: "M 0 0 L 10 5 L 0 10 L 2.5 5 Z",
        class: make_id("arrow1")
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
  end

  rect(x: 10, y: 5, width: 180, height: 78, class: make_id("box_white"))

  rect(x: 210, y: 52, width: 60, height: 30, class: make_id("box_white"))
  path(
    class: make_id("l1"),
    d: "M 170 58 c 20 -70 70 -40 70 -18",
    marker_end: "url(##{make_id("arrow1")})"
  )
  rect(x: 280, y: 52, width: 60, height: 30, class: make_id("box_orange"))
  path(
    class: make_id("l1"),
    d: "M 240 58 c 20 -70 70 -40 70 -18",
    marker_end: "url(##{make_id("arrow1")})"
  )
  rect(x: 350, y: 52, width: 60, height: 30, class: make_id("box_orange"))
  path(
    class: make_id("l2"),
    d: "M 310 58 c 20 -70 70 -40 70 -18",
    marker_end: "url(##{make_id("arrow2")})"
  )
  rect(x: 420, y: 52, width: 60, height: 30, class: make_id("box_white"))
  path(
    class: make_id("l2"),
    d: "M 380 58 c 20 -70 70 -40 70 -18",
    marker_end: "url(##{make_id("arrow2")})"
  )
  rect(x: 490, y: 52, width: 60, height: 30, class: make_id("box_white"))
  path(
    class: make_id("l1"),
    d: "M 450 58 c 20 -70 70 -40 70 -18",
    marker_end: "url(##{make_id("arrow1")})"
  )

  text( class: make_id("t1"),
    x: 20, y: 25
  ).add_text("run")
  text( class: make_id("t1"),
    x: 30, y: 45
  ).add_text("stop_source: false")
  text( class: make_id("t1"),
    x: 30, y: 65
  ).add_text("done: false")
end

# puts(image.render)

save_to_file("_includes/assets/2025-11-18-cancellation-propagation", "12-coroutine-downhill.svg", image.render)

$crt_id += 1

image = svg({
  id: make_id("box"),
  width: "100%",
  viewBox: "0 0 800 110",
  }) do

  style().add_text(<<-CSS)
    ##{make_id("box")} {
      border: 1px solid #e8e8e8;
      background-color: #f5f5f5;
    }
    .#{make_id("t1")} {
      font-family: sans-serif;
      font-size: 16px;
      text-anchor: left;
      dominant-baseline: middle;
    }
    .#{make_id("t2")} {
      font-family: sans-serif;
      font-size: 16px;
      text-anchor: left;
      dominant-baseline: middle;
      fill: #{color_red};
    }
    .#{make_id("l1")} {
      stroke: #{color_blue};
      stroke-width: 3;
      fill: none;
    }
    .#{make_id("arrow1")} {
      stroke: #{color_blue};
      stroke-width: 1;
      fill: #{color_blue};
    }
    .#{make_id("l2")} {
      stroke: #{color_purple};
      stroke-width: 3;
      fill: none;
    }
    .#{make_id("arrow2")} {
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
    .#{make_id("box_orange")} {
      stroke: #000000;
      stroke-width: 2;
      fill: #{color_orange};
    }
  CSS

  defs() do
    marker(
      id: make_id("arrow1"),
      viewBox: "0, 0, 10, 10",
      refX: 5, refY: 5,
      markerWidth: 6, markerHeight: 6,
      orient: "auto-start-reverse",
    ) do
      path(
        d: "M 0 0 L 10 5 L 0 10 L 2.5 5 Z",
        class: make_id("arrow1")
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
  end

  rect(x: 10, y: 5, width: 180, height: 78, class: make_id("box_white"))

  rect(x: 210, y: 52, width: 60, height: 30, class: make_id("box_white"))
  path(
    class: make_id("l1"),
    d: "M 170 58 c 20 -70 70 -40 70 -18",
    marker_end: "url(##{make_id("arrow1")})"
  )
  rect(x: 280, y: 52, width: 60, height: 30, class: make_id("box_orange"))
  path(
    class: make_id("l1"),
    d: "M 240 58 c 20 -70 70 -40 70 -18",
    marker_end: "url(##{make_id("arrow1")})"
  )
  rect(x: 350, y: 52, width: 60, height: 30, class: make_id("box_orange"))
  path(
    class: make_id("l2"),
    d: "M 310 58 c 20 -70 70 -40 70 -18",
    marker_end: "url(##{make_id("arrow2")})"
  )
  rect(x: 420, y: 52, width: 60, height: 30, class: make_id("box_white"))
  path(
    class: make_id("l2"),
    d: "M 380 58 c 20 -70 70 -40 70 -18",
    marker_end: "url(##{make_id("arrow2")})"
  )
  rect(x: 490, y: 52, width: 60, height: 30, class: make_id("box_white"))
  path(
    class: make_id("l1"),
    d: "M 520 83 c -5 30 -40 30 -66 -16",
    marker_end: "url(##{make_id("arrow1")})"
  )

  line(
    class: make_id("l4"),
    x1: 435, y1: 65, x2: 445, y2: 55
  )
  line(
    class: make_id("l4"),
    x1: 435, y1: 55, x2: 445, y2: 65
  )

  text( class: make_id("t1"),
    x: 20, y: 25
  ).add_text("run")
  text( class: make_id("t2"),
    x: 30, y: 45
  ).add_text("stop_source: true")
  text( class: make_id("t1"),
    x: 30, y: 65
  ).add_text("done: false")
end

# puts(image.render)

save_to_file("_includes/assets/2025-11-18-cancellation-propagation", "13-coroutine-downhill2.svg", image.render)

$crt_id += 1

image = svg({
  id: make_id("box"),
  width: "100%",
  viewBox: "0 0 800 110",
  }) do

  style().add_text(<<-CSS)
    ##{make_id("box")} {
      border: 1px solid #e8e8e8;
      background-color: #f5f5f5;
    }
    .#{make_id("t1")} {
      font-family: sans-serif;
      font-size: 16px;
      text-anchor: left;
      dominant-baseline: middle;
    }
    .#{make_id("t2")} {
      font-family: sans-serif;
      font-size: 16px;
      text-anchor: left;
      dominant-baseline: middle;
      fill: #{color_red};
    }
    .#{make_id("l1")} {
      stroke: #{color_blue};
      stroke-width: 3;
      fill: none;
    }
    .#{make_id("arrow1")} {
      stroke: #{color_blue};
      stroke-width: 1;
      fill: #{color_blue};
    }
    .#{make_id("l2")} {
      stroke: #{color_purple};
      stroke-width: 3;
      fill: none;
    }
    .#{make_id("arrow2")} {
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
    .#{make_id("box_orange")} {
      stroke: #000000;
      stroke-width: 2;
      fill: #{color_orange};
    }
  CSS

  defs() do
    marker(
      id: make_id("arrow1"),
      viewBox: "0, 0, 10, 10",
      refX: 5, refY: 5,
      markerWidth: 6, markerHeight: 6,
      orient: "auto-start-reverse",
    ) do
      path(
        d: "M 0 0 L 10 5 L 0 10 L 2.5 5 Z",
        class: make_id("arrow1")
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
  end

  rect(x: 10, y: 5, width: 180, height: 78, class: make_id("box_white"))

  rect(x: 210, y: 52, width: 60, height: 30, class: make_id("box_white"))
  path(
    class: make_id("l1"),
    d: "M 170 58 c 20 -70 70 -40 70 -18",
    marker_end: "url(##{make_id("arrow1")})"
  )
  rect(x: 280, y: 52, width: 60, height: 30, class: make_id("box_orange"))
  path(
    class: make_id("l1"),
    d: "M 240 58 c 20 -70 70 -40 70 -18",
    marker_end: "url(##{make_id("arrow1")})"
  )
  rect(x: 350, y: 52, width: 60, height: 30, class: make_id("box_orange"))
  path(
    class: make_id("l2"),
    d: "M 310 58 c 20 -70 70 -40 70 -18",
    marker_end: "url(##{make_id("arrow2")})"
  )
  rect(x: 420, y: 52, width: 60, height: 30, class: make_id("box_white"))
  path(
    class: make_id("l1"),
    d: "M 450 83 c -5 30 -200 30 -206 -16",
    marker_end: "url(##{make_id("arrow1")})"
  )

  line(
    class: make_id("l4"),
    x1: 225, y1: 65, x2: 235, y2: 55
  )
  line(
    class: make_id("l4"),
    x1: 225, y1: 55, x2: 235, y2: 65
  )

  text( class: make_id("t1"),
    x: 20, y: 25
  ).add_text("run")
  text( class: make_id("t2"),
    x: 30, y: 45
  ).add_text("stop_source: true")
  text( class: make_id("t1"),
    x: 30, y: 65
  ).add_text("done: false")
end

# puts(image.render)

save_to_file("_includes/assets/2025-11-18-cancellation-propagation", "14-coroutine-downhill3.svg", image.render)

$crt_id += 1

image = svg({
  id: make_id("box"),
  width: "100%",
  viewBox: "0 0 800 110",
  }) do

  style().add_text(<<-CSS)
    ##{make_id("box")} {
      border: 1px solid #e8e8e8;
      background-color: #f5f5f5;
    }
    .#{make_id("t1")} {
      font-family: sans-serif;
      font-size: 16px;
      text-anchor: left;
      dominant-baseline: middle;
    }
    .#{make_id("t2")} {
      font-family: sans-serif;
      font-size: 16px;
      text-anchor: left;
      dominant-baseline: middle;
      fill: #{color_red};
    }
    .#{make_id("l1")} {
      stroke: #{color_blue};
      stroke-width: 3;
      fill: none;
    }
    .#{make_id("arrow1")} {
      stroke: #{color_blue};
      stroke-width: 1;
      fill: #{color_blue};
    }
    .#{make_id("l2")} {
      stroke: #{color_purple};
      stroke-width: 3;
      fill: none;
    }
    .#{make_id("arrow2")} {
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
    .#{make_id("box_orange")} {
      stroke: #000000;
      stroke-width: 2;
      fill: #{color_orange};
    }
  CSS

  defs() do
    marker(
      id: make_id("arrow1"),
      viewBox: "0, 0, 10, 10",
      refX: 5, refY: 5,
      markerWidth: 6, markerHeight: 6,
      orient: "auto-start-reverse",
    ) do
      path(
        d: "M 0 0 L 10 5 L 0 10 L 2.5 5 Z",
        class: make_id("arrow1")
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
  end

  rect(x: 10, y: 5, width: 180, height: 78, class: make_id("box_white"))

  rect(x: 210, y: 52, width: 60, height: 30, class: make_id("box_white"))
  path(
    class: make_id("l1"),
    d: "M 240 83 c -5 30 -40 30 -66 -16",
    marker_end: "url(##{make_id("arrow1")})"
  )

  line(
    class: make_id("l4"),
    x1: 155, y1: 65, x2: 165, y2: 55
  )
  line(
    class: make_id("l4"),
    x1: 155, y1: 55, x2: 165, y2: 65
  )

  text( class: make_id("t1"),
    x: 20, y: 25
  ).add_text("run")
  text( class: make_id("t2"),
    x: 30, y: 45
  ).add_text("stop_source: true")
  text( class: make_id("t2"),
    x: 30, y: 65
  ).add_text("done: true")
end

# puts(image.render)

save_to_file("_includes/assets/2025-11-18-cancellation-propagation", "15-coroutine-downhill4.svg", image.render)

$crt_id += 1

image = svg({
  id: make_id("box"),
  width: "100%",
  viewBox: "0 0 800 320",
  }) do

  style().add_text(<<-CSS)
    ##{make_id("box")} {
      border: 1px solid #e8e8e8;
      background-color: #f5f5f5;
    }
    .#{make_id("t1")} {
      font-family: sans-serif;
      font-size: 16px;
      text-anchor: left;
      dominant-baseline: middle;
    }
    .#{make_id("l0")} {
      stroke: #{color_orange};
      stroke-width: 3;
      fill: none;
    }
    .#{make_id("arrow0")} {
      stroke: #{color_orange};
      stroke-width: 1;
      fill: #{color_orange};
    }
    .#{make_id("l1")} {
      stroke: #{color_blue};
      stroke-width: 3;
      fill: none;
    }
    .#{make_id("arrow1")} {
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
    .#{make_id("box_white")} {
      stroke: #000000;
      stroke-width: 2;
      fill: #{color_white};
    }
  CSS

  defs() do
    marker(
      id: make_id("arrow0"),
      viewBox: "0, 0, 10, 10",
      refX: 5, refY: 5,
      markerWidth: 6, markerHeight: 6,
      orient: "auto-start-reverse",
    ) do
      path(
        d: "M 0 0 L 10 5 L 0 10 L 2.5 5 Z",
        class: make_id("arrow0")
      )
    end
    marker(
      id: make_id("arrow1"),
      viewBox: "0, 0, 10, 10",
      refX: 5, refY: 5,
      markerWidth: 6, markerHeight: 6,
      orient: "auto-start-reverse",
    ) do
      path(
        d: "M 0 0 L 10 5 L 0 10 L 2.5 5 Z",
        class: make_id("arrow1")
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

  rect(x: 10, y: 105, width: 180, height: 78, class: make_id("box_white"))

  rect(x: 210, y: 152, width: 60, height: 30, class: make_id("box_white"))
  path(
    class: make_id("l0"),
    d: "M 160 158 c 20 -70 70 -40 70 -18",
    marker_end: "url(##{make_id("arrow0")})"
  )

  text( class: make_id("t1"),
    x: 20, y: 125
  ).add_text("run")
  text( class: make_id("t1"),
    x: 30, y: 145
  ).add_text("stop_source: false")
  text( class: make_id("t1"),
    x: 30, y: 165
  ).add_text("done: false")

  rect(x: 280, y: 5, width: 180, height: 310, class: make_id("box_white"))
  path(
    class: make_id("l0"),
    d: "M 230 158 c 20 -70 70 -40 70 -18",
    marker_end: "url(##{make_id("arrow0")})"
  )

  rect(x: 480, y: 52, width: 60, height: 30, class: make_id("box_white"))
  path(
    class: make_id("l1"),
    d: "M 440 58 c 20 -70 70 -40 70 -18",
    marker_end: "url(##{make_id("arrow1")})"
  )
  rect(x: 550, y: 52, width: 60, height: 30, class: make_id("box_white"))
  path(
    class: make_id("l1"),
    d: "M 510 58 c 20 -70 70 -40 70 -18",
    marker_end: "url(##{make_id("arrow1")})"
  )
  rect(x: 620, y: 52, width: 60, height: 30, class: make_id("box_white"))
  path(
    class: make_id("l1"),
    d: "M 580 58 c 20 -70 70 -40 70 -18",
    marker_end: "url(##{make_id("arrow1")})"
  )

  rect(x: 480, y: 152, width: 60, height: 30, class: make_id("box_white"))
  path(
    class: make_id("l2"),
    d: "M 440 158 c 20 -70 70 -40 70 -18",
    marker_end: "url(##{make_id("arrow2")})"
  )
  rect(x: 550, y: 152, width: 60, height: 30, class: make_id("box_white"))
  path(
    class: make_id("l2"),
    d: "M 510 158 c 20 -70 70 -40 70 -18",
    marker_end: "url(##{make_id("arrow2")})"
  )
  rect(x: 620, y: 152, width: 60, height: 30, class: make_id("box_white"))
  path(
    class: make_id("l2"),
    d: "M 580 158 c 20 -70 70 -40 70 -18",
    marker_end: "url(##{make_id("arrow2")})"
  )

  rect(x: 480, y: 252, width: 60, height: 30, class: make_id("box_white"))
  path(
    class: make_id("l3"),
    d: "M 440 258 c 20 -70 70 -40 70 -18",
    marker_end: "url(##{make_id("arrow3")})"
  )
  rect(x: 550, y: 252, width: 60, height: 30, class: make_id("box_white"))
  path(
    class: make_id("l3"),
    d: "M 510 258 c 20 -70 70 -40 70 -18",
    marker_end: "url(##{make_id("arrow3")})"
  )
  rect(x: 620, y: 252, width: 60, height: 30, class: make_id("box_white"))
  path(
    class: make_id("l3"),
    d: "M 580 258 c 20 -70 70 -40 70 -18",
    marker_end: "url(##{make_id("arrow3")})"
  )

  text(
    class: make_id("t1"),
    x: 200, y: 85
  ).add_text("parent")
  text(
    class: make_id("t1"),
    x: 200, y: 105
  ).add_text("chain")

  text( class: make_id("t1"),
    x: 290, y: 25
  ).add_text("wait_any")
  text( class: make_id("t1"),
    x: 300, y: 45
  ).add_text("stop_source: false")
  text( class: make_id("t1"),
    x: 300, y: 65
  ).add_text("pending: 3")
  text(
    class: make_id("t1"),
    x: 690, y: 65
  ).add_text("child chain 1")
  text( class: make_id("t1"),
    x: 690, y: 165
  ).add_text("child chain 2")
  text( class: make_id("t1"),
    x: 690, y: 265
  ).add_text("child chain 3")

end

# puts(image.render)

save_to_file("_includes/assets/2025-11-18-cancellation-propagation", "16-wait_any-with_parent.svg", image.render)

$crt_id += 1

image = svg({
  id: make_id("box"),
  width: "100%",
  viewBox: "0 0 800 320",
  }) do

  style().add_text(<<-CSS)
    ##{make_id("box")} {
      border: 1px solid #e8e8e8;
      background-color: #f5f5f5;
    }
    .#{make_id("t1")} {
      font-family: sans-serif;
      font-size: 16px;
      text-anchor: left;
      dominant-baseline: middle;
    }
    .#{make_id("t2")} {
      font-family: sans-serif;
      font-size: 16px;
      text-anchor: left;
      dominant-baseline: middle;
      fill: #{color_red};
    }
    .#{make_id("l0")} {
      stroke: #{color_orange};
      stroke-width: 3;
      fill: none;
    }
    .#{make_id("arrow0")} {
      stroke: #{color_orange};
      stroke-width: 1;
      fill: #{color_orange};
    }
    .#{make_id("l1")} {
      stroke: #{color_blue};
      stroke-width: 3;
      fill: none;
    }
    .#{make_id("arrow1")} {
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
      id: make_id("arrow0"),
      viewBox: "0, 0, 10, 10",
      refX: 5, refY: 5,
      markerWidth: 6, markerHeight: 6,
      orient: "auto-start-reverse",
    ) do
      path(
        d: "M 0 0 L 10 5 L 0 10 L 2.5 5 Z",
        class: make_id("arrow0")
      )
    end
    marker(
      id: make_id("arrow1"),
      viewBox: "0, 0, 10, 10",
      refX: 5, refY: 5,
      markerWidth: 6, markerHeight: 6,
      orient: "auto-start-reverse",
    ) do
      path(
        d: "M 0 0 L 10 5 L 0 10 L 2.5 5 Z",
        class: make_id("arrow1")
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

  rect(x: 10, y: 105, width: 180, height: 78, class: make_id("box_white"))

  rect(x: 210, y: 152, width: 60, height: 30, class: make_id("box_white"))
  path(
    class: make_id("l0"),
    d: "M 160 158 c 20 -70 70 -40 70 -18",
    marker_end: "url(##{make_id("arrow0")})"
  )

  text( class: make_id("t1"),
    x: 20, y: 125
  ).add_text("run")
  text( class: make_id("t2"),
    x: 30, y: 145
  ).add_text("stop_source: true")
  text( class: make_id("t1"),
    x: 30, y: 165
  ).add_text("done: false")

  rect(x: 280, y: 5, width: 180, height: 310, class: make_id("box_white"))
  path(
    class: make_id("l0"),
    d: "M 230 158 c 20 -70 70 -40 70 -18",
    marker_end: "url(##{make_id("arrow0")})"
  )

  rect(x: 480, y: 152, width: 60, height: 30, class: make_id("box_white"))
  path(
    class: make_id("l2"),
    d: "M 510 183 c -5 30 -40 30 -66 -16",
    marker_end: "url(##{make_id("arrow2")})"
  )
  line(
    class: make_id("l4"),
    x1: 420, y1: 165, x2: 430, y2: 155
  )
  line(
    class: make_id("l4"),
    x1: 420, y1: 155, x2: 430, y2: 165
  )

  rect(x: 480, y: 252, width: 60, height: 30, class: make_id("box_white"))
  path(
    class: make_id("l3"),
    d: "M 440 258 c 20 -70 70 -40 70 -18",
    marker_end: "url(##{make_id("arrow3")})"
  )
  rect(x: 550, y: 252, width: 60, height: 30, class: make_id("box_white"))
  path(
    class: make_id("l3"),
    d: "M 510 258 c 20 -70 70 -40 70 -18",
    marker_end: "url(##{make_id("arrow3")})"
  )
  rect(x: 620, y: 252, width: 60, height: 30, class: make_id("box_white"))
  path(
    class: make_id("l3"),
    d: "M 580 258 c 20 -70 70 -40 70 -18",
    marker_end: "url(##{make_id("arrow3")})"
  )

  text(
    class: make_id("t1"),
    x: 200, y: 85
  ).add_text("parent")
  text(
    class: make_id("t1"),
    x: 200, y: 105
  ).add_text("chain")

  text( class: make_id("t1"),
    x: 290, y: 25
  ).add_text("wait_any")
  text( class: make_id("t2"),
    x: 300, y: 45
  ).add_text("stop_source: true")
  text( class: make_id("t1"),
    x: 300, y: 65
  ).add_text("pending: 2")
  text( class: make_id("t1"),
    x: 690, y: 165
  ).add_text("child chain 2")
  text( class: make_id("t1"),
    x: 690, y: 265
  ).add_text("child chain 3")

end

# puts(image.render)

save_to_file("_includes/assets/2025-11-18-cancellation-propagation", "17-wait_any-request_stop.svg", image.render)

$crt_id += 1

image = svg({
  id: make_id("box"),
  width: "100%",
  viewBox: "0 0 800 320",
  }) do

  style().add_text(<<-CSS)
    ##{make_id("box")} {
      border: 1px solid #e8e8e8;
      background-color: #f5f5f5;
    }
    .#{make_id("t1")} {
      font-family: sans-serif;
      font-size: 16px;
      text-anchor: left;
      dominant-baseline: middle;
    }
    .#{make_id("t2")} {
      font-family: sans-serif;
      font-size: 16px;
      text-anchor: left;
      dominant-baseline: middle;
      fill: #{color_red};
    }
    .#{make_id("l0")} {
      stroke: #{color_orange};
      stroke-width: 3;
      fill: none;
    }
    .#{make_id("arrow0")} {
      stroke: #{color_orange};
      stroke-width: 1;
      fill: #{color_orange};
    }
    .#{make_id("l1")} {
      stroke: #{color_blue};
      stroke-width: 3;
      fill: none;
    }
    .#{make_id("arrow1")} {
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
      id: make_id("arrow0"),
      viewBox: "0, 0, 10, 10",
      refX: 5, refY: 5,
      markerWidth: 6, markerHeight: 6,
      orient: "auto-start-reverse",
    ) do
      path(
        d: "M 0 0 L 10 5 L 0 10 L 2.5 5 Z",
        class: make_id("arrow0")
      )
    end
    marker(
      id: make_id("arrow1"),
      viewBox: "0, 0, 10, 10",
      refX: 5, refY: 5,
      markerWidth: 6, markerHeight: 6,
      orient: "auto-start-reverse",
    ) do
      path(
        d: "M 0 0 L 10 5 L 0 10 L 2.5 5 Z",
        class: make_id("arrow1")
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

  rect(x: 10, y: 105, width: 180, height: 78, class: make_id("box_white"))

  rect(x: 210, y: 152, width: 60, height: 30, class: make_id("box_white"))
  path(
    class: make_id("l0"),
    d: "M 160 158 c 20 -70 70 -40 70 -18",
    marker_end: "url(##{make_id("arrow0")})"
  )

  text( class: make_id("t1"),
    x: 20, y: 125
  ).add_text("run")
  text( class: make_id("t2"),
    x: 30, y: 145
  ).add_text("stop_source: true")
  text( class: make_id("t1"),
    x: 30, y: 165
  ).add_text("done: false")

  rect(x: 280, y: 5, width: 180, height: 310, class: make_id("box_white"))
  path(
    class: make_id("l0"),
    d: "M 310 183 c -5 30 -40 30 -66 -16",
    marker_end: "url(##{make_id("arrow0")})"
  )

  rect(x: 480, y: 252, width: 60, height: 30, class: make_id("box_white"))
  path(
    class: make_id("l3"),
    d: "M 510 283 q -100 40 -190 -90",
    marker_end: "url(##{make_id("arrow3")})"
  )

  line(
    class: make_id("l4"),
    x1: 310, y1: 175, x2: 320, y2: 165
  )
  line(
    class: make_id("l4"),
    x1: 310, y1: 165, x2: 320, y2: 175
  )

  line(
    class: make_id("l4"),
    x1: 225, y1: 165, x2: 235, y2: 155
  )
  line(
    class: make_id("l4"),
    x1: 225, y1: 155, x2: 235, y2: 165
  )

  text(
    class: make_id("t1"),
    x: 200, y: 85
  ).add_text("parent")
  text(
    class: make_id("t1"),
    x: 200, y: 105
  ).add_text("chain")

  text( class: make_id("t1"),
    x: 290, y: 25
  ).add_text("wait_any")
  text( class: make_id("t2"),
    x: 300, y: 45
  ).add_text("stop_source: true")
  text( class: make_id("t2"),
    x: 300, y: 65
  ).add_text("pending: 0")
  text( class: make_id("t1"),
    x: 690, y: 265
  ).add_text("child chain 3")

end

# puts(image.render)

save_to_file("_includes/assets/2025-11-18-cancellation-propagation", "18-wait_any-completed.svg", image.render)

$crt_id += 1

image = svg({
  id: make_id("box"),
  width: "100%",
  viewBox: "0 0 800 110",
  }) do

  style().add_text(<<-CSS)
    ##{make_id("box")} {
      border: 1px solid #e8e8e8;
      background-color: #f5f5f5;
    }
    .#{make_id("t1")} {
      font-family: sans-serif;
      font-size: 16px;
      text-anchor: left;
      dominant-baseline: middle;
    }
    .#{make_id("t2")} {
      font-family: sans-serif;
      font-size: 16px;
      text-anchor: left;
      dominant-baseline: middle;
      fill: #{color_red};
    }
    .#{make_id("l1")} {
      stroke: #{color_blue};
      stroke-width: 3;
      fill: none;
    }
    .#{make_id("arrow1")} {
      stroke: #{color_blue};
      stroke-width: 1;
      fill: #{color_blue};
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
      id: make_id("arrow1"),
      viewBox: "0, 0, 10, 10",
      refX: 5, refY: 5,
      markerWidth: 6, markerHeight: 6,
      orient: "auto-start-reverse",
    ) do
      path(
        d: "M 0 0 L 10 5 L 0 10 L 2.5 5 Z",
        class: make_id("arrow1")
      )
    end
  end

  rect(x: 10, y: 5, width: 180, height: 78, class: make_id("box_white"))

  rect(x: 210, y: 52, width: 60, height: 30, class: make_id("box_white"))
  path(
    class: make_id("l1"),
    d: "M 170 58 c 20 -70 70 -40 70 -18",
    marker_end: "url(##{make_id("arrow1")})"
  )
  rect(x: 280, y: 52, width: 60, height: 30, class: make_id("box_white"))
  path(
    class: make_id("l1"),
    d: "M 240 58 c 20 -70 70 -40 70 -18",
    marker_end: "url(##{make_id("arrow1")})"
  )
  rect(x: 350, y: 52, width: 60, height: 30, class: make_id("box_white"))
  path(
    class: make_id("l1"),
    d: "M 310 58 c 20 -70 70 -40 70 -18",
    marker_end: "url(##{make_id("arrow1")})"
  )
  rect(x: 420, y: 52, width: 60, height: 30, class: make_id("box_white"))
  path(
    class: make_id("l1"),
    d: "M 450 83 c -5 30 -40 30 -66 -16",
    marker_end: "url(##{make_id("arrow1")})"
  )

  line(
    class: make_id("l4"),
    x1: 365, y1: 65, x2: 375, y2: 55
  )
  line(
    class: make_id("l4"),
    x1: 365, y1: 55, x2: 375, y2: 65
  )

  text( class: make_id("t1"),
    x: 20, y: 25
  ).add_text("run")
  text( class: make_id("t1"),
    x: 30, y: 45
  ).add_text("stop_source: false")
  text( class: make_id("t1"),
    x: 30, y: 65
  ).add_text("done: false")
end

# puts(image.render)

save_to_file("_includes/assets/2025-11-18-cancellation-propagation", "19-leaf-stop.svg", image.render)

$crt_id += 1


