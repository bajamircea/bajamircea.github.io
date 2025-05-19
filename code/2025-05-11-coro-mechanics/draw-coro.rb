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
  return "svg20250511-" + $crt_id.to_s + "-" + arg
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
    .#{make_id("task_grey")} {
      stroke: #000000;
      stroke-width: 4;
      fill: #{color_grey};
    }
    .#{make_id("task_green")} {
      stroke: #000000;
      stroke-width: 4;
      fill: #{color_green2};
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

  rect(x: 10, y: 10, width: 100, height: 70, class: make_id("task_grey"))
  rect(x: 10, y: 80, width: 100, height: 30, class: make_id("task_green"))
  rect(x: 10, y: 110, width: 100, height: 20, class: make_id("task_green"))
  rect(x: 10, y: 130, width: 100, height: 60, class: make_id("task_green"))
  rect(x: 10, y: 190, width: 100, height: 30, class: make_id("task_green"))
  rect(x: 10, y: 220, width: 100, height: 55, class: make_id("task_white"))

  rect(x: 400, y: 50, width: 100, height: 35, class: make_id("task_neutral"))
  rect(x: 400, y: 85, width: 100, height: 50, class: make_id("task_neutral"))
  rect(x: 400, y: 135, width: 100, height: 60, class: make_id("task_neutral"))
  rect(x: 400, y: 195, width: 100, height: 80, class: make_id("task_neutral"))

  text(
    class: make_id("t1"), x: 10, y: 290
  ).add_text("stack")
  text(
    class: make_id("t1"), x: 120, y: 205
  ).add_text("1. return value = 10.")
  text(
    class: make_id("t1"), x: 120, y: 160
  ).add_text("2. arguments")
  text(
    class: make_id("t1"), x: 120, y: 120
  ).add_text("3. return address")
  text(
    class: make_id("t1"), x: 120, y: 95
  ).add_text("4. function local variables")
  text(
    class: make_id("t1"), x: 400, y: 35
  ).add_text("5. coroutine frame")
  text(
    class: make_id("t1"), x: 520, y: 65
  ).add_text("9. state machine*")
  text(
    class: make_id("t1"), x: 520, y: 110
  ).add_text("7. promise")
  text(
    class: make_id("t1"), x: 520, y: 170
  ).add_text("6. arguments")
  text(
    class: make_id("t1"), x: 520, y: 235
  ).add_text("8. coroutine body local variables")

end

#puts(image.render)

save_to_file("_includes/assets/2025-05-11-coro-mechanics", "00-cover.svg", image.render)

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
    .#{make_id("task_grey")} {
      stroke: #000000;
      stroke-width: 4;
      fill: #{color_grey};
    }
    .#{make_id("task_green")} {
      stroke: #000000;
      stroke-width: 4;
      fill: #{color_green2};
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

  rect(x: 10, y: 10, width: 100, height: 70, class: make_id("task_grey"))
  rect(x: 10, y: 80, width: 100, height: 30, class: make_id("task_green"))
  rect(x: 10, y: 110, width: 100, height: 20, class: make_id("task_green"))
  rect(x: 10, y: 130, width: 100, height: 60, class: make_id("task_green"))
  rect(x: 10, y: 190, width: 100, height: 30, class: make_id("task_green"))
  rect(x: 10, y: 220, width: 100, height: 55, class: make_id("task_white"))

  text(
    class: make_id("t1"), x: 10, y: 290
  ).add_text("stack")
  text(
    class: make_id("t1"), x: 120, y: 205
  ).add_text("1. return value")
  text(
    class: make_id("t1"), x: 120, y: 160
  ).add_text("2. arguments")
  text(
    class: make_id("t1"), x: 120, y: 120
  ).add_text("3. return address")
  text(
    class: make_id("t1"), x: 120, y: 95
  ).add_text("4. function local variables")

end

# puts(image.render)

save_to_file("_includes/assets/2025-05-11-coro-mechanics", "01-function-stack.svg", image.render)

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
    .#{make_id("l1")} {
      stroke: #000000;
      stroke-width: 2;
      fill: none;
    }
    .#{make_id("c1")} {
      stroke: #000000;
      stroke-width: 2;
      fill: #{color_pink};
    }
    .#{make_id("c2")} {
      stroke: #000000;
      stroke-width: 2;
      fill: #{color_pink2};
    }
    .#{make_id("c3")} {
      stroke: #000000;
      stroke-width: 2;
      fill: #{color_pink1};
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
  CSS

  rect(x: 10, y: 10, width: 80, height: 300, class: make_id("task_white"))
  rect(x: 130, y: 85, width: 80, height: 160, class: make_id("task_neutral2"))

  path(
    class: make_id("l1"),
    d: "M 50 30 v 70 h 120 v 20"
  )
  path(
    class: make_id("l2"),
    d: "M 170 120 v 20 l -120 -30 v 55 l 120 -15 v 40 l -120 -15 v 35
    l 120 -10 v 35 l -120 -15 v 70"
  )

  circle(cx: 50, cy: 110, r: 7, class: make_id("c1"))
  circle(cx: 50, cy: 175, r: 7, class: make_id("c3"))
  circle(cx: 50, cy: 220, r: 7, class: make_id("c3"))

  rect(x: 290, y: 250, width: 100, height: 50, class: make_id("task_neutral"))

end

# puts(image.render)

save_to_file("_includes/assets/2025-05-11-coro-mechanics", "02-cpp-coro-stackless-fn.svg", image.render)

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
    .#{make_id("task_grey")} {
      stroke: #000000;
      stroke-width: 4;
      fill: #{color_grey};
    }
    .#{make_id("task_green")} {
      stroke: #000000;
      stroke-width: 4;
      fill: #{color_green2};
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

  rect(x: 10, y: 10, width: 100, height: 70, class: make_id("task_grey"))
  rect(x: 10, y: 80, width: 100, height: 30, class: make_id("task_green"))
  rect(x: 10, y: 110, width: 100, height: 20, class: make_id("task_green"))
  rect(x: 10, y: 130, width: 100, height: 60, class: make_id("task_green"))
  rect(x: 10, y: 190, width: 100, height: 30, class: make_id("task_green"))
  rect(x: 10, y: 220, width: 100, height: 55, class: make_id("task_white"))

  rect(x: 400, y: 50, width: 100, height: 35, class: make_id("task_neutral"))
  rect(x: 400, y: 85, width: 100, height: 50, class: make_id("task_neutral"))
  rect(x: 400, y: 135, width: 100, height: 60, class: make_id("task_neutral"))
  rect(x: 400, y: 195, width: 100, height: 80, class: make_id("task_neutral"))

  text(
    class: make_id("t1"), x: 10, y: 290
  ).add_text("stack")
  text(
    class: make_id("t1"), x: 120, y: 205
  ).add_text("1. return value = 10.")
  text(
    class: make_id("t1"), x: 120, y: 160
  ).add_text("2. arguments")
  text(
    class: make_id("t1"), x: 120, y: 120
  ).add_text("3. return address")
  text(
    class: make_id("t1"), x: 120, y: 95
  ).add_text("4. function local variables")
  text(
    class: make_id("t1"), x: 400, y: 35
  ).add_text("5. coroutine frame")
  text(
    class: make_id("t1"), x: 520, y: 65
  ).add_text("9. state machine*")
  text(
    class: make_id("t1"), x: 520, y: 110
  ).add_text("7. promise")
  text(
    class: make_id("t1"), x: 520, y: 170
  ).add_text("6. arguments")
  text(
    class: make_id("t1"), x: 520, y: 235
  ).add_text("8. coroutine body local variables")

end

# puts(image.render)

save_to_file("_includes/assets/2025-05-11-coro-mechanics", "03-ramp-stack.svg", image.render)

$crt_id += 1

