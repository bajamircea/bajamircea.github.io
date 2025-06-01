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
  return "svg20250530-" + $crt_id.to_s + "-" + arg
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

  rect(x: 30, y: 10, width: 100, height: 120, class: make_id("task_white"))

  path(
    class: make_id("l1"),
    d: "M 80 30 v 85 h -60",
    marker_end: "url(##{make_id("arrow")})"
  )

  rect(x: 180, y: 40, width: 100, height: 30, class: make_id("task_orange"))
  rect(x: 180, y: 70, width: 100, height: 30, class: make_id("task_orange"))
  text(
    class: make_id("t1"), x: 190, y: 55
  ).add_text("x")
  text(
    class: make_id("t1"), x: 190, y: 85
  ).add_text("fn")

  line(
    class: make_id("l1"),
    x1: 80, y1: 40,
    x2: 172, y2: 40,
    marker_end: "url(##{make_id("arrow")})"
  )

  line(
    class: make_id("l1"),
    x1: 280, y1: 50,
    x2: 372, y2: 50,
    marker_end: "url(##{make_id("arrow")})"
  )

  rect(x: 380, y: 50, width: 100, height: 100, class: make_id("task_white"))
  rect(x: 380, y: 150, width: 100, height: 80, class: make_id("task_orange"))
  rect(x: 380, y: 230, width: 100, height: 30, class: make_id("task_white"))

  line(
    class: make_id("l1"),
    x1: 430, y1: 55,
    x2: 430, y2: 250,
    marker_end: "url(##{make_id("arrow")})"
  )

  rect(x: 30, y: 200, width: 100, height: 80, class: make_id("task_white"))

  path(
    class: make_id("l1"),
    d: "M 430 215 h -350 v 45",
    marker_end: "url(##{make_id("arrow")})"
  )


end

# puts(image.render)

save_to_file("_includes/assets/2025-05-30-callback", "00-cover.svg", image.render)

$crt_id += 1

