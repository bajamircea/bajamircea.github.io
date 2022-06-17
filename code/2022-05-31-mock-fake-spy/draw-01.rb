#!/usr/bin/env ruby

require_relative '../util/svg.rb'

margin = 10.0

line_width = 2 * margin

svg_width = 870.0
svg_height = 800.0

radius = 20
radius2 = 22

components = [
  { x: 400, y: 50, text: "" },
  { x: 500, y: 50, text: "users of transaction" },
  { x: 450, y: 150, text: "transaction" },
  { x: 50, y: 350, text: "src contacts_db" },
  { x: 250, y: 350, text: "dst contacts_db" },
  { x: 50, y: 450, text: "db access" },
  { x: 450, y: 450, text: "contact" },
  { x: 450, y: 550, text: "std::string" },
  { x: 650, y: 550, text: "std::vector" },
  { x: 550, y: 750, text: "heap" },
]

lines = [
  { from: 0, to: 2 },
  { from: 1, to: 2 },
  { from: 2, to: 3 },
  { from: 2, to: 4 },
  { from: 3, to: 5 },
  { from: 4, to: 5 },
  { from: 3, to: 6 },
  { from: 4, to: 6 },
  { from: 6, to: 7 },
  { from: 2, to: 6 },
  { from: 2, to: 8 },
  { from: 7, to: 9 },
  { from: 8, to: 9 },
]

def make_id(offset)
  return "svg20220531-01-" + offset.to_s
end

image = svg({
  id: make_id(1),
  width: "100%",
  viewBox: "0 0 #{svg_width} #{svg_height}",
  }) do

  style().add_text(<<-CSS)
    ##{make_id(1)} {
      border: 1px solid #e8e8e8;
      background-color: #f5f5f5;
    }
    .#{make_id("l1")} {
      stroke: #2f332b;
      stroke-width: 4;
      stroke-linecap: butt;
      stroke-linejoin: miter;
      fill: #f5bb00;
    }
    .#{make_id("l2")} {
      stroke: black;
      stroke-width: 2;
      stroke-linecap: butt;
      stroke-linejoin: miter;
    }
    .#{make_id("l3")} {
      stroke: black;
      stroke-width: 2;
      stroke-dasharray: 5,5;
      stroke-linecap: butt;
      stroke-linejoin: miter;
    }
    .#{make_id("l4")} {
      stroke: none;
      fill: #ffeeaa;
    }
    .#{make_id("t1")} {
      font-family: sans-serif;
      font-size: 16px;
      text-anchor: left;
      dominant-baseline: middle;
    }
    .#{make_id("t2")} {
      font-family: sans-serif;
      font-weight: bold;
      font-size: 16px;
      text-anchor: end;
      dominant-baseline: hanging;
    }
  CSS

  defs() do
    marker(
      id: make_id("arrow"),
      viewBox: "0, 0, 10, 10",
      refX: 9, refY: 5,
      markerWidth: 6, markerHeight: 6,
      orient: "auto-start-reverse"
    ) do
      path(d: "M 0 0 L 10 5 L 0 10 L 2.5 5 Z")
    end
  end

  path(
    class: make_id("l4"),
    d: "M 200 100 H 850 V 780 H 400 V 380 H 440 V 240 H 200 Z"
  )

  for component in components do
    circle(
      class: make_id("l1"),
      cx: component[:x],
      cy: component[:y],
      r: radius,
    )
    t = component[:text]
    if t
      text(
        class: make_id("t1"),
        x: component[:x] + 40, y: component[:y]
        ).add_text(t)
    end
  end

  for line in lines do
    c1 = components[line[:from]]
    c2 = components[line[:to]]
    dx = c2[:x] - c1[:x]
    dy = c2[:y] - c1[:y]
    dh = Math.sqrt(dx * dx + dy * dy)
    ax = dx * radius2 / dh
    ay = dy * radius2 / dh
    line(
      class: make_id("l2"),
      x1: c1[:x] + ax,
      y1: c1[:y] + ay,
      x2: c2[:x] - ax,
      y2: c2[:y] - ay,
      marker_end: "url(##{make_id("arrow")})"
    )
  end

  line(
    class: make_id("l3"),
    x1: 200,
    y1: 250,
    x2: 300,
    y2: 250,
  )
  text(
    class: make_id("t1"),
    x: 250,
    y: 270
  ).add_text("mock")
  line(
    class: make_id("l3"),
    x1: 310,
    y1: 250,
    x2: 410,
    y2: 250,
  )
  text(
    class: make_id("t1"),
    x: 360,
    y: 270
  ).add_text("fake")
  line(
    class: make_id("l3"),
    x1: 450,
    y1: 650,
    x2: 650,
    y2: 650,
  )
  text(
    class: make_id("t1"),
    x: 620,
    y: 670
  ).add_text("spy")

  text(
    class: make_id("t2"),
    x: 830,
    y: 120,
  ).add_text("area unit tested")

end

puts(image.render)

save_to_file("_includes/assets/2022-05-31-mock-fake-spy", "01-graph.svg", image.render)

