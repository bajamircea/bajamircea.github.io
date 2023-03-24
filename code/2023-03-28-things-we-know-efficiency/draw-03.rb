#!/usr/bin/env ruby

require_relative '../util/svg.rb'

margin = 10.0

cell_width = 60.0
cell_height = 30.0

svg_width = 2 * margin + 10 * cell_width
svg_height = 300.0

text_height = 16

text_top_y = margin + text_height

seq_x = margin
seq_y = margin

def make_id(offset)
  return "svg20230328-03-" + offset.to_s
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
      stroke-width: 3;
      stroke-linecap: butt;
      stroke-linejoin: miter;
      fill: #caf0f8;
    }
    .#{make_id("l3")} {
      stroke: black;
      stroke-width: 3;
      stroke-linecap: butt;
      stroke-linejoin: miter;
      fill:  #90e0ef;
    }
    .#{make_id("l4")} {
      stroke: black;
      stroke-width: 3;
      stroke-linecap: butt;
      stroke-linejoin: miter;
      fill:  #00b4d8;
    }
    .#{make_id("l5")} {
      stroke: black;
      stroke-width: 3;
      stroke-linecap: butt;
      stroke-linejoin: miter;
      fill:  #0077b6;
    }
    .#{make_id("t1")} {
      font-family: sans-serif;
      font-size: 16px;
      dominant-baseline: middle;
      text-anchor: middle;
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

  texts = ["Infinite", "Terminating", "Circular", "ρ-shaped"]

  offset_y = 2 * (cell_height + margin/2)

  for j in 0..3
    y_start = seq_y + j * offset_y
    for i in 0..3
      x_start = seq_x + i * 2 * cell_width
      if i != 0
        line(
          class: make_id("l1"),
          x1: x_start - cell_width,
          y1: y_start + cell_height / 2,
          x2: x_start - margin,
          y2: y_start + cell_height / 2,
          marker_end: "url(##{make_id("arrow")})"
          )
      end
      class_id = "l" + (i + 2).to_s
      rect(
        class: make_id(class_id),
        x: x_start,
        y: y_start,
        width: cell_width,
        height: cell_height
        )
    end
    text(
      class: make_id("t1"),
      x: seq_x + cell_width * 9, y: y_start + cell_height/2
      ).add_text(texts[j])
  end

  line(
    class: make_id("l1"),
    x1: seq_x + 7 * cell_width,
    y1: seq_y + cell_height/2,
    x2: seq_x + 8 * cell_width,
    y2: seq_y + cell_height/2,
    stroke_dasharray: "5,5",
    )

  rad = 10

  path_d = "M #{seq_x + 7 * cell_width} #{seq_y + 2 * offset_y + cell_height/2}"
  path_d +=" l #{cell_width/2} 0"
  path_d +=" q #{rad} 0 #{rad} #{rad}"
  path_d +=" l 0 #{cell_height - rad}"
  path_d +=" q 0 #{rad} -#{rad} #{rad}"
  path_d +=" l -#{7 * cell_width - rad} 0"
  path_d +=" q -#{rad} 0 -#{rad} -#{rad}"
  path_d +=" l 0 -#{cell_height*0.2}"
  path(
    class: make_id("l1"),
    d: path_d,
    marker_end: "url(##{make_id("arrow")})"
    )

  path_d = "M #{seq_x + 7 * cell_width} #{seq_y + 3 * offset_y + cell_height/2}"
  path_d +=" l #{cell_width/2} 0"
  path_d +=" q #{rad} 0 #{rad} #{rad}"
  path_d +=" l 0 #{cell_height - rad}"
  path_d +=" q 0 #{rad} -#{rad} #{rad}"
  path_d +=" l -#{5 * cell_width - rad} 0"
  path_d +=" q -#{rad} 0 -#{rad} -#{rad}"
  path_d +=" l 0 -#{cell_height*0.2}"
  path(
    class: make_id("l1"),
    d: path_d,
    marker_end: "url(##{make_id("arrow")})"
    )
end

puts(image.render)

save_to_file("_includes/assets/2023-03-28-things-we-know-efficiency", "03-orbits.svg", image.render)

