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
    .#{make_id("task_neutral2")} {
      stroke: #000000;
      stroke-width: 4;
      fill: #{color_neutral2};
    }
  CSS

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
    .#{make_id("task_neutral2")} {
      stroke: #000000;
      stroke-width: 4;
      fill: #{color_neutral2};
    }
  CSS

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

