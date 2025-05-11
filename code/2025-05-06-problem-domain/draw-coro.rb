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

def make_id(part1, part2)
  return "svg20250506-" + part1.to_s + "-" + part2.to_s
end

image = svg({
  id: make_id(1, 1),
  width: "100%",
  viewBox: "0 0 250 100",
  }) do

  style().add_text(<<-CSS)
    ##{make_id(1, 1)} {
      border: 1px solid #e8e8e8;
      background-color: #f5f5f5;
    }
    .#{make_id(1, "t1")} {
      font-family: sans-serif;
      font-size: 16px;
      font-weight: bold;
      dominant-baseline: middle;
    }
    .#{make_id(1, "task_blue")} {
      stroke: #000000;
      stroke-width: 4;
      fill: #{color_blue};
    }
    .#{make_id(1, "task_purple")} {
      stroke: #000000;
      stroke-width: 4;
      fill: #{color_purple};
    }
    .#{make_id(1, "task_orange")} {
      stroke: #000000;
      stroke-width: 4;
      fill: #{color_orange};
    }
  CSS
  rect(x: -10, y:-10, width: 80, height: 80, class: make_id(1, "task_purple"))
  rect(x: 70, y:-10, width: 60, height: 80, class: make_id(1, "task_blue"))
  rect(x: 130, y:-10, width: 30, height: 80, class: make_id(1, "task_orange"))
  rect(x: 160, y:-10, width: 40, height: 80, class: make_id(1, "task_blue"))
  rect(x: 200, y:-10, width: 60, height: 80, class: make_id(1, "task_purple"))

  rect(x: -10, y:80, width: 100, height: 80, class: make_id(1, "task_orange"))
  rect(x: 90, y: 80, width: 80, height: 80, class: make_id(1, "task_purple"))
  rect(x: 170, y:80, width: 90, height: 80, class: make_id(1, "task_orange"))
end

#puts(image.render)

save_to_file("_includes/assets/2025-05-06-cpp-coroutines", "00-cover.svg", image.render)

image = svg({
  id: make_id(2, 1),
  width: "100%",
  viewBox: "0 0 800 70",
  }) do

  style().add_text(<<-CSS)
    ##{make_id(2, 1)} {
      border: 1px solid #e8e8e8;
      background-color: #f5f5f5;
    }
    .#{make_id(2, "task_blue")} {
      stroke: #000000;
      stroke-width: 4;
      fill: #{color_blue};
    }
    .#{make_id(2, "task_purple")} {
      stroke: #000000;
      stroke-width: 4;
      fill: #{color_purple};
    }
    .#{make_id(2, "task_orange")} {
      stroke: #000000;
      stroke-width: 4;
      fill: #{color_orange};
    }
  CSS
  rect(x: 10, y: 10, width: 220, height: 50, class: make_id(2, "task_purple"))
  rect(x: 230, y: 10, width: 220, height: 50, class: make_id(2, "task_orange"))
  rect(x: 450, y: 10, width: 110, height: 50, class: make_id(2, "task_blue"))
end

# puts(image.render)

save_to_file("_includes/assets/2025-05-06-cpp-coroutines", "01-sequential.svg", image.render)

image = svg({
  id: make_id(2, 1),
  width: "100%",
  viewBox: "0 0 800 130",
  }) do

  style().add_text(<<-CSS)
    ##{make_id(2, 1)} {
      border: 1px solid #e8e8e8;
      background-color: #f5f5f5;
    }
    .#{make_id(2, "task_blue")} {
      stroke: #000000;
      stroke-width: 4;
      fill: #{color_blue};
    }
    .#{make_id(2, "task_purple")} {
      stroke: #000000;
      stroke-width: 4;
      fill: #{color_purple};
    }
    .#{make_id(2, "task_orange")} {
      stroke: #000000;
      stroke-width: 4;
      fill: #{color_orange};
    }
  CSS
  rect(x: 10, y: 10, width: 220, height: 50, class: make_id(2, "task_purple"))
  rect(x: 10, y: 70, width: 220, height: 50, class: make_id(2, "task_orange"))
  rect(x: 230, y: 10, width: 110, height: 50, class: make_id(2, "task_blue"))
end

# puts(image.render)

save_to_file("_includes/assets/2025-05-06-cpp-coroutines", "02-parallel.svg", image.render)

image = svg({
  id: make_id(3, 1),
  width: "100%",
  viewBox: "0 0 800 70",
  }) do

  style().add_text(<<-CSS)
    ##{make_id(3, 1)} {
      border: 1px solid #e8e8e8;
      background-color: #f5f5f5;
    }
    .#{make_id(3, "task_blue")} {
      stroke: #000000;
      stroke-width: 4;
      fill: #{color_blue};
    }
    .#{make_id(3, "task_purple")} {
      stroke: #000000;
      stroke-width: 4;
      fill: #{color_purple};
    }
    .#{make_id(3, "task_orange")} {
      stroke: #000000;
      stroke-width: 4;
      fill: #{color_orange};
    }
  CSS
  rect(x: 10, y: 10, width: 80, height: 50, class: make_id(3, "task_purple"))
  rect(x: 90, y: 10, width: 100, height: 50, class: make_id(3, "task_orange"))
  rect(x: 190, y: 10, width: 60, height: 50, class: make_id(3, "task_blue"))
  rect(x: 250, y: 10, width: 30, height: 50, class: make_id(3, "task_orange"))
  rect(x: 280, y: 10, width: 80, height: 50, class: make_id(3, "task_purple"))
  rect(x: 360, y: 10, width: 50, height: 50, class: make_id(3, "task_blue"))
  rect(x: 410, y: 10, width: 60, height: 50, class: make_id(3, "task_purple"))
  rect(x: 470, y: 10, width: 90, height: 50, class: make_id(3, "task_orange"))
end

# puts(image.render)

save_to_file("_includes/assets/2025-05-06-cpp-coroutines", "03-concurrent.svg", image.render)

image = svg({
  id: make_id(4, 1),
  width: "100%",
  viewBox: "0 0 800 130",
  }) do

  style().add_text(<<-CSS)
    ##{make_id(4, 1)} {
      border: 1px solid #e8e8e8;
      background-color: #f5f5f5;
    }
    .#{make_id(4, "task_blue")} {
      stroke: #000000;
      stroke-width: 4;
      fill: #{color_blue};
    }
    .#{make_id(4, "task_purple")} {
      stroke: #000000;
      stroke-width: 4;
      fill: #{color_purple};
    }
    .#{make_id(4, "task_orange")} {
      stroke: #000000;
      stroke-width: 4;
      fill: #{color_orange};
    }
  CSS
  rect(x: 10, y: 10, width: 80, height: 50, class: make_id(4, "task_purple"))
  rect(x: 90, y: 10, width: 60, height: 50, class: make_id(4, "task_blue"))
  rect(x: 150, y: 10, width: 30, height: 50, class: make_id(4, "task_orange"))
  rect(x: 180, y: 10, width: 50, height: 50, class: make_id(4, "task_blue"))
  rect(x: 230, y: 10, width: 60, height: 50, class: make_id(4, "task_purple"))

  rect(x: 10, y: 70, width: 100, height: 50, class: make_id(4, "task_orange"))
  rect(x: 110, y: 70, width: 80, height: 50, class: make_id(4, "task_purple"))
  rect(x: 190, y: 70, width: 90, height: 50, class: make_id(4, "task_orange"))
end

# puts(image.render)

save_to_file("_includes/assets/2025-05-06-cpp-coroutines", "04-concurrent-parallel.svg", image.render)

image = svg({
  id: make_id(5, 1),
  width: "100%",
  viewBox: "0 0 800 320",
  }) do

  style().add_text(<<-CSS)
    ##{make_id(5, 1)} {
      border: 1px solid #e8e8e8;
      background-color: #f5f5f5;
    }
    .#{make_id(5, "l1")} {
      stroke: #000000;
      stroke-width: 2;
      fill: none;
    }
    .#{make_id(5, "l2")} {
      stroke: #000000;
      stroke-width: 2;
      fill: none;
      stroke-dasharray: 5;
    }
    .#{make_id(5, "task_white")} {
      stroke: #000000;
      stroke-width: 4;
      fill: #{color_white};
    }
    .#{make_id(5, "task_green")} {
      stroke: #000000;
      stroke-width: 4;
      fill: #{color_green3};
    }
    .#{make_id(5, "task_neutral2")} {
      stroke: #000000;
      stroke-width: 4;
      fill: #{color_neutral2};
    }
  CSS

  rect(x: 10, y: 10, width: 80, height: 300, class: make_id(5, "task_white"))
  rect(x: 130, y: 85, width: 80, height: 160, class: make_id(5, "task_green"))

  path(
    class: make_id(5, "l1"),
    d: "M 50 30 v 70 h 120 v 65"
  )
  path(
    class: make_id(5, "l2"),
    d: "M 170 165 v 70 l -120 -125 v 180"
  )

  rect(x: 290, y: 10, width: 80, height: 300, class: make_id(5, "task_white"))
  rect(x: 410, y: 85, width: 80, height: 160, class: make_id(5, "task_neutral2"))

  path(
    class: make_id(5, "l1"),
    d: "M 330 30 v 70 h 120 v 20"
  )
  path(
    class: make_id(5, "l2"),
    d: "M 450 120 v 20 l -120 -30 v 55 l 120 -15 v 40 l -120 -15 v 35
    l 120 -10 v 35 l -120 -15 v 70"
  )

end

# puts(image.render)

save_to_file("_includes/assets/2025-05-06-cpp-coroutines", "05-function-coroutines.svg", image.render)

image = svg({
  id: make_id(6, 1),
  width: "100%",
  viewBox: "0 0 800 320",
  }) do

  style().add_text(<<-CSS)
    ##{make_id(6, 1)} {
      border: 1px solid #e8e8e8;
      background-color: #f5f5f5;
    }
    .#{make_id(6, "l1")} {
      stroke: #000000;
      stroke-width: 2;
      fill: none;
    }
    .#{make_id(6, "l2")} {
      stroke: #000000;
      stroke-width: 2;
      fill: none;
      stroke-dasharray: 5;
    }
    .#{make_id(6, "task_white")} {
      stroke: #000000;
      stroke-width: 4;
      fill: #{color_white};
    }
    .#{make_id(6, "task_neutral2")} {
      stroke: #000000;
      stroke-width: 4;
      fill: #{color_neutral2};
    }
  CSS

  rect(x: 10, y: 10, width: 80, height: 300, class: make_id(6, "task_white"))
  rect(x: 130, y: 85, width: 80, height: 160, class: make_id(6, "task_neutral2"))

  path(
    class: make_id(6, "l1"),
    d: "M 50 30 v 70 h 120 v 20"
  )
  path(
    class: make_id(6, "l2"),
    d: "M 170 120 v 20 l -120 -30 v 55 l 120 -15 v 40 l -120 -15 v 35
    l 120 -10 v 35 l -120 -15 v 70"
  )


  rect(x: 290, y: 10, width: 80, height: 300, class: make_id(6, "task_white"))
  rect(x: 410, y: 85, width: 80, height: 160, class: make_id(6, "task_neutral2"))
  rect(x: 530, y: 85, width: 80, height: 140, class: make_id(6, "task_neutral2"))
  rect(x: 650, y: 10, width: 80, height: 300, class: make_id(6, "task_white"))

  path(
    class: make_id(6, "l1"),
    d: "M 330 30 v 70 h 120 v 20 l 120 -20 v 50"
  )
  path(
    class: make_id(6, "l2"),
    d: "M 570 150 l -120 -20 v 10 l -120 -30 v 180"
  )

  path(
    class: make_id(6, "l2"),
    d: "M 690 30 v 200 l -120 -70 v 35 l -120 -40 v 50 l 120 0 v 10 h -120
    v 20 l 240 5 v 55"
  )

end

# puts(image.render)

save_to_file("_includes/assets/2025-05-06-cpp-coroutines", "06-coroutines.svg", image.render)

image = svg({
  id: make_id(7, 1),
  width: "100%",
  viewBox: "0 0 800 320",
  }) do

  style().add_text(<<-CSS)
    ##{make_id(7, 1)} {
      border: 1px solid #e8e8e8;
      background-color: #f5f5f5;
    }
    .#{make_id(7, "l1")} {
      stroke: #000000;
      stroke-width: 2;
      fill: none;
    }
    .#{make_id(7, "l2")} {
      stroke: #000000;
      stroke-width: 2;
      fill: none;
      stroke-dasharray: 5;
    }
    .#{make_id(7, "task_white")} {
      stroke: #000000;
      stroke-width: 4;
      fill: #{color_white};
    }
    .#{make_id(7, "task_grey")} {
      stroke: #000000;
      stroke-width: 4;
      fill: #{color_grey};
    }
    .#{make_id(7, "task_green")} {
      stroke: #000000;
      stroke-width: 4;
      fill: #{color_green2};
    }
    .#{make_id(7, "task_neutral2")} {
      stroke: #000000;
      stroke-width: 4;
      fill: #{color_neutral};
    }
  CSS

  rect(x: 10, y: 10, width: 100, height: 160, class: make_id(7, "task_grey"))
  rect(x: 10, y: 170, width: 100, height: 50, class: make_id(7, "task_green"))
  rect(x: 10, y: 220, width: 100, height: 80, class: make_id(7, "task_white"))

end

# puts(image.render)

save_to_file("_includes/assets/2025-05-06-cpp-coroutines", "07-stack.svg", image.render)

image = svg({
  id: make_id(8, 1),
  width: "100%",
  viewBox: "0 0 800 320",
  }) do

  style().add_text(<<-CSS)
    ##{make_id(8, 1)} {
      border: 1px solid #e8e8e8;
      background-color: #f5f5f5;
    }
    .#{make_id(8, "l1")} {
      stroke: #000000;
      stroke-width: 2;
      fill: none;
    }
    .#{make_id(8, "l2")} {
      stroke: #000000;
      stroke-width: 2;
      fill: none;
      stroke-dasharray: 5;
    }
    .#{make_id(8, "task_white")} {
      stroke: #000000;
      stroke-width: 4;
      fill: #{color_white};
    }
    .#{make_id(8, "task_grey")} {
      stroke: #000000;
      stroke-width: 4;
      fill: #{color_grey};
    }
    .#{make_id(8, "task_neutral")} {
      stroke: #000000;
      stroke-width: 4;
      fill: #{color_neutral};
    }
  CSS

  rect(x: 10, y: 10, width: 100, height: 210, class: make_id(8, "task_grey"))
  rect(x: 10, y: 220, width: 100, height: 80, class: make_id(8, "task_white"))

  rect(x: 290, y: 10, width: 100, height: 240, class: make_id(8, "task_grey"))
  rect(x: 290, y: 250, width: 100, height: 50, class: make_id(8, "task_neutral"))

  rect(x: 570, y: 10, width: 100, height: 220, class: make_id(8, "task_grey"))
  rect(x: 570, y: 230, width: 100, height: 70, class: make_id(8, "task_neutral"))

end

# puts(image.render)

save_to_file("_includes/assets/2025-05-06-cpp-coroutines", "08-stackful.svg", image.render)

image = svg({
  id: make_id(9, 1),
  width: "100%",
  viewBox: "0 0 800 320",
  }) do

  style().add_text(<<-CSS)
    ##{make_id(9, 1)} {
      border: 1px solid #e8e8e8;
      background-color: #f5f5f5;
    }
    .#{make_id(9, "l1")} {
      stroke: #000000;
      stroke-width: 2;
      fill: none;
    }
    .#{make_id(9, "l2")} {
      stroke: #000000;
      stroke-width: 2;
      fill: none;
      stroke-dasharray: 5;
    }
    .#{make_id(9, "task_white")} {
      stroke: #000000;
      stroke-width: 4;
      fill: #{color_white};
    }
    .#{make_id(9, "task_grey")} {
      stroke: #000000;
      stroke-width: 4;
      fill: #{color_grey};
    }
    .#{make_id(9, "task_neutral")} {
      stroke: #000000;
      stroke-width: 4;
      fill: #{color_neutral};
    }
  CSS

  rect(x: 10, y: 10, width: 100, height: 210, class: make_id(9, "task_grey"))
  rect(x: 10, y: 220, width: 100, height: 80, class: make_id(9, "task_white"))

  rect(x: 290, y: 250, width: 100, height: 50, class: make_id(9, "task_neutral"))

  rect(x: 570, y: 230, width: 100, height: 70, class: make_id(9, "task_neutral"))

end

# puts(image.render)

save_to_file("_includes/assets/2025-05-06-cpp-coroutines", "09-stackless.svg", image.render)

image = svg({
  id: make_id(10, 1),
  width: "100%",
  viewBox: "0 0 800 320",
  }) do

  style().add_text(<<-CSS)
    ##{make_id(10, 1)} {
      border: 1px solid #e8e8e8;
      background-color: #f5f5f5;
    }
    .#{make_id(10, "l1")} {
      stroke: #000000;
      stroke-width: 2;
      fill: none;
    }
    .#{make_id(10, "c1")} {
      stroke: #000000;
      stroke-width: 2;
      fill: #{color_pink};
    }
    .#{make_id(10, "c2")} {
      stroke: #000000;
      stroke-width: 2;
      fill: #{color_pink2};
    }
    .#{make_id(10, "c3")} {
      stroke: #000000;
      stroke-width: 2;
      fill: #{color_pink1};
    }
    .#{make_id(10, "l2")} {
      stroke: #000000;
      stroke-width: 2;
      fill: none;
      stroke-dasharray: 5;
    }
    .#{make_id(10, "task_white")} {
      stroke: #000000;
      stroke-width: 4;
      fill: #{color_white};
    }
    .#{make_id(10, "task_green")} {
      stroke: #000000;
      stroke-width: 4;
      fill: #{color_green3};
    }
    .#{make_id(10, "task_neutral")} {
      stroke: #000000;
      stroke-width: 4;
      fill: #{color_neutral};
    }
    .#{make_id(10, "task_neutral2")} {
      stroke: #000000;
      stroke-width: 4;
      fill: #{color_neutral2};
    }
  CSS

  rect(x: 10, y: 10, width: 80, height: 300, class: make_id(10, "task_white"))
  rect(x: 130, y: 85, width: 80, height: 160, class: make_id(10, "task_green"))

  path(
    class: make_id(10, "l1"),
    d: "M 50 30 v 70 h 120 v 65"
  )
  path(
    class: make_id(10, "l2"),
    d: "M 170 165 v 70 l -120 -125 v 180"
  )

  circle(cx: 50, cy: 110, r: 7, class: make_id(10, "c1"))

  rect(x: 290, y: 10, width: 80, height: 300, class: make_id(10, "task_white"))
  rect(x: 410, y: 85, width: 80, height: 160, class: make_id(10, "task_neutral2"))

  path(
    class: make_id(10, "l1"),
    d: "M 330 30 v 70 h 120 v 20"
  )
  path(
    class: make_id(10, "l2"),
    d: "M 450 120 v 20 l -120 -30 v 55 l 120 -15 v 40 l -120 -15 v 35
    l 120 -10 v 35 l -120 -15 v 70"
  )

  circle(cx: 330, cy: 110, r: 7, class: make_id(10, "c1"))
  circle(cx: 330, cy: 175, r: 7, class: make_id(10, "c2"))
  circle(cx: 330, cy: 220, r: 7, class: make_id(10, "c3"))

  rect(x: 570, y: 250, width: 100, height: 50, class: make_id(10,
  "task_neutral"))

end

# puts(image.render)

save_to_file("_includes/assets/2025-05-06-cpp-coroutines", "10-duality.svg", image.render)

image = svg({
  id: make_id(11, 1),
  width: "100%",
  viewBox: "0 0 800 220",
  }) do

  style().add_text(<<-CSS)
    ##{make_id(11, 1)} {
      border: 1px solid #e8e8e8;
      background-color: #f5f5f5;
    }
    .#{make_id(11, "t1")} {
      font-family: sans-serif;
      font-size: 16px;
      text-anchor: middle;
      dominant-baseline: middle;
    }
    .#{make_id(11, "l1")} {
      stroke: #000000;
      stroke-width: 2;
      fill: none;
    }
    .#{make_id(11, "l2")} {
      stroke: #000000;
      stroke-width: 4;
      fill: #{color_white};
    }
    .#{make_id(11, "task_neutral2")} {
      stroke: #000000;
      stroke-width: 4;
      fill: #{color_neutral2};
    }
  CSS

  path(
    class: make_id(11, "l2"),
    d: "M 10 80 h 60 l 20 20 v 100 h -80 z"
  )

  line(
    class: make_id(11, "l1"),
    x1: 90, y1: 140,
    x2: 150, y2: 140
  )

  text(
    class: make_id(11, "t1"),
    x: 50, y: 35
  ).add_text("source")

  rect(x: 150, y: 80, width: 80, height: 120, class: make_id(11, "task_neutral2"))

  line(
    class: make_id(11, "l1"),
    x1: 230, y1: 140,
    x2: 290, y2: 140
  )

  text(
    class: make_id(11, "t1"),
    x: 190, y: 20
  ).add_text("lexical")
  text(
    class: make_id(11, "t1"),
    x: 190, y: 50
  ).add_text("analysis")

  rect(x: 290, y: 80, width: 80, height: 120, class: make_id(11, "task_neutral2"))

  line(
    class: make_id(11, "l1"),
    x1: 370, y1: 140,
    x2: 430, y2: 140
  )

  text(
    class: make_id(11, "t1"),
    x: 330, y: 20
  ).add_text("syntactical")
  text(
    class: make_id(11, "t1"),
    x: 330, y: 50
  ).add_text("analysis")

  rect(x: 430, y: 80, width: 80, height: 120, class: make_id(11, "task_neutral2"))

  line(
    class: make_id(11, "l1"),
    x1: 510, y1: 140,
    x2: 570, y2: 140
  )

  text(
    class: make_id(11, "t1"),
    x: 470, y: 20
  ).add_text("data")
  text(
    class: make_id(11, "t1"),
    x: 470, y: 50
  ).add_text("analysis")
  rect(x: 570, y: 80, width: 80, height: 120, class: make_id(11, "task_neutral2"))

  line(
    class: make_id(11, "l1"),
    x1: 650, y1: 140,
    x2: 710, y2: 140
  )

  text(
    class: make_id(11, "t1"),
    x: 610, y: 20
  ).add_text("instruction")
  text(
    class: make_id(11, "t1"),
    x: 610, y: 50
  ).add_text("generator")

  path(
    class: make_id(11, "l2"),
    d: "M 710 80 h 60 l 20 20 v 100 h -80 z"
  )

  text(
    class: make_id(11, "t1"),
    x: 750, y: 35
  ).add_text("code")


end

# puts(image.render)

save_to_file("_includes/assets/2025-05-06-cpp-coroutines", "11-compiler.svg", image.render)

image = svg({
  id: make_id(12, 1),
  width: "100%",
  viewBox: "0 0 800 320",
  }) do

  style().add_text(<<-CSS)
    ##{make_id(12, 1)} {
      border: 1px solid #e8e8e8;
      background-color: #f5f5f5;
    }
    .#{make_id(12, "queue")} {
      stroke: #000000;
      stroke-width: 4;
      fill: #{color_white};
    }
    .#{make_id(12, "l0")} {
      stroke: #000000;
      stroke-width: 4;
      fill: none;
    }
    .#{make_id(12, "t1")} {
      stroke: #000000;
      stroke-width: 4;
      fill: #{color_white};
    }
    .#{make_id(12, "t2")} {
      stroke: #000000;
      stroke-width: 4;
      fill: #{color_grey};
    }
    .#{make_id(12, "l1")} {
      stroke: #000000;
      stroke-width: 2;
      fill: none;
    }
    .#{make_id(12, "l2")} {
      stroke: #000000;
      stroke-width: 2;
      fill: none;
      stroke-dasharray: 5;
    }
    .#{make_id(12, "tx")} {
      font-family: sans-serif;
      font-size: 16px;
      text-anchor: middle;
      dominant-baseline: middle;
    }
  CSS

  defs() do
    marker(
      id: make_id(12, "arrow"),
      viewBox: "0, 0, 10, 10",
      refX: 5, refY: 5,
      markerWidth: 6, markerHeight: 6,
      orient: "auto-start-reverse"
    ) do
      path(d: "M 0 0 L 10 5 L 0 10 L 2.5 5 Z")
    end
  end

  rect(x: 10, y: 50, width: 80, height: 150, class: make_id(12, "queue"))
  path(class: make_id(12, "l0"), d: "M 20 180 h 60")
  path(class: make_id(12, "l0"), d: "M 20 160 h 60")
  path(class: make_id(12, "l0"), d: "M 20 140 h 60")

  circle(cx: 50, cy: 270, r: 40, class: make_id(12, "t1"))
  path(
    class: make_id(12, "l1"),
    d: "M 50 200 v 22",
    marker_end: "url(##{make_id(12, "arrow")})"
  )
  path(
    class: make_id(12, "l2"),
    d: "M 90 270 h 90 v -240 h -110 v 12",
    marker_end: "url(##{make_id(12, "arrow")})"
  )

  circle(cx: 350, cy: 270, r: 40, class: make_id(12, "t2"))
  path(
    class: make_id(12, "l2"),
    d: "M 390 270 h 50 v -260 h -410 v 32",
    marker_end: "url(##{make_id(12, "arrow")})"
  )

  text(
    class: make_id(13, "tx"),
    x: 100, y: 210
  ).add_text("GetMessage")

end

# puts(image.render)

save_to_file("_includes/assets/2025-05-06-cpp-coroutines", "12-st_queue.svg", image.render)

image = svg({
  id: make_id(13, 1),
  width: "100%",
  viewBox: "0 0 800 320",
  }) do

  style().add_text(<<-CSS)
    ##{make_id(13, 1)} {
      border: 1px solid #e8e8e8;
      background-color: #f5f5f5;
    }
    .#{make_id(13, "queue")} {
      stroke: #000000;
      stroke-width: 4;
      fill: #{color_white};
    }
    .#{make_id(13, "l0")} {
      stroke: #000000;
      stroke-width: 4;
      fill: none;
    }
    .#{make_id(13, "t1")} {
      stroke: #000000;
      stroke-width: 4;
      fill: #{color_white};
    }
    .#{make_id(13, "t2")} {
      stroke: #000000;
      stroke-width: 4;
      fill: #{color_grey};
    }
    .#{make_id(13, "l1")} {
      stroke: #000000;
      stroke-width: 2;
      fill: none;
    }
    .#{make_id(13, "l2")} {
      stroke: #000000;
      stroke-width: 2;
      fill: none;
      stroke-dasharray: 5;
    }
    .#{make_id(13, "tx")} {
      font-family: sans-serif;
      font-size: 16px;
      text-anchor: middle;
      dominant-baseline: middle;
    }
  CSS

  defs() do
    marker(
      id: make_id(13, "arrow"),
      viewBox: "0, 0, 10, 10",
      refX: 5, refY: 5,
      markerWidth: 6, markerHeight: 6,
      orient: "auto-start-reverse"
    ) do
      path(d: "M 0 0 L 10 5 L 0 10 L 2.5 5 Z")
    end
  end

  rect(x: 110, y: 50, width: 80, height: 150, class: make_id(13, "queue"))
  path(class: make_id(13, "l0"), d: "M 120 180 h 60")
  path(class: make_id(13, "l0"), d: "M 120 160 h 60")
  path(class: make_id(13, "l0"), d: "M 120 140 h 60")

  circle(cx: 100, cy: 270, r: 40, class: make_id(13, "t1"))
  path(
    class: make_id(13, "l1"),
    d: "M 130 200 l -12 25",
    marker_end: "url(##{make_id(13, "arrow")})"
  )
  path(
    class: make_id(13, "l2"),
    d: "M 60 270 h -50 v -240 h 110 v 12",
    marker_end: "url(##{make_id(13, "arrow")})"
  )

  circle(cx: 200, cy: 270, r: 40, class: make_id(13, "t1"))
  path(
    class: make_id(13, "l1"),
    d: "M 170 200 l 12 25",
    marker_end: "url(##{make_id(13, "arrow")})"
  )
  path(
    class: make_id(13, "l2"),
    d: "M 240 270 h 50 v -240 h -110 v 12",
    marker_end: "url(##{make_id(13, "arrow")})"
  )

  circle(cx: 350, cy: 270, r: 40, class: make_id(13, "t2"))
  path(
    class: make_id(13, "l2"),
    d: "M 390 270 h 50 v -260 h -290 v 32",
    marker_end: "url(##{make_id(13, "arrow")})"
  )

  text(
    class: make_id(13, "tx"),
    x: 150, y: 210
  ).add_text("GetQueuedCompletionStatus x2")

end

# puts(image.render)

save_to_file("_includes/assets/2025-05-06-cpp-coroutines", "13-mt_queue.svg", image.render)



