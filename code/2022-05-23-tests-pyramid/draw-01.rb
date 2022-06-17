#!/usr/bin/env ruby

require_relative '../util/svg.rb'

margin = 10.0

text_offset = 2 * margin

svg_width = 900.0
svg_height = 400.0

base_width = (svg_width - 6 * margin) * 0.4
text_width = (svg_width - base_width - 2 * margin) / 2

base_start_x = text_width + margin
base_end_x = base_start_x + base_width
base_y = svg_height - margin

top_x = (base_start_x + base_end_x) / 2
top_y = margin

fraction1 = 1 / 3.0
line1_len = (base_end_x - base_start_x) * fraction1
line1_start_x = top_x - line1_len / 2.0
line1_end_x = top_x + line1_len / 2.0
line1_y = top_y + (base_y - top_y) * fraction1

fraction2 = 2 / 3.0
line2_len = (base_end_x - base_start_x) * fraction2
line2_start_x = top_x - line2_len / 2.0
line2_end_x = top_x + line2_len / 2.0
line2_y = top_y + (base_y - top_y) * fraction2

text_line = 10

texta_x = text_width / 2
textb_x = base_end_x + text_width / 2
text1_y = (line1_y + top_y) / 2 + text_line
text2_y = (line2_y + line1_y) / 2 + text_line
text3_y = (base_y + line2_y) / 2 + text_line

def make_id(offset)
  return "svg20220522-01-" + offset.to_s
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
      stroke-width: 4;
      stroke-linecap: butt;
      stroke-linejoin: miter;
      fill: #6ac3d9;
    }
    .#{make_id("l2")} {
      stroke: black;
      stroke-width: 4;
      stroke-linecap: butt;
      stroke-linejoin: miter;
      fill: #4cabc3;
    }
    .#{make_id("l3")} {
      stroke: black;
      stroke-width: 4;
      stroke-linecap: butt;
      stroke-linejoin: miter;
      fill: #2d93ad;
    }
    .#{make_id("t1")} {
      font-family: sans-serif;
      font-size: 20px;
      font-weight: bold;
      text-anchor: middle;
      dominant-baseline: middle;
    }
  CSS

  path(
    class: make_id("l1"),
    d: "M #{top_x} #{top_y} L #{line1_end_x} #{line1_y}
    L  #{line1_start_x} #{line1_y} Z",
    )
  path(
    class: make_id("l2"),
    d: "M #{line1_start_x} #{line1_y} L #{line1_end_x} #{line1_y}
    L #{line2_end_x} #{line2_y} L #{line2_start_x} #{line2_y} Z",
    )
  path(
    class: make_id("l3"),
    d: "M #{line2_start_x} #{line2_y} L #{line2_end_x} #{line2_y}
    L #{base_end_x} #{base_y} L #{base_start_x} #{base_y} Z",
    )

  text(
    class: make_id("t1"),
    x: texta_x, y: text1_y
    ).add_text("system tests")
  text(
    class: make_id("t1"),
    x: texta_x, y: text2_y
    ).add_text("component tests")
  text(
    class: make_id("t1"),
    x: texta_x, y: text3_y
    ).add_text("unit tests")

  text(
    class: make_id("t1"),
    x: textb_x, y: text1_y
    ).add_text("few")
  text(
    class: make_id("t1"),
    x: textb_x, y: text2_y
    ).add_text("some")
  text(
    class: make_id("t1"),
    x: textb_x, y: text3_y
    ).add_text("lots")

end

puts(image.render)

save_to_file("_includes/assets/2022-05-23-tests-pyramid", "01-pyramid.svg", image.render)

