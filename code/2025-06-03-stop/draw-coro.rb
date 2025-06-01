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

save_to_file("_includes/assets/2025-06-03-stop", "00-cover.svg", image.render)

$crt_id += 1

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
    .#{make_id("t1")} {
      font-family: sans-serif;
      font-size: 16px;
      dominant-baseline: middle;
    }
    .#{make_id("l1")} {
      stroke: #000000;
      stroke-width: 2;
      fill: none;
    }
    .#{make_id("l2")} {
      stroke: #000000;
      stroke-dasharray: 5;
      stroke-width: 2;
      fill: none;
    }
    .#{make_id("task_white")} {
      stroke: #000000;
      stroke-width: 4;
      fill: #{color_white};
    }
    .#{make_id("task_orange")} {
      stroke: #000000;
      stroke-width: 4;
      fill: #{color_orange};
    }
    .#{make_id("task_red")} {
      stroke: #000000;
      stroke-width: 4;
      fill: #{color_red};
    }
  CSS

  defs() do
    marker(
      id: make_id("arrow"),
      viewBox: "0, 0, 10, 10",
      refX: 5, refY: 5,
      markerWidth: 6, markerHeight: 6,
      orient: "auto-start-reverse"
    ) do
      path(d: "M 0 0 L 10 5 L 0 10 L 2.5 5 Z")
    end
  end

  rect(x: 30, y: 10, width: 100, height: 250, class: make_id("task_white"))

  path(
    class: make_id("l1"),
    d: "M 80 30 v 215 h -60",
    marker_end: "url(##{make_id("arrow")})"
  )

  rect(x: 180, y: 40, width: 100, height: 30, class: make_id("task_orange"))
  text(
    class: make_id("t1"), x: 190, y: 55
  ).add_text("ref")

  rect(x: 180, y: 150, width: 100, height: 30, class: make_id("task_red"))
  text(
    class: make_id("t1"), x: 190, y: 165
  ).add_text("stop")

  path(
    class: make_id("l1"),
    d: "M 230 70 v 72",
    marker_end: "url(##{make_id("arrow")})"
  )

  path(
    class: make_id("l2"),
    d: "M 80 40 h 92",
    marker_end: "url(##{make_id("arrow")})"
  )
  path(
    class: make_id("l2"),
    d: "M 80 140 h 25 v -83 h 67",
    marker_end: "url(##{make_id("arrow")})"
  )
  path(
    class: make_id("l2"),
    d: "M 80 240 h 75 v -170 h 17",
    marker_end: "url(##{make_id("arrow")})"
  )

  text(
    class: make_id("t1"), x: 140, y: 25
  ).add_text("token.stop_requested()")

  rect(x: 330, y: 10, width: 100, height: 280, class: make_id("task_white"))

  path(
    class: make_id("l1"),
    d: "M 380 30 v 230",
    marker_end: "url(##{make_id("arrow")})"
  )

  path(
    class: make_id("l2"),
    d: "M 380 165 h -92",
    marker_end: "url(##{make_id("arrow")})"
  )
  text(
    class: make_id("t1"), x: 440, y: 160
  ).add_text("source.request_stop()")

end

# puts(image.render)

save_to_file("_includes/assets/2025-06-03-stop", "01-stop-token.svg", image.render)

$crt_id += 1

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
    .#{make_id("t1")} {
      font-family: sans-serif;
      font-size: 16px;
      dominant-baseline: middle;
    }
    .#{make_id("l1")} {
      stroke: #000000;
      stroke-width: 2;
      fill: none;
    }
    .#{make_id("l2")} {
      stroke: #000000;
      stroke-dasharray: 5;
      stroke-width: 2;
      fill: none;
    }
    .#{make_id("task_white")} {
      stroke: #000000;
      stroke-width: 4;
      fill: #{color_white};
    }
    .#{make_id("task_orange")} {
      stroke: #000000;
      stroke-width: 4;
      fill: #{color_orange};
    }
    .#{make_id("task_pink")} {
      stroke: #000000;
      stroke-width: 4;
      fill: #{color_pink};
    }
    .#{make_id("task_red")} {
      stroke: #000000;
      stroke-width: 4;
      fill: #{color_red};
    }
  CSS

  defs() do
    marker(
      id: make_id("arrow"),
      viewBox: "0, 0, 10, 10",
      refX: 5, refY: 5,
      markerWidth: 6, markerHeight: 6,
      orient: "auto-start-reverse"
    ) do
      path(d: "M 0 0 L 10 5 L 0 10 L 2.5 5 Z")
    end
  end

  rect(x: 30, y: 10, width: 100, height: 100, class: make_id("task_white"))

  path(
    class: make_id("l1"),
    d: "M 80 30 v 65 h -60",
    marker_end: "url(##{make_id("arrow")})"
  )

  rect(x: 180, y: 40, width: 100, height: 30, class: make_id("task_white"))
  text(
    class: make_id("t1"), x: 190, y: 55
  ).add_text("next")
  rect(x: 180, y: 70, width: 100, height: 30, class: make_id("task_white"))
  text(
    class: make_id("t1"), x: 190, y: 85
  ).add_text("prev")
  rect(x: 180, y: 100, width: 100, height: 60, class: make_id("task_orange"))
  text(
    class: make_id("t1"), x: 190, y: 130
  ).add_text("callback")
  path(
    class: make_id("l1"),
    d: "M 180 100 l 100 -30",
  )

  rect(x: 330, y: 40, width: 100, height: 30, class: make_id("task_white"))
  text(
    class: make_id("t1"), x: 340, y: 55
  ).add_text("next")
  rect(x: 330, y: 70, width: 100, height: 30, class: make_id("task_white"))
  text(
    class: make_id("t1"), x: 340, y: 85
  ).add_text("prev")
  rect(x: 330, y: 100, width: 100, height: 60, class: make_id("task_pink"))
  text(
    class: make_id("t1"), x: 340, y: 130
  ).add_text("callback")
  path(
    class: make_id("l1"),
    d: "M 330 70 l 100 -30",
  )

  rect(x: 480, y: 130, width: 100, height: 30, class: make_id("task_red"))
  text(
    class: make_id("t1"), x: 490, y: 145
  ).add_text("stop")
  rect(x: 480, y: 160, width: 100, height: 30, class: make_id("task_white"))
  text(
    class: make_id("t1"), x: 490, y: 175
  ).add_text("head")
  rect(x: 480, y: 190, width: 100, height: 30, class: make_id("task_white"))
  text(
    class: make_id("t1"), x: 490, y: 205
  ).add_text("tail")

  path(
    class: make_id("l2"),
    d: "M 80 40 h 92",
    marker_end: "url(##{make_id("arrow")})"
  )

  path(
    class: make_id("l1"),
    d: "M 280 55 h 42",
    marker_end: "url(##{make_id("arrow")})"
  )
  path(
    class: make_id("l1"),
    d: "M 330 85 h -42",
    marker_end: "url(##{make_id("arrow")})"
  )

  path(
    class: make_id("l1"),
    d: "M 480 175 h -250 v -7",
    marker_end: "url(##{make_id("arrow")})"
  )
  path(
    class: make_id("l1"),
    d: "M 480 205 h -25 v -120 h -17",
    marker_end: "url(##{make_id("arrow")})"
  )


  text(
    class: make_id("t1"), x: 140, y: 25
  ).add_text("stop_callback")

  rect(x: 630, y: 10, width: 100, height: 150, class: make_id("task_white"))
  rect(x: 630, y: 160, width: 100, height: 80, class: make_id("task_orange"))
  rect(x: 630, y: 240, width: 100, height: 20, class: make_id("task_pink"))
  rect(x: 630, y: 260, width: 100, height: 30, class: make_id("task_white"))

  path(
    class: make_id("l1"),
    d: "M 680 30 v 240",
    marker_end: "url(##{make_id("arrow")})"
  )

  path(
    class: make_id("l2"),
    d: "M 680 145 h -92",
    marker_end: "url(##{make_id("arrow")})"
  )
  text(
    class: make_id("t1"), x: 500, y: 115
  ).add_text("source.request_stop()")

  rect(x: 30, y: 220, width: 100, height: 50, class: make_id("task_white"))

  path(
    class: make_id("l2"),
    d: "M 630 230 h -492",
    marker_end: "url(##{make_id("arrow")})"
  )
  path(
    class: make_id("l1"),
    d: "M 20 230 h 60 v 22",
    marker_end: "url(##{make_id("arrow")})"
  )

end

# puts(image.render)

save_to_file("_includes/assets/2025-06-03-stop", "02-stop-callback.svg", image.render)

$crt_id += 1

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
    .#{make_id("t1")} {
      font-family: sans-serif;
      font-size: 16px;
      dominant-baseline: middle;
    }
    .#{make_id("l1")} {
      stroke: #000000;
      stroke-width: 2;
      fill: none;
    }
    .#{make_id("l2")} {
      stroke: #000000;
      stroke-dasharray: 5;
      stroke-width: 2;
      fill: none;
    }
    .#{make_id("task_white")} {
      stroke: #000000;
      stroke-width: 4;
      fill: #{color_white};
    }
    .#{make_id("task_orange")} {
      stroke: #000000;
      stroke-width: 4;
      fill: #{color_orange};
    }
    .#{make_id("task_pink")} {
      stroke: #000000;
      stroke-width: 4;
      fill: #{color_pink};
    }
    .#{make_id("task_red")} {
      stroke: #000000;
      stroke-width: 4;
      fill: #{color_red};
    }
  CSS

  defs() do
    marker(
      id: make_id("arrow"),
      viewBox: "0, 0, 10, 10",
      refX: 5, refY: 5,
      markerWidth: 6, markerHeight: 6,
      orient: "auto-start-reverse"
    ) do
      path(d: "M 0 0 L 10 5 L 0 10 L 2.5 5 Z")
    end
  end

  rect(x: 30, y: 10, width: 100, height: 150, class: make_id("task_white"))
  rect(x: 30, y: 160, width: 100, height: 80, class: make_id("task_orange"))
  rect(x: 30, y: 240, width: 100, height: 30, class: make_id("task_white"))

  path(
    class: make_id("l1"),
    d: "M 80 30 v 222",
    marker_end: "url(##{make_id("arrow")})"
  )

  rect(x: 480, y: 50, width: 100, height: 30, class: make_id("task_red"))
  text(
    class: make_id("t1"), x: 490, y: 65
  ).add_text("stop")
  rect(x: 480, y: 80, width: 100, height: 30, class: make_id("task_white"))
  text(
    class: make_id("t1"), x: 490, y: 95
  ).add_text("head")
  rect(x: 480, y: 110, width: 100, height: 30, class: make_id("task_white"))
  text(
    class: make_id("t1"), x: 490, y: 125
  ).add_text("tail")
  path(
    class: make_id("l1"),
    d: "M 480 110 l 100 -30",
  )
  path(
    class: make_id("l1"),
    d: "M 480 140 l 100 -30",
  )

  path(
    class: make_id("l2"),
    d: "M 80 150 h 92",
    marker_end: "url(##{make_id("arrow")})"
  )

  text(
    class: make_id("t1"), x: 140, y: 135
  ).add_text("stop_callback")

  rect(x: 180, y: 150, width: 100, height: 30, class: make_id("task_white"))
  text(
    class: make_id("t1"), x: 190, y: 165
  ).add_text("next")
  rect(x: 180, y: 180, width: 100, height: 30, class: make_id("task_white"))
  text(
    class: make_id("t1"), x: 190, y: 195
  ).add_text("prev")
  rect(x: 180, y: 210, width: 100, height: 60, class: make_id("task_white"))
  text(
    class: make_id("t1"), x: 190, y: 240
  ).add_text("callback")
  path(
    class: make_id("l1"),
    d: "M 180 180 l 100 -30",
  )
  path(
    class: make_id("l1"),
    d: "M 180 210 l 100 -30",
  )
  path(
    class: make_id("l1"),
    d: "M 180 270 l 100 -60",
  )

  rect(x: 630, y: 10, width: 100, height: 280, class: make_id("task_white"))

  path(
    class: make_id("l1"),
    d: "M 680 30 v 240",
    marker_end: "url(##{make_id("arrow")})"
  )

  path(
    class: make_id("l2"),
    d: "M 680 65 h -92",
    marker_end: "url(##{make_id("arrow")})"
  )
  text(
    class: make_id("t1"), x: 500, y: 35
  ).add_text("source.request_stop()")

  path(
    class: make_id("l2"),
    d: "M 280 165 h 100 v -90 h 92",
    marker_end: "url(##{make_id("arrow")})"
  )

end

# puts(image.render)

save_to_file("_includes/assets/2025-06-03-stop", "03-stop-late.svg", image.render)

$crt_id += 1


