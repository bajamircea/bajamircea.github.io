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
  return "svg20250513-" + $crt_id.to_s + "-" + arg
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
    .#{make_id("lzoom")} {
      stroke: #{color_grey};
      stroke-width: 4;
      fill: none;
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
    .#{make_id("t1")} {
      font-family: sans-serif;
      font-size: 16px;
      dominant-baseline: middle;
    }
  CSS

  line(
    class: make_id("lzoom"),
    x1: 110, y1: 50,
    x2: 400, y2: 25
  )
  line(
    class: make_id("lzoom"),
    x1: 110, y1: 85,
    x2: 400, y2: 95
  )
  line(
    class: make_id("lzoom"),
    x1: 110, y1: 135,
    x2: 400, y2: 190
  )
  line(
    class: make_id("lzoom"),
    x1: 110, y1: 135,
    x2: 400, y2: 225
  )

  rect(x: 10, y: 50, width: 100, height: 35, class: make_id("task_neutral"))
  rect(x: 10, y: 85, width: 100, height: 50, class: make_id("task_neutral"))
  rect(x: 10, y: 135, width: 100, height: 60, class: make_id("task_neutral"))
  rect(x: 10, y: 195, width: 100, height: 80, class: make_id("task_neutral"))

  text(
    class: make_id("t1"), x: 10, y: 35
  ).add_text("5. coroutine frame")
  text(
    class: make_id("t1"), x: 120, y: 65
  ).add_text("9. state machine*")
  text(
    class: make_id("t1"), x: 120, y: 110
  ).add_text("7. promise")
  text(
    class: make_id("t1"), x: 120, y: 170
  ).add_text("6. arguments")
  text(
    class: make_id("t1"), x: 120, y: 235
  ).add_text("8. coroutine body local variables")

  rect(x: 400, y: 25, width: 200, height: 35, class: make_id("task_neutral"))
  rect(x: 400, y: 60, width: 200, height: 35, class: make_id("task_neutral"))
  path(
    class: make_id("task_neutral"),
    d: "M 400 125 v -30 h 200 v 55 z"
  )
  path(
    class: make_id("task_neutral"),
    d: "M 400 135 v 55 h 200 v -30 z"
  )
  rect(x: 400, y: 190, width: 200, height: 35, class: make_id("task_neutral"))
  path(
    class: make_id("task_neutral"),
    d: "M 400 255 v -30 h 200 v 55 z"
  )

  text(
    class: make_id("t1"), x: 620, y: 43
  ).add_text("9.1. resume fn pointer")
  text(
    class: make_id("t1"), x: 620, y: 78
  ).add_text("9.2. resume fn pointer")
  text(
    class: make_id("t1"), x: 620, y: 140
  ).add_text("7. promise")
  text(
    class: make_id("t1"), x: 620, y: 208
  ).add_text("9.3. suspend index")
  text(
    class: make_id("t1"), x: 620, y: 268
  ).add_text("6. arguments")

end

#puts(image.render)

save_to_file("_includes/assets/2025-05-13-synthetic-coroutine", "00-cover.svg", image.render)

$crt_id += 1

