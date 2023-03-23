#!/usr/bin/env ruby

require_relative '../util/svg.rb'

margin = 10.0

cell_width = 100.0
cell_height = 30.0

svg_width = 2 * margin + 6 * cell_width
svg_height = 190.0

radius = 55

text_height = 16

text_top_y = margin + text_height

seq_x = margin
seq_y = text_top_y + 3 * margin

cells = [false, true, false, true, false, true]

seq_width = cells.length() * cell_width

def make_id(offset)
  return "svg20230328-02-" + offset.to_s
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
      stroke: black;
      stroke-width: 3;
      stroke-linecap: butt;
      stroke-linejoin: miter;
      fill: none;
    }
    .#{make_id("l2")} {
      stroke: black;
      stroke-width: 0;
      stroke-linecap: butt;
      stroke-linejoin: miter;
      fill: #5591c9;
    }
    .#{make_id("l3")} {
      stroke: black;
      stroke-width: 0;
      stroke-linecap: butt;
      stroke-linejoin: miter;
      fill: #ff5c61;
    }
    .#{make_id("t1")} {
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


  cells.each_with_index do |color, index|
    class_id = color ? "l3" : "l2"
    x_start = seq_x + index * cell_width
    rect(
      class: make_id(class_id),
      x: x_start,
      y: seq_y,
      width: cell_width,
      height: cell_height
      )
    if index != 0
      line(
        class: make_id("l1"),
        x1: x_start,
        x2: x_start,
        y1: seq_y,
        y2: seq_y + cell_height
        )
    end
  end

  rect(
    class: make_id("l1"),
    x: seq_x,
    y: seq_y,
    width: seq_width,
    height: cell_height
    )

  line(
    class: make_id("l1"),
    x1: seq_x,
    y1: text_top_y,
    x2: seq_x,
    y2: seq_y - margin,
    marker_end: "url(##{make_id("arrow")})"
    )
  text(
    class: make_id("t1"),
    style: "text-anchor: start",
    x: seq_x + margin, y: text_top_y
    ).add_text("first")

  line(
    class: make_id("l1"),
    x1: seq_x + seq_width,
    y1: text_top_y,
    x2: seq_x + seq_width,
    y2: seq_y - margin,
    marker_end: "url(##{make_id("arrow")})"
    )
  text(
    class: make_id("t1"),
    style: "text-anchor: end",
    x: seq_x + seq_width - margin, y: text_top_y
    ).add_text("last")

  line(
    class: make_id("l1"),
    x1: seq_x + 2 * cell_width,
    y1: text_top_y,
    x2: seq_x + 2 * cell_width,
    y2: seq_y - margin,
    marker_end: "url(##{make_id("arrow")})"
    )
  text(
    class: make_id("t1"),
    style: "text-anchor: start",
    x: seq_x + 2 * cell_width + margin, y: text_top_y
    ).add_text("middle")

  line_y = seq_y + cell_height
  for i in [0, 1]
    line_y += 2 * margin
    line(
      class: make_id("l1"),
      x1: seq_x + cell_width * i + cell_width/2,
      y1: line_y,
      x2: seq_x + cell_width * (4 + i) + cell_width/2 - margin,
      y2: line_y,
      marker_end: "url(##{make_id("arrow")})"
      )
    line_y += 2 * margin
    line(
      class: make_id("l1"),
      x1: seq_x + cell_width * (4 + i) + cell_width/2,
      y1: line_y,
      x2: seq_x + cell_width * (2 + i) + cell_width/2 + margin,
      y2: line_y,
      marker_end: "url(##{make_id("arrow")})"
      )
    line(
      class: make_id("l1"),
      x1: seq_x + cell_width * (2 + i) + cell_width/2,
      y1: line_y,
      x2: seq_x + cell_width * i + cell_width/2 + margin,
      y2: line_y,
      marker_end: "url(##{make_id("arrow")})"
      )
      line_y += margin
  end

  text(
    class: make_id("t1"),
    style: "text-anchor: start",
    x: seq_x + 4 * cell_width + cell_width/2 + margin, y: seq_y + cell_height + 3 * margin
    ).add_text("cycle 1")
  text(
    class: make_id("t1"),
    style: "text-anchor: end",
    x: seq_x + cell_width + cell_width/2 - margin, y: seq_y + cell_height + 8 * margin
    ).add_text("cycle 2")

  text(
    class: make_id("t1"),
    style: "text-anchor: middle",
    x: seq_x + 4 * cell_width, y: text_top_y
    ).add_text("gcd(2, 6) = 2")
end

puts(image.render)

save_to_file("_includes/assets/2023-03-28-things-we-know-efficiency", "02-rotate.svg", image.render)

