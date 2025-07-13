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

color_white = "#ffffff"
color_blue = "#2d93ad"
color_pink = "#ff36ab"
color_pink1 = "#ffcdea"
color_pink2 = "#ff9bd5"
color_pink3 = "#ff69c0"
color_purple = "#9665ac"

color_grey = "#cccccc"

color_yellow = "#f4e04d"
color_maize = "#f2ed6f"
color_mindaro = "#cee397"
color_cambridge = "#8db1ab"
color_slate = "#c2c2cf"

$crt_id = 0

def make_id(arg)
  return "svg20250607-" + $crt_id.to_s + "-" + arg
end

image = svg({
  id: make_id("box"),
  width: "100%",
  viewBox: "0 0 430 170",
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
    .#{make_id("arrow4")} {
      stroke: #{color_red};
      stroke-width: 1;
      fill: #{color_red};
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
    marker(
      id: make_id("arrow4"),
      viewBox: "0, 0, 10, 10",
      refX: 5, refY: 5,
      markerWidth: 6, markerHeight: 6,
      orient: "auto-start-reverse",
    ) do
      path(
        d: "M 0 0 L 10 5 L 0 10 L 2.5 5 Z",
        class: make_id("arrow4")
      )
    end
  end

  path(
    class: make_id("l1"),
    d: "M 48 30 v 123",
    marker_end: "url(##{make_id("arrow")})"
  )
  path(
    class: make_id("l4"),
    d: "M 50 30 c 0 60 10 0 75 10",
    marker_end: "url(##{make_id("arrow4")})"
  )
  text(
    class: make_id("t1"),
    x: 49, y: 15
  ).add_text("detached")

  path(
    class: make_id("l1"),
    d: "M 270 30 c 0 20 -10 20 -50 20 s -50 0 -50 20",
    marker_end: "url(##{make_id("arrow")})"
  )
  path(
    class: make_id("l2"),
    d: "M 270 30 v 40",
    marker_end: "url(##{make_id("arrow2")})"
  )
  path(
    class: make_id("l3"),
    d: "M 270 30 c 0 20 10 20 50 20 s 50 0 50 20",
    marker_end: "url(##{make_id("arrow3")})"
  )

  path(
    class: make_id("l1"),
    d: "M 170 113 c 0 20 10 20 50 20 s 50 0 50 20"
  )
  path(
    class: make_id("l3"),
    d: "M 370 113 c 0 20 -10 20 -50 20 s -50 0 -50 20"
  )
  path(
    class: make_id("l2"),
    d: "M 270 113 v 40",
    marker_end: "url(##{make_id("arrow2")})"
  )

  path(
    class: make_id("box_white"),
    d: "M 140 82 h 60 v 30 l -60 10 z"
  )
  rect(x: 240, y: 82, width: 60, height: 30, class: make_id("box_white"))
  path(
    class: make_id("box_white"),
    d: "M 340 82 h 60 v 30 l -60 10 z"
  )

  line(
    class: make_id("l4"),
    x1: 145, y1: 115, x2: 155, y2: 105
  )
  line(
    class: make_id("l4"),
    x1: 145, y1: 105, x2: 155, y2: 115
  )
  line(
    class: make_id("l4"),
    x1: 345, y1: 115, x2: 355, y2: 105
  )
  line(
    class: make_id("l4"),
    x1: 345, y1: 105, x2: 355, y2: 115
  )

  text(
    class: make_id("t1"),
    x: 270, y: 15
  ).add_text("wait_any")
end

# puts(image.render)

save_to_file("_includes/assets/2025-06-07-structured-concurency", "00-cover.svg", image.render)

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
      stroke: #{color_red};
      stroke-width: 3;
      fill: none;
    }
    .#{make_id("arrow2")} {
      stroke: #{color_red};
      stroke-width: 1;
      fill: #{color_red};
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
  end

  path(
    class: make_id("l1"),
    d: "M 60 30 v 120",
    marker_end: "url(##{make_id("arrow")})"
  )
  text(
    class: make_id("t1"),
    x: 60, y: 15
  ).add_text("sequential")

  path(
    class: make_id("l2"),
    d: "M 140 30 c 0 60 10 0 75 10",
    marker_end: "url(##{make_id("arrow2")})"
  )
  text(
    class: make_id("t1"),
    x: 140, y: 15
  ).add_text("goto")

  rect(x: 240, y: 82, width: 60, height: 30, class: make_id("box_white"))
  rect(x: 360, y: 82, width: 60, height: 30, class: make_id("box_white"))
  path(
    class: make_id("l1"),
    d: "M 330 30 c 0 20 -10 20 -30 20 s -30 0 -30 20",
    marker_end: "url(##{make_id("arrow")})"
  )
  path(
    class: make_id("l1"),
    d: "M 330 30 c 0 20 10 20 30 20 s 30 0 30 20",
    marker_end: "url(##{make_id("arrow")})"
  )
  path(
    class: make_id("l1"),
    d: "M 270 113 c 0 20 10 20 30 20 s 30 0 30 20",
    marker_end: "url(##{make_id("arrow")})"
  )
  path(
    class: make_id("l1"),
    d: "M 390 113 c 0 20 -10 20 -30 20 s -30 0 -30 20",
    marker_end: "url(##{make_id("arrow")})"
  )
  text(
    class: make_id("t1"),
    x: 330, y: 15
  ).add_text("if")

  rect(x: 470, y: 82, width: 60, height: 30, class: make_id("box_white"))
  path(
    class: make_id("l1"),
    d: "M 500 30 v 40",
    marker_end: "url(##{make_id("arrow")})"
  )
  path(
    class: make_id("l1"),
    d: "M 500 113 c 70 70 70 -110 15 -40",
    marker_end: "url(##{make_id("arrow")})"
  )
  path(
    class: make_id("l1"),
    d: "M 500 113 v 40",
    marker_end: "url(##{make_id("arrow")})"
  )
  text(
    class: make_id("t1"),
    x: 500, y: 15
  ).add_text("loop")

  rect(x: 670, y: 82, width: 60, height: 30, class: make_id("box_white"))
  path(
    class: make_id("l1"),
    d: "M 630 30 v 58 c 20 -70 70 -40 70 -18",
    marker_end: "url(##{make_id("arrow")})"
  )
  path(
    class: make_id("l1"),
    d: "M 700 113 c -5 30 -40 30 -70 -18 v 56",
    marker_end: "url(##{make_id("arrow")})"
  )
  text(
    class: make_id("t1"),
    x: 630, y: 15
  ).add_text("function call")
end

# puts(image.render)

save_to_file("_includes/assets/2025-06-07-structured-concurency", "01-structured-programming.svg", image.render)

$crt_id += 1

image = svg({
  id: make_id("box"),
  width: "100%",
  viewBox: "0 0 800 120",
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
      stroke: #{color_red};
      stroke-width: 3;
      fill: none;
    }
    .#{make_id("arrow2")} {
      stroke: #{color_red};
      stroke-width: 1;
      fill: #{color_red};
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
  end

  path(
    class: make_id("l2"),
    d: "M 30 30 c 0 60 10 0 75 10",
    marker_end: "url(##{make_id("arrow2")})"
  )
  text(
    class: make_id("t1"),
    x: 30, y: 15
  ).add_text("goto")

  path(
    class: make_id("l1"),
    d: "M 138 30 v 60",
    marker_end: "url(##{make_id("arrow")})"
  )
  path(
    class: make_id("l2"),
    d: "M 140 30 c 0 60 10 0 75 10",
    marker_end: "url(##{make_id("arrow2")})"
  )
  text(
    class: make_id("t1"),
    x: 139, y: 15
  ).add_text("detached")
end

# puts(image.render)

save_to_file("_includes/assets/2025-06-07-structured-concurency", "02-goto-vs-detached.svg", image.render)

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

save_to_file("_includes/assets/2025-06-07-structured-concurency", "03-wait_any.svg", image.render)

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

  rect(x: 10, y: 82, width: 60, height: 40, class: make_id("box_white"))
  rect(x: 110, y: 82, width: 60, height: 30, class: make_id("box_white"))
  rect(x: 210, y: 82, width: 60, height: 35, class: make_id("box_white"))

  text(
    class: make_id("t1"),
    x: 140, y: 15
  ).add_text("wait_all")
end

# puts(image.render)

save_to_file("_includes/assets/2025-06-07-structured-concurency", "04-wait_all.svg", image.render)

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
  circle(
    class: make_id("l4"),
    cx: 117, cy: 105, r: 4
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
  ).add_text("wait_all")
end

# puts(image.render)

save_to_file("_includes/assets/2025-06-07-structured-concurency", "05-wait_all_cancel.svg", image.render)

$crt_id += 1

image = svg({
  id: make_id("box"),
  width: "100%",
  viewBox: "0 0 800 210",
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
  end

  rect(x: 100, y: 82, width: 60, height: 30, class: make_id("box_white"))
  path(
    class: make_id("l1"),
    d: "M 60 30 v 58 c 20 -70 70 -40 70 -18",
    marker_end: "url(##{make_id("arrow")})"
  )
  path(
    class: make_id("l1"),
    d: "M 130 113 c -5 30 -40 30 -70 -18 v 96",
    marker_end: "url(##{make_id("arrow")})"
  )
  rect(x: 30, y: 140, width: 60, height: 30, class: make_id("box_white"))
  text(
    class: make_id("t1"),
    x: 60, y: 15
  ).add_text("continuation")
end

# puts(image.render)

save_to_file("_includes/assets/2025-06-07-structured-concurency", "06-continuation.svg", image.render)

$crt_id += 1

image = svg({
  id: make_id("box"),
  width: "100%",
  viewBox: "0 0 800 150",
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
  end

  rect(x: 100, y: 82, width: 60, height: 30, class: make_id("box_white"))
  path(
    class: make_id("l1"),
    d: "M 60 30 v 58 c 20 -70 70 -40 70 -18",
    marker_end: "url(##{make_id("arrow")})"
  )
  path(
    class: make_id("l1"),
    d: "M 130 113 c -5 30 -40 30 -70 -18 v 36",
    marker_end: "url(##{make_id("arrow")})"
  )

  rect(x: 170, y: 82, width: 60, height: 30, class: make_id("box_white"))
  path(
    class: make_id("l1"),
    d: "M 130 88 c 20 -70 70 -40 70 -18",
    marker_end: "url(##{make_id("arrow")})"
  )
  path(
    class: make_id("l1"),
    d: "M 200 113 c -5 30 -40 30 -66 -16",
    marker_end: "url(##{make_id("arrow")})"
  )

  rect(x: 240, y: 82, width: 60, height: 30, class: make_id("box_white"))
  path(
    class: make_id("l1"),
    d: "M 200 88 c 20 -70 70 -40 70 -18",
    marker_end: "url(##{make_id("arrow")})"
  )
  path(
    class: make_id("l1"),
    d: "M 270 113 c -5 30 -40 30 -66 -16",
    marker_end: "url(##{make_id("arrow")})"
  )

  rect(x: 310, y: 82, width: 60, height: 30, class: make_id("box_white"))
  path(
    class: make_id("l1"),
    d: "M 270 88 c 20 -70 70 -40 70 -18",
    marker_end: "url(##{make_id("arrow")})"
  )
  path(
    class: make_id("l1"),
    d: "M 340 113 c -5 30 -40 30 -66 -16",
    marker_end: "url(##{make_id("arrow")})"
  )

  text(
    class: make_id("t1"),
    x: 240, y: 15
  ).add_text("chain")
end

# puts(image.render)

save_to_file("_includes/assets/2025-06-07-structured-concurency", "07-chain.svg", image.render)

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
    .#{make_id("queue")} {
      fill: #{color_yellow};
    }
    .#{make_id("queue2")} {
      stroke: #000000;
      stroke-width: 4;
      fill: #{color_maize};
    }
    .#{make_id("l0")} {
      stroke: #000000;
      stroke-width: 4;
      fill: none;
    }
    .#{make_id("t1")} {
      stroke: #000000;
      stroke-width: 4;
      fill: #{color_mindaro};
    }
    .#{make_id("t2")} {
      stroke: #000000;
      stroke-width: 4;
      fill: #{color_grey};
    }
    .#{make_id("l1")} {
      stroke: #000000;
      stroke-width: 2;
      fill: none;
    }
    .#{make_id("l2")} {
      stroke: #000000;
      stroke-width: 2;
      fill: none;
      stroke-dasharray: 5;
    }
    .#{make_id("tx")} {
      font-family: sans-serif;
      font-size: 16px;
      dominant-baseline: middle;
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

  rect(x: 20, y: 40, width: 260, height: 170, class: make_id("queue"))

  rect(x: 30, y: 50, width: 80, height: 150, class: make_id("queue2"))
  path(class: make_id("l0"), d: "M 40 180 h 60")
  path(class: make_id("l0"), d: "M 40 160 h 60")
  path(class: make_id("l0"), d: "M 40 140 h 60")

  rect(x: 150, y: 120, width: 120, height: 80, class: make_id("queue2"))
  path(class: make_id("l0"), d: "M 180 180 h 60")
  path(class: make_id("l0"), d: "M 160 160 h 60")
  path(class: make_id("l0"), d: "M 200 140 h 60")

  circle(cx: 140, cy: 270, r: 40, class: make_id("t1"))

  circle(cx: 360, cy: 270, r: 40, class: make_id("t2"))

  path(
    class: make_id("l1"),
    d: "M 70 200 l 42 32",
    marker_end: "url(##{make_id("arrow")})"
  )
  path(
    class: make_id("l2"),
    d: "M 100 270 h -85 v -240 h 35 v 12",
    marker_end: "url(##{make_id("arrow")})"
  )

  path(
    class: make_id("l1"),
    d: "M 210 200 l -42 32",
    marker_end: "url(##{make_id("arrow")})"
  )
  path(
    class: make_id("l2"),
    d: "M 180 270 h 105 v -170 h -75 v 12",
    marker_end: "url(##{make_id("arrow")})"
  )
  path(
    class: make_id("l2"),
    d: "M 400 270 h 15 v -240 h -325 v 12",
    marker_end: "url(##{make_id("arrow")})"
  )

  text(
    class: make_id("tx"),
    x: 120, y: 60
  ).add_text("ready queue")
  text(
    class: make_id("tx"),
    x: 150, y: 90
  ).add_text("timers heap")
end

#puts(image.render)

save_to_file("_includes/assets/2025-06-07-structured-concurency", "08-t1.svg", image.render)

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

save_to_file("_includes/assets/2025-06-07-structured-concurency", "09-wait_any.svg", image.render)

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

  rect(x: 10, y: 82, width: 60, height: 40, class: make_id("box_white"))
  rect(x: 110, y: 82, width: 60, height: 30, class: make_id("box_white"))
  rect(x: 210, y: 82, width: 60, height: 35, class: make_id("box_white"))

  text(
    class: make_id("t1"),
    x: 140, y: 15
  ).add_text("wait_all")
end

# puts(image.render)

save_to_file("_includes/assets/2025-06-07-structured-concurency", "10-wait_all.svg", image.render)

$crt_id += 1

image = svg({
  id: make_id("box"),
  width: "100%",
  viewBox: "0 0 800 230",
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
    d: "M 40 30 v 28",
    marker_end: "url(##{make_id("arrow")})"
  )
  path(
    class: make_id("l2"),
    d: "M 70 90 h 29",
    marker_end: "url(##{make_id("arrow2")})"
  )
  path(
    class: make_id("l3"),
    d: "M 70 130 h 129",
    marker_end: "url(##{make_id("arrow3")})"
  )

  path(
    class: make_id("l2"),
    d: "M 140 130 v 20 c 0 20 -10 20 -50 20 s -50 0 -50 20"
  )
  path(
    class: make_id("l1"),
    d: "M 40 160 v 50"
  )
  path(
    class: make_id("l3"),
    d: "M 240 170 c 0 20 -10 20 -100 20 s -100 0 -100 20",
    marker_end: "url(##{make_id("arrow3")})"
  )

  rect(x: 10, y: 70, width: 60, height: 20, class: make_id("box_white"))
  rect(x: 10, y: 90, width: 60, height: 40, class: make_id("box_white"))
  rect(x: 10, y: 130, width: 60, height: 30, class: make_id("box_white"))
  rect(x: 110, y: 90, width: 60, height: 60, class: make_id("box_white"))
  rect(x: 210, y: 130, width: 60, height: 40, class: make_id("box_white"))

  text(
    class: make_id("t1"),
    x: 40, y: 15
  ).add_text("server")
  text(
    class: make_id("t1"),
    x: 140, y: 70
  ).add_text("connection")
  text(
    class: make_id("t1"),
    x: 240, y: 110
  ).add_text("connection")
end

# puts(image.render)

save_to_file("_includes/assets/2025-06-07-structured-concurency", "11-nursery_server.svg", image.render)

$crt_id += 1

image = svg({
  id: make_id("box"),
  width: "100%",
  viewBox: "0 0 800 230",
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
    d: "M 40 30 v 28",
    marker_end: "url(##{make_id("arrow")})"
  )
  path(
    class: make_id("l2"),
    d: "M 70 70 h 29",
    marker_end: "url(##{make_id("arrow2")})"
  )
  path(
    class: make_id("l3"),
    d: "M 170 110 h 29",
    marker_end: "url(##{make_id("arrow3")})"
  )

  path(
    class: make_id("l1"),
    d: "M 40 130 v 60"
  )
  path(
    class: make_id("l3"),
    d: "M 240 140 c 0 20 -10 20 -100 20 s -100 0 -100 20"
  )
  path(
    class: make_id("l2"),
    d: "M 140 130 v 5 c 0 20 -10 20 -50 20 s -50 0 -50 20 v 15",
    marker_end: "url(##{make_id("arrow2")})"
  )

  rect(x: 10, y: 70, width: 60, height: 60, class: make_id("box_white"))
  rect(x: 110, y: 70, width: 60, height: 40, class: make_id("box_white"))
  rect(x: 110, y: 110, width: 60, height: 25, class: make_id("box_white"))
  rect(x: 210, y: 110, width: 60, height: 30, class: make_id("box_white"))

  circle(
    class: make_id("l4"),
    cx: 117, cy: 128, r: 4
  )
  line(
    class: make_id("l4"),
    x1: 215, y1: 136, x2: 225, y2: 126
  )
  line(
    class: make_id("l4"),
    x1: 215, y1: 126, x2: 225, y2: 136
  )

  text(
    class: make_id("t1"),
    x: 40, y: 15
  ).add_text("proxy 0")
  text(
    class: make_id("t1"),
    x: 140, y: 50
  ).add_text("proxy 1")
  text(
    class: make_id("t1"),
    x: 240, y: 90
  ).add_text("proxy 2")
end

# puts(image.render)

save_to_file("_includes/assets/2025-06-07-structured-concurency", "12-nursery_proxy.svg", image.render)

$crt_id += 1


