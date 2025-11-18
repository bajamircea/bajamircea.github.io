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
  path(
    class: make_id("l1"),
    d: "M 300 58 c 20 -70 70 -40 70 -18",
    marker_end: "url(##{make_id("arrow1")})"
  )

  rect(x: 340, y: 52, width: 60, height: 30, class: make_id("box_white"))
  path(
    class: make_id("l1"),
    d: "M 370 58 c 20 -70 70 -40 70 -18",
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
    d: "M 300 158 c 20 -70 70 -40 70 -18",
    marker_end: "url(##{make_id("arrow2")})"
  )

  rect(x: 340, y: 152, width: 60, height: 30, class: make_id("box_white"))
  path(
    class: make_id("l2"),
    d: "M 370 158 c 20 -70 70 -40 70 -18",
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
    d: "M 300 258 c 20 -70 70 -40 70 -18",
    marker_end: "url(##{make_id("arrow3")})"
  )

  rect(x: 340, y: 252, width: 60, height: 30, class: make_id("box_white"))
  path(
    class: make_id("l3"),
    d: "M 370 258 c 20 -70 70 -40 70 -18",
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
  path(
    class: make_id("l1"),
    d: "M 300 58 c 20 -70 70 -40 70 -18",
    marker_end: "url(##{make_id("arrow1")})"
  )

  rect(x: 340, y: 52, width: 60, height: 30, class: make_id("box_white"))
  path(
    class: make_id("l1"),
    d: "M 370 58 c 20 -70 70 -40 70 -18",
    marker_end: "url(##{make_id("arrow1")})"
  )

  rect(x: 410, y: 52, width: 60, height: 30, class: make_id("box_white"))

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
  path(
    class: make_id("l3"),
    d: "M 300 258 c 20 -70 70 -40 70 -18",
    marker_end: "url(##{make_id("arrow3")})"
  )

  rect(x: 340, y: 252, width: 60, height: 30, class: make_id("box_white"))
  path(
    class: make_id("l3"),
    d: "M 370 258 c 20 -70 70 -40 70 -18",
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
    d: "M 300 83 c -5 30 -40 30 -66 -16",
    marker_end: "url(##{make_id("arrow1")})"
  )

  rect(x: 270, y: 252, width: 60, height: 30, class: make_id("box_white"))
  path(
    class: make_id("l3"),
    d: "M 230 258 c 20 -70 70 -40 70 -18",
    marker_end: "url(##{make_id("arrow3")})"
  )
  path(
    class: make_id("l3"),
    d: "M 300 258 c 20 -70 70 -40 70 -18",
    marker_end: "url(##{make_id("arrow3")})"
  )

  rect(x: 340, y: 252, width: 60, height: 30, class: make_id("box_white"))
  path(
    class: make_id("l3"),
    d: "M 370 258 c 20 -70 70 -40 70 -18",
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
    d: "M 80 183 c -5 30 -40 30 -66 -16",
    marker_end: "url(##{make_id("arrow0")})"
  )

  rect(x: 270, y: 252, width: 60, height: 30, class: make_id("box_white"))
  path(
    class: make_id("l3"),
    d: "M 300 283 q -100 40 -210 -90",
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
  text( class: make_id("t2"),
    x: 90, y: 45
  ).add_text("stop_source: true")
  text( class: make_id("t1"),
    x: 90, y: 65
  ).add_text("pending: 0")
  text( class: make_id("t1"),
    x: 490, y: 265
  ).add_text("child chain 3")
end

# puts(image.render)

save_to_file("_includes/assets/2025-11-18-cancellation-propagation", "06-wait_any-last-completes.svg", image.render)

$crt_id += 1


