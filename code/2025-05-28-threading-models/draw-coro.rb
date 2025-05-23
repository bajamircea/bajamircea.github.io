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
  return "svg20250528-" + $crt_id.to_s + "-" + arg
end

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

save_to_file("_includes/assets/2025-05-28-threading-models", "00-cover.svg", image.render)

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
      stroke: #000000;
      stroke-width: 4;
      fill: #{color_yellow};
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

  rect(x: 100, y: 50, width: 80, height: 150, class: make_id("queue"))
  path(class: make_id("l0"), d: "M 110 180 h 60")
  path(class: make_id("l0"), d: "M 110 160 h 60")
  path(class: make_id("l0"), d: "M 110 140 h 60")

  circle(cx: 140, cy: 270, r: 40, class: make_id("t1"))

  path(
    class: make_id("l1"),
    d: "M 140 200 v 22",
    marker_end: "url(##{make_id("arrow")})"
  )
  path(
    class: make_id("l2"),
    d: "M 100 270 h -85 v -240 h 125 v 12",
    marker_end: "url(##{make_id("arrow")})"
  )
end

#puts(image.render)

save_to_file("_includes/assets/2025-05-28-threading-models", "01-single-threaded.svg", image.render)

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

  path(
    class: make_id("l1"),
    d: "M 70 200 l 42 32",
    marker_end: "url(##{make_id("arrow")})"
  )
  path(
    class: make_id("l2"),
    d: "M 100 270 h -85 v -240 h 55 v 12",
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

save_to_file("_includes/assets/2025-05-28-threading-models", "02-single-threaded-detail.svg", image.render)

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
      stroke: #000000;
      stroke-width: 4;
      fill: #{color_yellow};
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

  rect(x: 100, y: 50, width: 80, height: 150, class: make_id("queue"))
  path(class: make_id("l0"), d: "M 110 180 h 60")
  path(class: make_id("l0"), d: "M 110 160 h 60")
  path(class: make_id("l0"), d: "M 110 140 h 60")

  circle(cx: 70, cy: 270, r: 40, class: make_id("t1"))
  circle(cx: 210, cy: 270, r: 40, class: make_id("t1"))

  path(
    class: make_id("l1"),
    d: "M 140 200 l 42 32",
    marker_end: "url(##{make_id("arrow")})"
  )
  path(
    class: make_id("l2"),
    d: "M 30 270 h -15 v -240 h 95 v 12",
    marker_end: "url(##{make_id("arrow")})"
  )

  path(
    class: make_id("l1"),
    d: "M 140 200 l -42 32",
    marker_end: "url(##{make_id("arrow")})"
  )
  path(
    class: make_id("l2"),
    d: "M 250 270 h 15 v -240 h -95 v 12",
    marker_end: "url(##{make_id("arrow")})"
  )
end

#puts(image.render)

save_to_file("_includes/assets/2025-05-28-threading-models", "03-multi-threaded.svg", image.render)

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

  rect(x: 170, y: 50, width: 80, height: 150, class: make_id("queue2"))
  path(class: make_id("l0"), d: "M 180 180 h 60")
  path(class: make_id("l0"), d: "M 180 160 h 60")
  path(class: make_id("l0"), d: "M 180 140 h 60")

  circle(cx: 70, cy: 270, r: 40, class: make_id("t1"))
  circle(cx: 210, cy: 270, r: 40, class: make_id("t1"))

  path(
    class: make_id("l1"),
    d: "M 70 200 v 22",
    marker_end: "url(##{make_id("arrow")})"
  )
  path(
    class: make_id("l2"),
    d: "M 210 200 l -112 32",
    marker_end: "url(##{make_id("arrow")})"
  )
  path(
    class: make_id("l2"),
    d: "M 30 270 h -15 v -240 h 35 v 12",
    marker_end: "url(##{make_id("arrow")})"
  )

  path(
    class: make_id("l1"),
    d: "M 210 200 v 22",
    marker_end: "url(##{make_id("arrow")})"
  )
  path(
    class: make_id("l2"),
    d: "M 70 200 l 112 32",
    marker_end: "url(##{make_id("arrow")})"
  )
  path(
    class: make_id("l2"),
    d: "M 250 270 h 15 v -240 h -35 v 12",
    marker_end: "url(##{make_id("arrow")})"
  )

  circle(cx: 370, cy: 270, r: 40, class: make_id("t2"))
  path(
    class: make_id("l2"),
    d: "M 410 270 h 15 v -260 h -335"
  )
  path(
    class: make_id("l2"),
    d: "M 190 10 v 32",
    marker_end: "url(##{make_id("arrow")})"
  )
  path(
    class: make_id("l2"),
    d: "M 90 10 v 32",
    marker_end: "url(##{make_id("arrow")})"
  )
end

#puts(image.render)

save_to_file("_includes/assets/2025-05-28-threading-models", "04-multi-threaded-detail.svg", image.render)

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
      stroke: #000000;
      stroke-width: 4;
      fill: #{color_yellow};
    }
    .#{make_id("queue3")} {
      stroke: #000000;
      stroke-width: 4;
      fill: #{color_slate};
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
    .#{make_id("t3")} {
      stroke: #000000;
      stroke-width: 4;
      fill: #{color_cambridge};
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

  rect(x: 100, y: 50, width: 80, height: 150, class: make_id("queue"))
  path(class: make_id("l0"), d: "M 110 180 h 60")
  path(class: make_id("l0"), d: "M 110 160 h 60")
  path(class: make_id("l0"), d: "M 110 140 h 60")

  circle(cx: 70, cy: 270, r: 40, class: make_id("t1"))
  circle(cx: 210, cy: 270, r: 40, class: make_id("t1"))

  path(
    class: make_id("l1"),
    d: "M 140 200 l 42 32",
    marker_end: "url(##{make_id("arrow")})"
  )

  path(
    class: make_id("l1"),
    d: "M 140 200 l -42 32",
    marker_end: "url(##{make_id("arrow")})"
  )

  rect(x: 400, y: 50, width: 80, height: 150, class: make_id("queue3"))
  path(class: make_id("l0"), d: "M 410 180 h 60")
  path(class: make_id("l0"), d: "M 410 160 h 60")
  path(class: make_id("l0"), d: "M 410 140 h 60")

  circle(cx: 370, cy: 270, r: 40, class: make_id("t3"))
  circle(cx: 510, cy: 270, r: 40, class: make_id("t3"))

  path(
    class: make_id("l1"),
    d: "M 440 200 l 42 32",
    marker_end: "url(##{make_id("arrow")})"
  )

  path(
    class: make_id("l1"),
    d: "M 440 200 l -42 32",
    marker_end: "url(##{make_id("arrow")})"
  )

  circle(cx: 670, cy: 270, r: 40, class: make_id("t2"))

  path(
    class: make_id("l2"),
    d: "M 30 270 h -15 v -233",
    marker_end: "url(##{make_id("arrow")})"
  )
  path(
    class: make_id("l2"),
    d: "M 250 270 h 15 v -233",
    marker_end: "url(##{make_id("arrow")})"
  )
  path(
    class: make_id("l2"),
    d: "M 330 270 h -15 v -233",
    marker_end: "url(##{make_id("arrow")})"
  )
  path(
    class: make_id("l2"),
    d: "M 550 270 h 15 v -233",
    marker_end: "url(##{make_id("arrow")})"
  )
  path(
    class: make_id("l2"),
    d: "M 710 270 h 15 v -233",
    marker_end: "url(##{make_id("arrow")})"
  )
  path(
    class: make_id("l2"),
    d: "M 15 30 h 710"
  )
  path(
    class: make_id("l2"),
    d: "M 140 30 v 12",
    marker_end: "url(##{make_id("arrow")})"
  )
  path(
    class: make_id("l2"),
    d: "M 440 30 v 12",
    marker_end: "url(##{make_id("arrow")})"
  )
end

#puts(image.render)

save_to_file("_includes/assets/2025-05-28-threading-models", "05-heterogeneous.svg", image.render)

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

save_to_file("_includes/assets/2025-05-28-threading-models", "06-t1.svg", image.render)

$crt_id += 1

