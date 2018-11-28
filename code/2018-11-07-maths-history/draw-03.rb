#!/usr/bin/env ruby

require_relative '../util/svg.rb'

scale = 10.0
margin = 10.0

three = 3.0 * scale
four = 4.0 * scale
five = 5.0 * scale

text_offset = 5.0

am_len = three * four / five
bm_len = three * three / five
mc_len = four * four / five

ax_pos = margin + bm_len + am_len
ay_pos = margin + mc_len

bx_pos = ax_pos - bm_len
by_pos = ay_pos + am_len

cx_pos = bx_pos + five
cy_pos = by_pos

dx_pos = bx_pos
dy_pos = by_pos + five

ex_pos = cx_pos
ey_pos = cy_pos + five

fx_pos = bx_pos - am_len
fy_pos = by_pos - bm_len

gx_pos = ax_pos - am_len
gy_pos = ay_pos - bm_len

hx_pos = ax_pos + am_len
hy_pos = ay_pos - mc_len

kx_pos = cx_pos + am_len
ky_pos = cy_pos - mc_len

lx_pos = ax_pos
ly_pos = ay_pos + am_len + five

mx_pos = ax_pos
my_pos = ay_pos + am_len

svg_width = 2 * margin + am_len + five + am_len
svg_height = 2 * margin + mc_len + am_len + five

def make_id(offset)
  return "svg20181107-03-" + offset.to_s
end

image = svg({
  id: make_id(1),
  width: "50%",
  viewBox: "0 0 #{svg_width} #{svg_height}",
  }) do

  style().add_text(<<-CSS)
    ##{make_id(1)} {
      border: 1px solid #e8e8e8;
    }
    .#{make_id("l1")} {
      stroke: black;
      stroke-linecap: butt;
      stroke-linejoin: bevel;
      fill: none;
    }
    .#{make_id("l2")} {
      stroke: black;
      stroke-linecap: butt;
      stroke-linejoin: miter;
      fill: none;
    }
    .#{make_id("l3")} {
      stroke: black;
      stroke-width: 0.5;
      stroke-linecap: round;
      stroke-linejoin: round;
      fill: none;
    }
    .#{make_id("f1")} {
      fill: #ffddee;
    }
    .#{make_id("f2")} {
      fill: #ddddff;
    }
    .#{make_id("t1")} {
      font-family: serif;
      font-size: 6px;
      text-anchor: middle;
      dominant-baseline: middle;
    }
  CSS

  path(
    class: make_id("f1"),
    d: "M #{ax_pos} #{ay_pos} L #{bx_pos} #{by_pos} L #{fx_pos} #{fy_pos} L #{gx_pos} #{gy_pos} Z",
    )

  path(
    class: make_id("f1"),
    d: "M #{bx_pos} #{by_pos} L #{mx_pos} #{my_pos} L #{lx_pos} #{ly_pos} L #{dx_pos} #{dy_pos} Z",
    )

  path(
    class: make_id("f2"),
    d: "M #{ax_pos} #{ay_pos} L #{cx_pos} #{cy_pos} L #{kx_pos} #{ky_pos} L #{hx_pos} #{hy_pos} Z",
    )

  path(
    class: make_id("f2"),
    d: "M #{cx_pos} #{cy_pos} L #{mx_pos} #{my_pos} L #{lx_pos} #{ly_pos} L #{ex_pos} #{ey_pos} Z",
    )

  path(
    class: make_id("l1"),
    d: "M #{ax_pos} #{ay_pos} L #{bx_pos} #{by_pos} L #{cx_pos} #{cy_pos} Z",
    )

  path(
    class: make_id("l2"),
    d: "M #{ax_pos} #{ay_pos} L #{bx_pos} #{by_pos} L #{fx_pos} #{fy_pos} L #{gx_pos} #{gy_pos} Z",
    )

  path(
    class: make_id("l2"),
    d: "M #{ax_pos} #{ay_pos} L #{cx_pos} #{cy_pos} L #{kx_pos} #{ky_pos} L #{hx_pos} #{hy_pos} Z",
    )

  path(
    class: make_id("l2"),
    d: "M #{bx_pos} #{by_pos} L #{cx_pos} #{cy_pos} L #{ex_pos} #{ey_pos} L #{dx_pos} #{dy_pos} Z",
    )

  path(
    class: make_id("l3"),
    d: "M #{ax_pos} #{ay_pos} L #{lx_pos} #{ly_pos}",
    )

  path(
    class: make_id("l3"),
    d: "M #{ax_pos} #{ay_pos} L #{dx_pos} #{dy_pos}",
    )

  path(
    class: make_id("l3"),
    d: "M #{cx_pos} #{cy_pos} L #{fx_pos} #{fy_pos}",
    )

  text(
    class: make_id("t1"),
    x: ax_pos - text_offset * 0.1, y: ay_pos - text_offset * 1.4,
    ).add_text("A")

  text(
    class: make_id("t1"),
    x: bx_pos - text_offset, y: by_pos + text_offset,
    ).add_text("B")

  text(
    class: make_id("t1"),
    x: cx_pos + text_offset, y: cy_pos + text_offset,
    ).add_text("C")

  text(
    class: make_id("t1"),
    x: dx_pos - text_offset, y: dy_pos + text_offset,
    ).add_text("D")

  text(
    class: make_id("t1"),
    x: ex_pos + text_offset, y: ey_pos + text_offset,
    ).add_text("E")

  text(
    class: make_id("t1"),
    x: fx_pos - text_offset, y: fy_pos,
    ).add_text("F")

  text(
    class: make_id("t1"),
    x: gx_pos, y: gy_pos - text_offset,
    ).add_text("G")

  text(
    class: make_id("t1"),
    x: hx_pos, y: hy_pos - text_offset,
    ).add_text("H")

  text(
    class: make_id("t1"),
    x: kx_pos + text_offset, y: ky_pos,
    ).add_text("K")

  text(
    class: make_id("t1"),
    x: lx_pos, y: ly_pos + text_offset,
    ).add_text("L")

  text(
    class: make_id("t1"),
    x: mx_pos + text_offset, y: my_pos + text_offset,
    ).add_text("M")

end

puts image.render

save_to_file "../../_includes/assets/2018-11-07-maths-history", "03-euclid.svg", image.render

