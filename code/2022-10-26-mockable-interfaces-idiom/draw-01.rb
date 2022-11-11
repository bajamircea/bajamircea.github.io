#!/usr/bin/env ruby

require_relative '../util/svg.rb'

margin = 10.0

line_width = 2 * margin

svg_width = 670.0
svg_height = 480.0

radius = 20
radius2 = 22

components = [
  { x: 350, y: 50, text: "waldo" },
  { x: 350, y: 150, text: "foo" },
  { x: 50, y: 350, text: "buzz" },
  { x: 200, y: 350, text: "bar" },
  { x: 500, y: 250, text: "std::string" },
  { x: 500, y: 400, text: "heap" },
]

lines = [
  { from: 0, to: 1 },
  { from: 1, to: 2 },
  { from: 1, to: 3 },
  { from: 1, to: 4 },
  { from: 4, to: 5 },
]

def make_id(offset)
  return "svg20221026-01-" + offset.to_s
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
    d: "M 100 100 H 650 V 450 H 380 V 240 H 100 Z"
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
    x1: 100,
    y1: 250,
    x2: 350,
    y2: 250,
  )
  text(
    class: make_id("t1"),
    x: 300,
    y: 270
  ).add_text("mocks")
  line(
    class: make_id("l3"),
    x1: 450,
    y1: 320,
    x2: 600,
    y2: 320,
  )
  text(
    class: make_id("t1"),
    x: 580,
    y: 340
  ).add_text("spy")

  text(
    class: make_id("t2"),
    x: 630,
    y: 120,
  ).add_text("area tested")

end

puts(image.render)

save_to_file("_includes/assets/2022-10-26-mockable-interfaces-idiom", "01-graph.svg", image.render)

