#!/usr/bin/env ruby

require_relative '../util/svg.rb'

margin = 10.0

text_offset = 2 * margin

svg_width = 900.0
svg_height = 400.0

width = svg_width / 3  - 2 * margin
height = svg_height / 2  - 2 * margin

x1_top = margin
y1_top = margin
x1_bottom = x1_top + width
y1_bottom = y1_top + height

x2_top = x1_bottom + 2 * margin
y2_top = y1_top
x2_bottom = x2_top + width
y2_bottom = y2_top + height

x3_top = x2_bottom + 2 * margin
y3_top = y2_top
x3_bottom = x3_top + width
y3_bottom = y3_top + height

radius = height / 2 - margin

x4_top = x1_top
y4_top = y1_bottom + 2 * margin
x4_bottom = x4_top + width
y4_bottom = y4_top + height

segment = height / 4
offset = segment / 4

x5_top = x4_bottom + 2 * margin
y5_top = y4_top
x5_bottom = x5_top + width
y5_bottom = y5_top + height

x6_top = x5_bottom + 2 * margin
y6_top = y5_top
x6_bottom = x6_top + width
y6_bottom = y6_top + height



def make_id(offset)
  return "svg20200612-01-" + offset.to_s
end

image = svg({
  id: make_id(1),
  width: "100%",
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
    .#{make_id("l2")} {
      stroke: lightgrey;
      stroke-linecap: butt;
      stroke-linejoin: miter;
      fill: none;
    }
    .#{make_id("t1")} {
      font-family: serif;
      font-size: 20px;
      text-anchor: middle;
      dominant-baseline: middle;
    }
    .#{make_id("c1")} {
      stroke: black;
    }
  CSS

  # Postulate 1

  path(
    class: make_id("l2"),
    d: "M #{x1_top} #{y1_top} L #{x1_bottom} #{y1_top} L #{x1_bottom}
    #{y1_bottom} L #{x1_top} #{y1_bottom} Z",
    )

  text(
    class: make_id("t1"),
    x: x1_top + text_offset, y: y1_top + text_offset,
    ).add_text("1")

  path(
    class: make_id("l1"),
    d: "M #{x1_top + width / 5} #{y1_top + height / 2} L #{x1_bottom - width / 5} #{y1_top + height / 2}",
    )


  # Postulate 2

  path(
    class: make_id("l2"),
    d: "M #{x2_top} #{y2_top} L #{x2_bottom} #{y2_top} L #{x2_bottom}
    #{y2_bottom} L #{x2_top} #{y2_bottom} Z",
    )

  text(
    class: make_id("t1"),
    x: x2_top + text_offset, y: y2_top + text_offset,
    ).add_text("2")

  path(
    class: make_id("l1"),
    d: "M #{x2_top + width / 4} #{y2_top + height / 2} L #{x2_bottom - width / 4} #{y2_top + height / 2}",
    )
  path(
    class: make_id("l1"),
    stroke_dasharray: "5,5",
    d: "M #{x2_top + width / 8} #{y2_top + height / 2} L #{x2_top + width / 4} #{y2_top + height / 2}",
    )
  path(
    class: make_id("l1"),
    stroke_dasharray: "5,5",
    d: "M #{x2_bottom - width / 4} #{y2_top + height / 2} L #{x2_bottom - width / 8} #{y2_top + height / 2}",
    )


  # Postulate 3

  path(
    class: make_id("l2"),
    d: "M #{x3_top} #{y3_top} L #{x3_bottom} #{y3_top} L #{x3_bottom}
    #{y3_bottom} L #{x3_top} #{y3_bottom} Z",
    )

  text(
    class: make_id("t1"),
    x: x3_top + text_offset, y: y3_top + text_offset,
    ).add_text("3")

  circle(
    class: make_id("l1"),
    cx: x3_top + width / 2,
    cy: y3_top + height / 2,
    r: radius
    )
  path(
    class: make_id("l2"),
    d: "M #{x3_top + width / 2} #{y3_top + height / 2} L #{x3_top + width / 2 + radius} #{y3_top + height / 2}",
    )


  # Postulate 4

  path(
    class: make_id("l2"),
    d: "M #{x4_top} #{y4_top} L #{x4_bottom} #{y4_top} L #{x4_bottom}
    #{y4_bottom} L #{x4_top} #{y4_bottom} Z",
    )

  text(
    class: make_id("t1"),
    x: x4_top + text_offset, y: y4_top + text_offset,
    ).add_text("4")

  path(
    class: make_id("l1"),
    d: "M #{x4_top + width / 4} #{y4_top + height / 2 - segment} L #{x4_top + width / 4}
    #{y4_top + height / 2} L #{x4_top + width / 4 + segment} #{y4_top + height / 2}",
    )
  path(
    class: make_id("l1"),
    d: "M #{x4_top + width / 2 + offset} #{y4_top + height / 2 - segment} L
    #{x4_top + width / 2 + segment + offset} #{y4_top + height / 2 - segment + offset}
    L #{x4_top + width / 2 + segment} #{y4_top + height / 2 + offset}",
    )

  # Postulate 5

  path(
    class: make_id("l2"),
    d: "M #{x5_top} #{y5_top} L #{x5_bottom} #{y5_top} L #{x5_bottom}
    #{y5_bottom} L #{x5_top} #{y5_bottom} Z",
    )

  text(
    class: make_id("t1"),
    x: x5_top + text_offset, y: y5_top + text_offset,
    ).add_text("5")

  path(
    class: make_id("l1"),
    d: "M #{x5_top + width / 4} #{y5_top + height / 2 + segment} L #{x5_top + 3 * width / 4} #{y5_top + height / 2 + segment}",
    )
  path(
    class: make_id("l1"),
    stroke_dasharray: "5,5",
    d: "M #{x5_top + 3 * width / 4} #{y5_top + height / 2 + segment} L #{x5_top + 7 * width / 8} #{y5_top + height / 2 + segment}",
    )

  path(
    class: make_id("l1"),
    d: "M #{x5_top + width / 4} #{y5_top + height / 2 - segment - offset} L
    #{x5_top + 3 * width / 4} #{y5_top + height / 2 - segment + offset}",
    )
  path(
    class: make_id("l1"),
    stroke_dasharray: "5,5",
    d: "M #{x5_top + 3 * width / 4} #{y5_top + height / 2 - segment + offset} L
    #{x5_top + 7 * width / 8} #{y5_top + height / 2 - segment + offset + offset / 2}",
    )

  path(
    class: make_id("l1"),
    d: "M #{x5_top + width / 2} #{y5_top + height / 2 - segment - offset} L
    #{x5_top + width / 2} #{y5_top + height / 2 + segment + offset}",
    )

  # Postulate 5p

  path(
    class: make_id("l2"),
    d: "M #{x6_top} #{y6_top} L #{x6_bottom} #{y6_top} L #{x6_bottom}
    #{y6_bottom} L #{x6_top} #{y6_bottom} Z",
    )

  text(
    class: make_id("t1"),
    x: x6_top + text_offset, y: y6_top + text_offset,
    ).add_text("5p")

  path(
    class: make_id("l1"),
    d: "M #{x6_top + width / 4} #{y6_top + height / 2 + segment} L #{x6_top + 3 * width / 4} #{y6_top + height / 2 + segment}",
    )

  path(
    class: make_id("l1"),
    stroke_dasharray: "5,5",
    d: "M #{x6_top + width / 4} #{y6_top + height / 2 - segment} L
    #{x6_top + 3 * width / 4} #{y6_top + height / 2 - segment}",
    )
  circle(
    class: make_id("c1"),
    cx: x6_top + width / 2,
    cy: y6_top + height / 2 - segment,
    r: 2
    )

end

puts(image.render)

save_to_file("_includes/assets/2020-06-12-irregularity-part-3-books", "01-postulates.svg", image.render)

