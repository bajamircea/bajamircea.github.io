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
  return "svg20250515-" + $crt_id.to_s + "-" + arg
end

image = svg({
  id: make_id("box"),
  width: "100%",
  viewBox: "0 0 500 200",
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
    .#{make_id("task_pink1")} {
      stroke: #000000;
      stroke-width: 4;
      fill: #{color_pink1};
    }
    .#{make_id("task_pink2")} {
      stroke: #000000;
      stroke-width: 4;
      fill: #{color_pink2};
    }
    .#{make_id("task_pink3")} {
      stroke: #000000;
      stroke-width: 4;
      fill: #{color_pink3};
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

  rect(x: 10, y: 10, width: 100, height: 30, class: make_id("task_orange"))
  rect(x: 10, y: 40, width: 100, height: 30, class: make_id("task_orange"))
  text(
    class: make_id("t1"), x: 20, y: 25
  ).add_text("min_node")
  text(
    class: make_id("t1"), x: 20, y: 55
  ).add_text("size")

  rect(x: 350, y: 10, width: 100, height: 30, class: make_id("task_white"))
  rect(x: 350, y: 40, width: 100, height: 30, class: make_id("task_white"))
  rect(x: 350, y: 70, width: 100, height: 30, class: make_id("task_white"))
  rect(x: 350, y: 100, width: 100, height: 30, class: make_id("task_pink"))
  line(
    class: make_id("l1"),
    x1: 350, y1: 40,
    x2: 450, y2: 10
  )
  text(
    class: make_id("t1"), x: 360, y: 25
  ).add_text("parent")
  text(
    class: make_id("t1"), x: 360, y: 55
  ).add_text("left")
  text(
    class: make_id("t1"), x: 360, y: 85
  ).add_text("right")
  text(
    class: make_id("t1"), x: 360, y: 115
  ).add_text("data")
  path(
    class: make_id("l1"),
    d: "M 110 25 h 232",
    marker_end: "url(##{make_id("arrow")})"
  )
  path(
    class: make_id("l1"),
    d: "M 350 55 h -100 v 67",
    marker_end: "url(##{make_id("arrow")})"
  )
  path(
    class: make_id("l1"),
    d: "M 450 85 h 100 v 37",
    marker_end: "url(##{make_id("arrow")})"
  )

  rect(x: 220, y: 130, width: 100, height: 30, class: make_id("task_white"))
  rect(x: 220, y: 160, width: 100, height: 30, class: make_id("task_white"))
  rect(x: 220, y: 190, width: 100, height: 30, class: make_id("task_white"))
  rect(x: 220, y: 220, width: 100, height: 30, class: make_id("task_pink3"))
  line(
    class: make_id("l1"),
    x1: 220, y1: 220,
    x2: 320, y2: 190
  )
  text(
    class: make_id("t1"), x: 230, y: 145
  ).add_text("parent")
  text(
    class: make_id("t1"), x: 230, y: 175
  ).add_text("left")
  text(
    class: make_id("t1"), x: 230, y: 205
  ).add_text("right")
  text(
    class: make_id("t1"), x: 230, y: 235
  ).add_text("data")
  path(
    class: make_id("l1"),
    d: "M 220 175 h -100 v 67",
    marker_end: "url(##{make_id("arrow")})"
  )
  path(
    class: make_id("l1"),
    d: "M 300 130 v -15 h 42",
    marker_end: "url(##{make_id("arrow")})"
  )

  rect(x: 480, y: 130, width: 100, height: 30, class: make_id("task_white"))
  rect(x: 480, y: 160, width: 100, height: 30, class: make_id("task_white"))
  rect(x: 480, y: 190, width: 100, height: 30, class: make_id("task_white"))
  rect(x: 480, y: 220, width: 100, height: 30, class: make_id("task_pink2"))
  line(
    class: make_id("l1"),
    x1: 480, y1: 190,
    x2: 580, y2: 160
  )
  line(
    class: make_id("l1"),
    x1: 480, y1: 220,
    x2: 580, y2: 190
  )
  text(
    class: make_id("t1"), x: 490, y: 145
  ).add_text("parent")
  text(
    class: make_id("t1"), x: 490, y: 175
  ).add_text("left")
  text(
    class: make_id("t1"), x: 490, y: 205
  ).add_text("right")
  text(
    class: make_id("t1"), x: 490, y: 235
  ).add_text("data")
  path(
    class: make_id("l1"),
    d: "M 500 130 v -15 h -42",
    marker_end: "url(##{make_id("arrow")})"
  )

  rect(x: 90, y: 250, width: 100, height: 30, class: make_id("task_white"))
  rect(x: 90, y: 280, width: 100, height: 30, class: make_id("task_white"))
  rect(x: 90, y: 310, width: 100, height: 30, class: make_id("task_white"))
  rect(x: 90, y: 340, width: 100, height: 30, class: make_id("task_pink1"))
  line(
    class: make_id("l1"),
    x1: 90, y1: 310,
    x2: 190, y2: 280
  )
  line(
    class: make_id("l1"),
    x1: 90, y1: 340,
    x2: 190, y2: 310
  )
  text(
    class: make_id("t1"), x: 100, y: 265
  ).add_text("parent")
  text(
    class: make_id("t1"), x: 100, y: 295
  ).add_text("left")
  text(
    class: make_id("t1"), x: 100, y: 325
  ).add_text("right")
  text(
    class: make_id("t1"), x: 100, y: 355
  ).add_text("data")
  path(
    class: make_id("l1"),
    d: "M 170 250 v -15 h 42",
    marker_end: "url(##{make_id("arrow")})"
  )

end

# puts(image.render)

save_to_file("_includes/assets/2025-05-15-intrusive-heap", "00-cover.svg", image.render)

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
      dominant-baseline: middle;
    }
    .#{make_id("l1")} {
      stroke: #000000;
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

  rect(x: 10, y: 10, width: 100, height: 30, class: make_id("task_orange"))
  rect(x: 10, y: 40, width: 100, height: 30, class: make_id("task_orange"))
  text(
    class: make_id("t1"), x: 20, y: 25
  ).add_text("head")
  text(
    class: make_id("t1"), x: 20, y: 55
  ).add_text("tail")

  rect(x: 160, y: 10, width: 100, height: 30, class: make_id("task_white"))
  rect(x: 160, y: 40, width: 100, height: 60, class: make_id("task_white"))
  text(
    class: make_id("t1"), x: 170, y: 25
  ).add_text("next")
  text(
    class: make_id("t1"), x: 170, y: 55
  ).add_text("data")
  path(
    class: make_id("l1"),
    d: "M 110 25 h 42",
    marker_end: "url(##{make_id("arrow")})"
  )

  rect(x: 310, y: 10, width: 100, height: 30, class: make_id("task_white"))
  rect(x: 310, y: 40, width: 100, height: 60, class: make_id("task_white"))
  text(
    class: make_id("t1"), x: 320, y: 25
  ).add_text("next")
  text(
    class: make_id("t1"), x: 320, y: 55
  ).add_text("data")
  path(
    class: make_id("l1"),
    d: "M 260 25 h 42",
    marker_end: "url(##{make_id("arrow")})"
  )

  rect(x: 460, y: 10, width: 100, height: 30, class: make_id("task_white"))
  rect(x: 460, y: 40, width: 100, height: 60, class: make_id("task_white"))
  text(
    class: make_id("t1"), x: 470, y: 25
  ).add_text("next")
  text(
    class: make_id("t1"), x: 470, y: 55
  ).add_text("data")
  path(
    class: make_id("l1"),
    d: "M 410 25 h 42",
    marker_end: "url(##{make_id("arrow")})"
  )

  rect(x: 610, y: 10, width: 100, height: 30, class: make_id("task_white"))
  rect(x: 610, y: 40, width: 100, height: 60, class: make_id("task_white"))
  line(
    class: make_id("l1"),
    x1: 610, y1: 40,
    x2: 710, y2: 10
  )
  text(
    class: make_id("t1"), x: 620, y: 25
  ).add_text("next")
  text(
    class: make_id("t1"), x: 620, y: 55
  ).add_text("data")
  path(
    class: make_id("l1"),
    d: "M 560 25 h 42",
    marker_end: "url(##{make_id("arrow")})"
  )

  path(
    class: make_id("l1"),
    d: "M 110 55 h 25 v 70 h 500 v -17",
    marker_end: "url(##{make_id("arrow")})"
  )

end

# puts(image.render)

save_to_file("_includes/assets/2025-05-15-intrusive-heap", "01-queue.svg", image.render)

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
      dominant-baseline: middle;
    }
    .#{make_id("l1")} {
      stroke: #000000;
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

  rect(x: 10, y: 10, width: 100, height: 30, class: make_id("task_orange"))
  rect(x: 10, y: 40, width: 100, height: 30, class: make_id("task_orange"))
  text(
    class: make_id("t1"), x: 20, y: 25
  ).add_text("head")
  text(
    class: make_id("t1"), x: 20, y: 55
  ).add_text("tail")

  rect(x: 160, y: 10, width: 100, height: 30, class: make_id("task_white"))
  rect(x: 160, y: 40, width: 100, height: 30, class: make_id("task_white"))
  rect(x: 160, y: 70, width: 100, height: 60, class: make_id("task_white"))
  line(
    class: make_id("l1"),
    x1: 160, y1: 70,
    x2: 260, y2: 40
  )
  text(
    class: make_id("t1"), x: 170, y: 25
  ).add_text("next")
  text(
    class: make_id("t1"), x: 170, y: 55
  ).add_text("prev")
  text(
    class: make_id("t1"), x: 170, y: 85
  ).add_text("data")
  path(
    class: make_id("l1"),
    d: "M 110 25 h 42",
    marker_end: "url(##{make_id("arrow")})"
  )

  rect(x: 310, y: 10, width: 100, height: 30, class: make_id("task_white"))
  rect(x: 310, y: 40, width: 100, height: 30, class: make_id("task_white"))
  rect(x: 310, y: 70, width: 100, height: 60, class: make_id("task_white"))
  text(
    class: make_id("t1"), x: 320, y: 25
  ).add_text("next")
  text(
    class: make_id("t1"), x: 320, y: 55
  ).add_text("prev")
  text(
    class: make_id("t1"), x: 320, y: 85
  ).add_text("data")
  path(
    class: make_id("l1"),
    d: "M 260 25 h 42",
    marker_end: "url(##{make_id("arrow")})"
  )
  path(
    class: make_id("l1"),
    d: "M 310 55 h -42",
    marker_end: "url(##{make_id("arrow")})"
  )

  rect(x: 460, y: 10, width: 100, height: 30, class: make_id("task_white"))
  rect(x: 460, y: 40, width: 100, height: 30, class: make_id("task_white"))
  rect(x: 460, y: 70, width: 100, height: 60, class: make_id("task_white"))
  text(
    class: make_id("t1"), x: 470, y: 25
  ).add_text("next")
  text(
    class: make_id("t1"), x: 470, y: 55
  ).add_text("prev")
  text(
    class: make_id("t1"), x: 470, y: 85
  ).add_text("data")
  path(
    class: make_id("l1"),
    d: "M 410 25 h 42",
    marker_end: "url(##{make_id("arrow")})"
  )
  path(
    class: make_id("l1"),
    d: "M 460 55 h -42",
    marker_end: "url(##{make_id("arrow")})"
  )

  rect(x: 610, y: 10, width: 100, height: 30, class: make_id("task_white"))
  rect(x: 610, y: 40, width: 100, height: 30, class: make_id("task_white"))
  rect(x: 610, y: 70, width: 100, height: 60, class: make_id("task_white"))
  line(
    class: make_id("l1"),
    x1: 610, y1: 40,
    x2: 710, y2: 10
  )
  text(
    class: make_id("t1"), x: 620, y: 25
  ).add_text("next")
  text(
    class: make_id("t1"), x: 620, y: 55
  ).add_text("prev")
  text(
    class: make_id("t1"), x: 620, y: 85
  ).add_text("data")
  path(
    class: make_id("l1"),
    d: "M 560 25 h 42",
    marker_end: "url(##{make_id("arrow")})"
  )
  path(
    class: make_id("l1"),
    d: "M 610 55 h -42",
    marker_end: "url(##{make_id("arrow")})"
  )

  path(
    class: make_id("l1"),
    d: "M 110 55 h 25 v 100 h 500 v -17",
    marker_end: "url(##{make_id("arrow")})"
  )

end

# puts(image.render)

save_to_file("_includes/assets/2025-05-15-intrusive-heap", "02-list.svg", image.render)

$crt_id += 1

image = svg({
  id: make_id("box"),
  width: "100%",
  viewBox: "0 0 800 380",
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
    .#{make_id("task_pink1")} {
      stroke: #000000;
      stroke-width: 4;
      fill: #{color_pink1};
    }
    .#{make_id("task_pink2")} {
      stroke: #000000;
      stroke-width: 4;
      fill: #{color_pink2};
    }
    .#{make_id("task_pink3")} {
      stroke: #000000;
      stroke-width: 4;
      fill: #{color_pink3};
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

  rect(x: 10, y: 10, width: 100, height: 30, class: make_id("task_orange"))
  rect(x: 10, y: 40, width: 100, height: 30, class: make_id("task_orange"))
  text(
    class: make_id("t1"), x: 20, y: 25
  ).add_text("min_node")
  text(
    class: make_id("t1"), x: 20, y: 55
  ).add_text("size")

  rect(x: 350, y: 10, width: 100, height: 30, class: make_id("task_white"))
  rect(x: 350, y: 40, width: 100, height: 30, class: make_id("task_white"))
  rect(x: 350, y: 70, width: 100, height: 30, class: make_id("task_white"))
  rect(x: 350, y: 100, width: 100, height: 30, class: make_id("task_pink"))
  line(
    class: make_id("l1"),
    x1: 350, y1: 40,
    x2: 450, y2: 10
  )
  text(
    class: make_id("t1"), x: 360, y: 25
  ).add_text("parent")
  text(
    class: make_id("t1"), x: 360, y: 55
  ).add_text("left")
  text(
    class: make_id("t1"), x: 360, y: 85
  ).add_text("right")
  text(
    class: make_id("t1"), x: 360, y: 115
  ).add_text("data")
  path(
    class: make_id("l1"),
    d: "M 110 25 h 232",
    marker_end: "url(##{make_id("arrow")})"
  )
  path(
    class: make_id("l1"),
    d: "M 350 55 h -100 v 67",
    marker_end: "url(##{make_id("arrow")})"
  )
  path(
    class: make_id("l1"),
    d: "M 450 85 h 100 v 37",
    marker_end: "url(##{make_id("arrow")})"
  )

  rect(x: 220, y: 130, width: 100, height: 30, class: make_id("task_white"))
  rect(x: 220, y: 160, width: 100, height: 30, class: make_id("task_white"))
  rect(x: 220, y: 190, width: 100, height: 30, class: make_id("task_white"))
  rect(x: 220, y: 220, width: 100, height: 30, class: make_id("task_pink3"))
  line(
    class: make_id("l1"),
    x1: 220, y1: 220,
    x2: 320, y2: 190
  )
  text(
    class: make_id("t1"), x: 230, y: 145
  ).add_text("parent")
  text(
    class: make_id("t1"), x: 230, y: 175
  ).add_text("left")
  text(
    class: make_id("t1"), x: 230, y: 205
  ).add_text("right")
  text(
    class: make_id("t1"), x: 230, y: 235
  ).add_text("data")
  path(
    class: make_id("l1"),
    d: "M 220 175 h -100 v 67",
    marker_end: "url(##{make_id("arrow")})"
  )
  path(
    class: make_id("l1"),
    d: "M 300 130 v -15 h 42",
    marker_end: "url(##{make_id("arrow")})"
  )

  rect(x: 480, y: 130, width: 100, height: 30, class: make_id("task_white"))
  rect(x: 480, y: 160, width: 100, height: 30, class: make_id("task_white"))
  rect(x: 480, y: 190, width: 100, height: 30, class: make_id("task_white"))
  rect(x: 480, y: 220, width: 100, height: 30, class: make_id("task_pink2"))
  line(
    class: make_id("l1"),
    x1: 480, y1: 190,
    x2: 580, y2: 160
  )
  line(
    class: make_id("l1"),
    x1: 480, y1: 220,
    x2: 580, y2: 190
  )
  text(
    class: make_id("t1"), x: 490, y: 145
  ).add_text("parent")
  text(
    class: make_id("t1"), x: 490, y: 175
  ).add_text("left")
  text(
    class: make_id("t1"), x: 490, y: 205
  ).add_text("right")
  text(
    class: make_id("t1"), x: 490, y: 235
  ).add_text("data")
  path(
    class: make_id("l1"),
    d: "M 500 130 v -15 h -42",
    marker_end: "url(##{make_id("arrow")})"
  )

  rect(x: 90, y: 250, width: 100, height: 30, class: make_id("task_white"))
  rect(x: 90, y: 280, width: 100, height: 30, class: make_id("task_white"))
  rect(x: 90, y: 310, width: 100, height: 30, class: make_id("task_white"))
  rect(x: 90, y: 340, width: 100, height: 30, class: make_id("task_pink1"))
  line(
    class: make_id("l1"),
    x1: 90, y1: 310,
    x2: 190, y2: 280
  )
  line(
    class: make_id("l1"),
    x1: 90, y1: 340,
    x2: 190, y2: 310
  )
  text(
    class: make_id("t1"), x: 100, y: 265
  ).add_text("parent")
  text(
    class: make_id("t1"), x: 100, y: 295
  ).add_text("left")
  text(
    class: make_id("t1"), x: 100, y: 325
  ).add_text("right")
  text(
    class: make_id("t1"), x: 100, y: 355
  ).add_text("data")
  path(
    class: make_id("l1"),
    d: "M 170 250 v -15 h 42",
    marker_end: "url(##{make_id("arrow")})"
  )

end

# puts(image.render)

save_to_file("_includes/assets/2025-05-15-intrusive-heap", "03-heap.svg", image.render)

$crt_id += 1

image = svg({
  id: make_id("box"),
  width: "100%",
  viewBox: "0 0 800 380",
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
    .#{make_id("task_pink1")} {
      stroke: #000000;
      stroke-width: 4;
      fill: #{color_pink1};
    }
    .#{make_id("task_pink2")} {
      stroke: #000000;
      stroke-width: 4;
      fill: #{color_pink2};
    }
    .#{make_id("task_pink3")} {
      stroke: #000000;
      stroke-width: 4;
      fill: #{color_pink3};
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

  rect(x: 10, y: 10, width: 100, height: 30, class: make_id("task_orange"))
  rect(x: 10, y: 40, width: 100, height: 30, class: make_id("task_orange"))
  text(
    class: make_id("t1"), x: 20, y: 25
  ).add_text("min_node")
  text(
    class: make_id("t1"), x: 20, y: 55
  ).add_text("size")

  rect(x: 350, y: 10, width: 100, height: 30, class: make_id("task_white"))
  rect(x: 350, y: 40, width: 100, height: 30, class: make_id("task_white"))
  rect(x: 350, y: 70, width: 100, height: 30, class: make_id("task_white"))
  rect(x: 350, y: 100, width: 100, height: 30, class: make_id("task_pink"))
  line(
    class: make_id("l1"),
    x1: 350, y1: 40,
    x2: 450, y2: 10
  )
  text(
    class: make_id("t1"), x: 360, y: 25
  ).add_text("parent")
  text(
    class: make_id("t1"), x: 360, y: 55
  ).add_text("left")
  text(
    class: make_id("t1"), x: 360, y: 85
  ).add_text("right")
  text(
    class: make_id("t1"), x: 360, y: 115
  ).add_text("data")
  text(
    class: make_id("t1"), x: 460, y: 55
  ).add_text("0000 0001")
  path(
    class: make_id("l1"),
    d: "M 110 25 h 232",
    marker_end: "url(##{make_id("arrow")})"
  )
  path(
    class: make_id("l1"),
    d: "M 350 55 h -100 v 67",
    marker_end: "url(##{make_id("arrow")})"
  )
  path(
    class: make_id("l1"),
    d: "M 450 85 h 100 v 37",
    marker_end: "url(##{make_id("arrow")})"
  )

  rect(x: 220, y: 130, width: 100, height: 30, class: make_id("task_white"))
  rect(x: 220, y: 160, width: 100, height: 30, class: make_id("task_white"))
  rect(x: 220, y: 190, width: 100, height: 30, class: make_id("task_white"))
  rect(x: 220, y: 220, width: 100, height: 30, class: make_id("task_pink3"))
  line(
    class: make_id("l1"),
    x1: 220, y1: 220,
    x2: 320, y2: 190
  )
  text(
    class: make_id("t1"), x: 230, y: 145
  ).add_text("parent")
  text(
    class: make_id("t1"), x: 230, y: 175
  ).add_text("left")
  text(
    class: make_id("t1"), x: 230, y: 205
  ).add_text("right")
  text(
    class: make_id("t1"), x: 230, y: 235
  ).add_text("data")
  text(
    class: make_id("t1"), x: 330, y: 175
  ).add_text("0000 0010")
  path(
    class: make_id("l1"),
    d: "M 220 175 h -100 v 67",
    marker_end: "url(##{make_id("arrow")})"
  )
  path(
    class: make_id("l1"),
    d: "M 300 130 v -15 h 42",
    marker_end: "url(##{make_id("arrow")})"
  )

  rect(x: 480, y: 130, width: 100, height: 30, class: make_id("task_white"))
  rect(x: 480, y: 160, width: 100, height: 30, class: make_id("task_white"))
  rect(x: 480, y: 190, width: 100, height: 30, class: make_id("task_white"))
  rect(x: 480, y: 220, width: 100, height: 30, class: make_id("task_pink2"))
  line(
    class: make_id("l1"),
    x1: 480, y1: 190,
    x2: 580, y2: 160
  )
  line(
    class: make_id("l1"),
    x1: 480, y1: 220,
    x2: 580, y2: 190
  )
  text(
    class: make_id("t1"), x: 490, y: 145
  ).add_text("parent")
  text(
    class: make_id("t1"), x: 490, y: 175
  ).add_text("left")
  text(
    class: make_id("t1"), x: 490, y: 205
  ).add_text("right")
  text(
    class: make_id("t1"), x: 490, y: 235
  ).add_text("data")
  text(
    class: make_id("t1"), x: 590, y: 175
  ).add_text("0000 0011")
  path(
    class: make_id("l1"),
    d: "M 500 130 v -15 h -42",
    marker_end: "url(##{make_id("arrow")})"
  )

  rect(x: 90, y: 250, width: 100, height: 30, class: make_id("task_white"))
  rect(x: 90, y: 280, width: 100, height: 30, class: make_id("task_white"))
  rect(x: 90, y: 310, width: 100, height: 30, class: make_id("task_white"))
  rect(x: 90, y: 340, width: 100, height: 30, class: make_id("task_pink1"))
  line(
    class: make_id("l1"),
    x1: 90, y1: 310,
    x2: 190, y2: 280
  )
  line(
    class: make_id("l1"),
    x1: 90, y1: 340,
    x2: 190, y2: 310
  )
  text(
    class: make_id("t1"), x: 100, y: 265
  ).add_text("parent")
  text(
    class: make_id("t1"), x: 100, y: 295
  ).add_text("left")
  text(
    class: make_id("t1"), x: 100, y: 325
  ).add_text("right")
  text(
    class: make_id("t1"), x: 100, y: 355
  ).add_text("data")
  text(
    class: make_id("t1"), x: 200, y: 295
  ).add_text("0000 0100")
  path(
    class: make_id("l1"),
    d: "M 170 250 v -15 h 42",
    marker_end: "url(##{make_id("arrow")})"
  )

  rect(x: 350, y: 250, width: 100, height: 30, class: make_id("task_white"))
  rect(x: 350, y: 280, width: 100, height: 30, class: make_id("task_white"))
  rect(x: 350, y: 310, width: 100, height: 30, class: make_id("task_white"))
  rect(x: 350, y: 340, width: 100, height: 30, class: make_id("task_pink"))
  text(
    class: make_id("t1"), x: 360, y: 265
  ).add_text("parent")
  text(
    class: make_id("t1"), x: 360, y: 295
  ).add_text("left")
  text(
    class: make_id("t1"), x: 360, y: 325
  ).add_text("right")
  text(
    class: make_id("t1"), x: 360, y: 355
  ).add_text("data")
  text(
    class: make_id("t1"), x: 460, y: 295
  ).add_text("0000 0101")
end

# puts(image.render)

save_to_file("_includes/assets/2025-05-15-intrusive-heap", "04-heap-insert.svg", image.render)

$crt_id += 1

