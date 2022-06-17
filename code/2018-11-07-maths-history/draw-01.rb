#!/usr/bin/env ruby

require_relative '../util/svg.rb'

scale = 10.0
margin = 10.0

three = 3.0 * scale
four = 4.0 * scale
five = 5.0 * scale

text_offset = 5.0

bx_pos = margin
by_pos = margin / 2

ax_pos = bx_pos
ay_pos = by_pos + three

cx_pos = ax_pos + four
cy_pos = ay_pos

svg_width = cx_pos + margin
svg_height = cy_pos + margin

def make_id(offset)
  return "svg20181107-01-" + offset.to_s
end

image = svg({
  id: make_id(1),
  width: "30%",
  viewBox: "0 0 #{svg_width} #{svg_height}",
  }) do

  style().add_text(<<-CSS)
    ##{make_id(1)} {
      border: 1px solid #e8e8e8;
    }
    .#{make_id("l1")} {
      stroke: black;
      stroke-linecap: butt;
      stroke-linejoin: miter;
      fill: none;
    }
    .#{make_id("t1")} {
      font-family: serif;
      font-size: 6px;
      text-anchor: middle;
      dominant-baseline: middle;
    }
  CSS

  path(
    class: make_id("l1"),
    d: "M #{ax_pos} #{ay_pos} L #{bx_pos} #{by_pos} L #{cx_pos} #{cy_pos} Z",
    )

  text(
    class: make_id("t1"),
    x: ax_pos - text_offset, y: (ay_pos + by_pos) / 2,
    ).add_text("3")

  text(
    class: make_id("t1"),
    x: (ax_pos + cx_pos) / 2, y: ay_pos + text_offset,
    ).add_text("4")

  text(
    class: make_id("t1"),
    x: (bx_pos + cx_pos) / 2 + text_offset , y: (by_pos + cy_pos) / 2 - text_offset,
    ).add_text("5")

end

puts(image.render)

save_to_file("_includes/assets/2018-11-07-maths-history", "01-three_four_five.svg", image.render)

