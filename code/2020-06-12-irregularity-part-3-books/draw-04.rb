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

x2_top = x1_top
y2_top = y1_bottom + 2 * margin
x2_bottom = x2_top + width
y2_bottom = y2_top + height

widthm = 2 * width + 2 * margin
heightm= 2 * height + 2 * margin

xm_top = x1_bottom + 2 * margin
ym_top = y1_top
xm_bottom = xm_top + widthm
ym_bottom = ym_top + heightm

radius = height / 2 - margin

segment = height / 4
offset = segment / 4

radiusm = heightm / 2 - margin

def make_id(offset)
  return "svg20200612-04-" + offset.to_s
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
    .#{make_id("l3")} {
      stroke: grey;
      stroke-linecap: butt;
      stroke-linejoin: miter;
      fill: none;
    }
    .#{make_id("l4")} {
      stroke: red;
      stroke-linecap: butt;
      stroke-linejoin: miter;
      stroke-width: 2px;
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

  # Postulate 5e

  path(
    class: make_id("l2"),
    d: "M #{x1_top} #{y1_top} L #{x1_bottom} #{y1_top} L #{x1_bottom}
    #{y1_bottom} L #{x1_top} #{y1_bottom} Z",
    )

  text(
    class: make_id("t1"),
    x: x1_top + text_offset, y: y1_top + text_offset,
    ).add_text("5e")

  path(
    class: make_id("l1"),
    d: "M #{x1_top + width / 4} #{y1_top + height / 2 + segment} L #{x1_top + 3 * width / 4} #{y1_top + height / 2 + segment}",
    )

  path(
    class: make_id("l1"),
    stroke_dasharray: "5,5",
    d: "M #{x1_top + width / 4} #{y1_top + height / 2 - segment + 2 * offset} A
    #{width * 0.55} #{width * 0.55} 0 0 1
    #{x1_top + 3 * width / 4} #{y1_top + height / 2 - segment + 2 * offset}",
    )
  circle(
    class: make_id("c1"),
    cx: x1_top + width / 2,
    cy: y1_top + height / 2 - segment + 0.5 * offset,
    r: 2
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
  path(
    class: make_id("l4"),
    d: "M #{x2_top} #{y2_top} L #{x2_bottom} #{y2_bottom}",
    )
  path(
    class: make_id("l4"),
    d: "M #{x2_bottom} #{y2_top} L #{x2_top} #{y2_bottom}",
    )

  # Elliptic

  path(
    class: make_id("l2"),
    d: "M #{xm_top} #{ym_top} L #{xm_bottom} #{ym_top} L #{xm_bottom}
    #{ym_bottom} L #{xm_top} #{ym_bottom} Z",
    )

  circle(
    class: make_id("l3"),
    cx: xm_top + widthm / 2,
    cy: ym_top + heightm / 2,
    r: radiusm
    )

  path(
    class: make_id("l2"),
    stroke_dasharray: "5,5",
    d: "M #{xm_top + widthm / 2 - radiusm} #{ym_top + heightm / 2} A
    #{radiusm} #{0.3 * radiusm} 0 0 1
    #{xm_top + widthm / 2 + radiusm} #{ym_top + heightm / 2}",
    )
  path(
    class: make_id("l1"),
    d: "M #{xm_top + widthm / 2 - radiusm} #{ym_top + heightm / 2} A
    #{radiusm} #{0.3 * radiusm} 0 0 0
    #{xm_top + widthm / 2 + radiusm} #{ym_top + heightm / 2}",
    )

  path(
    class: make_id("l2"),
    stroke_dasharray: "5,5",
    d: "M #{xm_top + widthm / 2} #{ym_top + heightm / 2 - radiusm} A
    #{0.2 * radiusm} #{radiusm} 0 0 1
    #{xm_top + widthm / 2} #{ym_top + heightm / 2 + radiusm}",
    )
  path(
    class: make_id("l1"),
    stroke_dasharray: "5,5",
    d: "M #{xm_top + widthm / 2} #{ym_top + heightm / 2 - radiusm} A
    #{0.2 * radiusm} #{radiusm} 0 0 0
    #{xm_top + widthm / 2} #{ym_top + heightm / 2 + radiusm}",
    )

  path(
    class: make_id("l1"),
    stroke_dasharray: "5,5",
    d: "M #{xm_top + widthm / 2} #{ym_top + heightm / 2 - radiusm} A
    #{0.7 * radiusm} #{radiusm} 0 0 1
    #{xm_top + widthm / 2} #{ym_top + heightm / 2 + radiusm}",
    )
  path(
    class: make_id("l2"),
    stroke_dasharray: "5,5",
    d: "M #{xm_top + widthm / 2} #{ym_top + heightm / 2 - radiusm} A
    #{0.7 * radiusm} #{radiusm} 0 0 0
    #{xm_top + widthm / 2} #{ym_top + heightm / 2 + radiusm}",
    )


end

puts(image.render)

save_to_file("_includes/assets/2020-06-12-irregularity-part-3-books", "04-elliptic.svg", image.render)

