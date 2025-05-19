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

$crt_id = 0

def make_id(arg)
  return "svg20250524-" + $crt_id.to_s + "-" + arg
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
    .#{make_id("t1")} {
      font-family: sans-serif;
      font-size: 16px;
      text-anchor: middle;
      dominant-baseline: middle;
    }
    .#{make_id("t2")} {
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
      stroke-width: 2;
      fill: none;
      stroke-dasharray: 5;
    }
    .#{make_id("task_white")} {
      stroke: #000000;
      stroke-width: 4;
      fill: #{color_white};
    }
    .#{make_id("task_green")} {
      stroke: #000000;
      stroke-width: 4;
      fill: #{color_green};
    }
    .#{make_id("task_grey")} {
      stroke: #000000;
      stroke-width: 4;
      fill: #{color_grey};
    }
    .#{make_id("task_neutral")} {
      stroke: #000000;
      stroke-width: 4;
      fill: #{color_neutral};
    }
    .#{make_id("task_neutral2")} {
      stroke: #000000;
      stroke-width: 4;
      fill: #{color_neutral2};
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
    .#{make_id("task_purple")} {
      stroke: #000000;
      stroke-width: 4;
      fill: #{color_purple};
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

  rect(x: 10, y: 10, width: 80, height: 300, class: make_id("task_white"))
  rect(x: 130, y: 70, width: 80, height: 170, class: make_id("task_neutral2"))
  rect(x: 250, y: 85, width: 80, height: 140, class: make_id("task_neutral2"))

  rect(x: 390, y: 20, width: 80, height: 30, class: make_id("task_grey"))
  rect(x: 390, y: 50, width: 80, height: 220, class: make_id("task_white"))
  rect(x: 390, y: 80, width: 80, height: 30, class: make_id("task_purple"))
  rect(x: 390, y: 110, width: 80, height: 30, class: make_id("task_neutral"))
  rect(x: 390, y: 180, width: 80, height: 30, class: make_id("task_orange"))
  rect(x: 510, y: 70, width: 80, height: 170, class: make_id("task_neutral"))
  rect(x: 510, y: 90, width: 80, height: 30, class: make_id("task_green"))
  rect(x: 510, y: 150, width: 80, height: 30, class: make_id("task_purple"))
  rect(x: 630, y: 70, width: 80, height: 170, class: make_id("task_neutral"))
  rect(x: 630, y: 90, width: 80, height: 30, class: make_id("task_green"))
  rect(x: 630, y: 170, width: 80, height: 30, class: make_id("task_pink"))

  path(
    class: make_id("l1"),
    d: "M 50 30 v 70 l 120 -20 v 40 l 120 -25 v 55"
  )
  path(
    class: make_id("l2"),
    d: "M 290 150 l -120 -20 v 10 l -120 -30 v 100 l 240 -50"
  )
  path(
    class: make_id("l1"),
    d: "M 290 160 v 55 l -120 -65 v 80 l -120 -10 v 70"
  )

  line(
    class: make_id("l1"),
    x1: 470, y1: 95, x2: 503, y2: 73,
    marker_end: "url(##{make_id("arrow")})"
  )
  line(
    class: make_id("l1"),
    x1: 510, y1: 105, x2: 477, y2: 122,
    marker_end: "url(##{make_id("arrow")})"
  )
  line(
    class: make_id("l1"),
    x1: 590, y1: 165, x2: 624, y2: 73,
    marker_end: "url(##{make_id("arrow")})"
  )
  line(
    class: make_id("l1"),
    x1: 630, y1: 105, x2: 596, y2: 73,
    marker_end: "url(##{make_id("arrow")})"
  )
  path(
    class: make_id("l1"),
    d: "M 710 185 l 20 -20 v -80 l -14 -13",
    marker_end: "url(##{make_id("arrow")})"
  )
  path(
    class: make_id("l1"),
    d: "M 470 195 h 20 v 60 h 240 v -55 l -14 -13",
    marker_end: "url(##{make_id("arrow")})"
  )

  text(
    class: make_id("t1"),
    x: 170, y: 55
  ).add_text("foo")
  text(
    class: make_id("t1"),
    x: 290, y: 70
  ).add_text("bar")
  text(
    class: make_id("t2"),
    x: 55, y: 190
  ).add_text("10s")
  text(
    class: make_id("t2"),
    x: 390, y: 285
  ).add_text("stack")
  text(
    class: make_id("t2"),
    x: 510, y: 55
  ).add_text("foo frame")
  text(
    class: make_id("t2"),
    x: 630, y: 55
  ).add_text("bar frame")

end

# puts(image.render)

save_to_file("_includes/assets/2025-05-24-lazy-task", "00-cover.svg", image.render)

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
      text-anchor: middle;
      dominant-baseline: middle;
    }
    .#{make_id("t2")} {
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
      stroke-width: 2;
      fill: none;
      stroke-dasharray: 5;
    }
    .#{make_id("task_white")} {
      stroke: #000000;
      stroke-width: 4;
      fill: #{color_white};
    }
    .#{make_id("task_green")} {
      stroke: #000000;
      stroke-width: 4;
      fill: #{color_green};
    }
    .#{make_id("task_grey")} {
      stroke: #000000;
      stroke-width: 4;
      fill: #{color_grey};
    }
    .#{make_id("task_neutral")} {
      stroke: #000000;
      stroke-width: 4;
      fill: #{color_neutral};
    }
    .#{make_id("task_neutral2")} {
      stroke: #000000;
      stroke-width: 4;
      fill: #{color_neutral2};
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
    .#{make_id("task_purple")} {
      stroke: #000000;
      stroke-width: 4;
      fill: #{color_purple};
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

  rect(x: 10, y: 10, width: 80, height: 300, class: make_id("task_white"))
  rect(x: 130, y: 70, width: 80, height: 170, class: make_id("task_neutral2"))
  rect(x: 250, y: 85, width: 80, height: 140, class: make_id("task_neutral2"))

  path(
    class: make_id("l1"),
    d: "M 50 30 v 70 l 120 -20 v 40 l 120 -25 v 55"
  )
  path(
    class: make_id("l2"),
    d: "M 290 150 l -120 -20 v 10 l -120 -30 v 100 l 240 -50"
  )
  path(
    class: make_id("l1"),
    d: "M 290 160 v 55 l -120 -65 v 80 l -120 -10 v 70"
  )

  text(
    class: make_id("t1"),
    x: 170, y: 55
  ).add_text("foo")
  text(
    class: make_id("t1"),
    x: 290, y: 70
  ).add_text("bar")
  text(
    class: make_id("t2"),
    x: 55, y: 190
  ).add_text("10s")

end

# puts(image.render)

save_to_file("_includes/assets/2025-05-24-lazy-task", "01-simple.svg", image.render)

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
      text-anchor: middle;
      dominant-baseline: middle;
    }
    .#{make_id("t2")} {
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
      stroke-width: 2;
      fill: none;
      stroke-dasharray: 5;
    }
    .#{make_id("task_white")} {
      stroke: #000000;
      stroke-width: 4;
      fill: #{color_white};
    }
    .#{make_id("task_green")} {
      stroke: #000000;
      stroke-width: 4;
      fill: #{color_green};
    }
    .#{make_id("task_grey")} {
      stroke: #000000;
      stroke-width: 4;
      fill: #{color_grey};
    }
    .#{make_id("task_neutral")} {
      stroke: #000000;
      stroke-width: 4;
      fill: #{color_neutral};
    }
    .#{make_id("task_neutral2")} {
      stroke: #000000;
      stroke-width: 4;
      fill: #{color_neutral2};
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
    .#{make_id("task_purple")} {
      stroke: #000000;
      stroke-width: 4;
      fill: #{color_purple};
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

  rect(x: 10, y: 10, width: 80, height: 300, class: make_id("task_white"))
  rect(x: 130, y: 70, width: 80, height: 170, class: make_id("task_neutral2"))

  rect(x: 390, y: 20, width: 80, height: 30, class: make_id("task_grey"))
  rect(x: 390, y: 50, width: 80, height: 220, class: make_id("task_white"))
  rect(x: 390, y: 80, width: 80, height: 30, class: make_id("task_purple"))
  rect(x: 510, y: 70, width: 80, height: 170, class: make_id("task_neutral"))

  path(
    class: make_id("l1"),
    d: "M 50 30 v 70 l 120 -20 v 40"
  )

  line(
    class: make_id("l1"),
    x1: 470, y1: 95, x2: 503, y2: 73,
    marker_end: "url(##{make_id("arrow")})"
  )

  text(
    class: make_id("t1"),
    x: 170, y: 55
  ).add_text("foo")
  text(
    class: make_id("t2"),
    x: 390, y: 285
  ).add_text("stack")
  text(
    class: make_id("t2"),
    x: 510, y: 55
  ).add_text("foo frame")

end

# puts(image.render)

save_to_file("_includes/assets/2025-05-24-lazy-task", "02-in-foo.svg", image.render)

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
      text-anchor: middle;
      dominant-baseline: middle;
    }
    .#{make_id("t2")} {
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
      stroke-width: 2;
      fill: none;
      stroke-dasharray: 5;
    }
    .#{make_id("task_white")} {
      stroke: #000000;
      stroke-width: 4;
      fill: #{color_white};
    }
    .#{make_id("task_green")} {
      stroke: #000000;
      stroke-width: 4;
      fill: #{color_green};
    }
    .#{make_id("task_grey")} {
      stroke: #000000;
      stroke-width: 4;
      fill: #{color_grey};
    }
    .#{make_id("task_neutral")} {
      stroke: #000000;
      stroke-width: 4;
      fill: #{color_neutral};
    }
    .#{make_id("task_neutral2")} {
      stroke: #000000;
      stroke-width: 4;
      fill: #{color_neutral2};
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
    .#{make_id("task_purple")} {
      stroke: #000000;
      stroke-width: 4;
      fill: #{color_purple};
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

  rect(x: 10, y: 10, width: 80, height: 300, class: make_id("task_white"))
  rect(x: 130, y: 70, width: 80, height: 170, class: make_id("task_neutral2"))
  rect(x: 250, y: 85, width: 80, height: 140, class: make_id("task_neutral2"))

  rect(x: 390, y: 20, width: 80, height: 30, class: make_id("task_grey"))
  rect(x: 390, y: 50, width: 80, height: 220, class: make_id("task_white"))
  rect(x: 390, y: 80, width: 80, height: 30, class: make_id("task_purple"))
  rect(x: 510, y: 70, width: 80, height: 170, class: make_id("task_neutral"))
  rect(x: 510, y: 150, width: 80, height: 30, class: make_id("task_purple"))
  rect(x: 630, y: 70, width: 80, height: 170, class: make_id("task_neutral"))
  rect(x: 630, y: 90, width: 80, height: 30, class: make_id("task_green"))

  path(
    class: make_id("l1"),
    d: "M 50 30 v 70 l 120 -20 v 40 l 120 -25"
  )

  line(
    class: make_id("l1"),
    x1: 470, y1: 95, x2: 503, y2: 73,
    marker_end: "url(##{make_id("arrow")})"
  )
  line(
    class: make_id("l1"),
    x1: 590, y1: 165, x2: 624, y2: 73,
    marker_end: "url(##{make_id("arrow")})"
  )
  line(
    class: make_id("l1"),
    x1: 630, y1: 105, x2: 596, y2: 73,
    marker_end: "url(##{make_id("arrow")})"
  )

  text(
    class: make_id("t1"),
    x: 170, y: 55
  ).add_text("foo")
  text(
    class: make_id("t1"),
    x: 290, y: 70
  ).add_text("bar")
  text(
    class: make_id("t2"),
    x: 390, y: 285
  ).add_text("stack")
  text(
    class: make_id("t2"),
    x: 510, y: 55
  ).add_text("foo frame")
  text(
    class: make_id("t2"),
    x: 630, y: 55
  ).add_text("bar frame")

end

# puts(image.render)

save_to_file("_includes/assets/2025-05-24-lazy-task", "03-bar-created.svg", image.render)

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
      text-anchor: middle;
      dominant-baseline: middle;
    }
    .#{make_id("t2")} {
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
      stroke-width: 2;
      fill: none;
      stroke-dasharray: 5;
    }
    .#{make_id("task_white")} {
      stroke: #000000;
      stroke-width: 4;
      fill: #{color_white};
    }
    .#{make_id("task_green")} {
      stroke: #000000;
      stroke-width: 4;
      fill: #{color_green};
    }
    .#{make_id("task_grey")} {
      stroke: #000000;
      stroke-width: 4;
      fill: #{color_grey};
    }
    .#{make_id("task_neutral")} {
      stroke: #000000;
      stroke-width: 4;
      fill: #{color_neutral};
    }
    .#{make_id("task_neutral2")} {
      stroke: #000000;
      stroke-width: 4;
      fill: #{color_neutral2};
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
    .#{make_id("task_purple")} {
      stroke: #000000;
      stroke-width: 4;
      fill: #{color_purple};
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

  rect(x: 10, y: 10, width: 80, height: 300, class: make_id("task_white"))
  rect(x: 130, y: 70, width: 80, height: 170, class: make_id("task_neutral2"))
  rect(x: 250, y: 85, width: 80, height: 140, class: make_id("task_neutral2"))

  rect(x: 390, y: 20, width: 80, height: 30, class: make_id("task_grey"))
  rect(x: 390, y: 50, width: 80, height: 220, class: make_id("task_white"))
  rect(x: 390, y: 80, width: 80, height: 30, class: make_id("task_purple"))
  rect(x: 510, y: 70, width: 80, height: 170, class: make_id("task_neutral"))
  rect(x: 510, y: 150, width: 80, height: 30, class: make_id("task_purple"))
  rect(x: 630, y: 70, width: 80, height: 170, class: make_id("task_neutral"))
  rect(x: 630, y: 90, width: 80, height: 30, class: make_id("task_green"))

  path(
    class: make_id("l1"),
    d: "M 50 30 v 70 l 120 -20 v 40 l 120 -25 v 55"
  )
  path(
    class: make_id("l2"),
    d: "M 290 150 l -120 -20 v 10 l -120 -30 v 100 l 240 -50"
  )

  line(
    class: make_id("l1"),
    x1: 470, y1: 95, x2: 503, y2: 73,
    marker_end: "url(##{make_id("arrow")})"
  )
  line(
    class: make_id("l1"),
    x1: 590, y1: 165, x2: 624, y2: 73,
    marker_end: "url(##{make_id("arrow")})"
  )
  line(
    class: make_id("l1"),
    x1: 630, y1: 105, x2: 596, y2: 73,
    marker_end: "url(##{make_id("arrow")})"
  )
  path(
    class: make_id("l1"),
    d: "M 470 195 h 20 v 60 h 240 v -169 l -14 -13",
    marker_end: "url(##{make_id("arrow")})"
  )

  text(
    class: make_id("t1"),
    x: 170, y: 55
  ).add_text("foo")
  text(
    class: make_id("t1"),
    x: 290, y: 70
  ).add_text("bar")
  text(
    class: make_id("t2"),
    x: 55, y: 190
  ).add_text("10s")
  text(
    class: make_id("t2"),
    x: 390, y: 285
  ).add_text("stack")
  text(
    class: make_id("t2"),
    x: 510, y: 55
  ).add_text("foo frame")
  text(
    class: make_id("t2"),
    x: 630, y: 55
  ).add_text("bar frame")

end

# puts(image.render)

save_to_file("_includes/assets/2025-05-24-lazy-task", "04-sleep-wakeup.svg", image.render)

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
      text-anchor: middle;
      dominant-baseline: middle;
    }
    .#{make_id("t2")} {
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
      stroke-width: 2;
      fill: none;
      stroke-dasharray: 5;
    }
    .#{make_id("task_white")} {
      stroke: #000000;
      stroke-width: 4;
      fill: #{color_white};
    }
    .#{make_id("task_green")} {
      stroke: #000000;
      stroke-width: 4;
      fill: #{color_green};
    }
    .#{make_id("task_grey")} {
      stroke: #000000;
      stroke-width: 4;
      fill: #{color_grey};
    }
    .#{make_id("task_neutral")} {
      stroke: #000000;
      stroke-width: 4;
      fill: #{color_neutral};
    }
    .#{make_id("task_neutral2")} {
      stroke: #000000;
      stroke-width: 4;
      fill: #{color_neutral2};
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
    .#{make_id("task_purple")} {
      stroke: #000000;
      stroke-width: 4;
      fill: #{color_purple};
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

  rect(x: 10, y: 10, width: 80, height: 300, class: make_id("task_white"))
  rect(x: 130, y: 70, width: 80, height: 170, class: make_id("task_neutral2"))
  rect(x: 250, y: 85, width: 80, height: 140, class: make_id("task_neutral2"))

  rect(x: 390, y: 20, width: 80, height: 30, class: make_id("task_grey"))
  rect(x: 390, y: 50, width: 80, height: 220, class: make_id("task_white"))
  rect(x: 390, y: 80, width: 80, height: 30, class: make_id("task_purple"))
  rect(x: 510, y: 70, width: 80, height: 170, class: make_id("task_neutral"))

  path(
    class: make_id("l1"),
    d: "M 50 30 v 70 l 120 -20 v 40 l 120 -25 v 55"
  )
  path(
    class: make_id("l2"),
    d: "M 290 150 l -120 -20 v 10 l -120 -30 v 100 l 240 -50"
  )
  path(
    class: make_id("l1"),
    d: "M 290 160 v 55 l -120 -65 v 80"
  )

  line(
    class: make_id("l1"),
    x1: 470, y1: 95, x2: 503, y2: 73,
    marker_end: "url(##{make_id("arrow")})"
  )

  text(
    class: make_id("t1"),
    x: 170, y: 55
  ).add_text("foo")
  text(
    class: make_id("t1"),
    x: 290, y: 70
  ).add_text("bar")
  text(
    class: make_id("t2"),
    x: 55, y: 190
  ).add_text("10s")
  text(
    class: make_id("t2"),
    x: 390, y: 285
  ).add_text("stack")
  text(
    class: make_id("t2"),
    x: 510, y: 55
  ).add_text("foo frame")

end

# puts(image.render)

save_to_file("_includes/assets/2025-05-24-lazy-task", "05-back-in-foo.svg", image.render)

$crt_id += 1
