#!/usr/bin/env ruby

require_relative '../util/svg.rb'

scale = 10.0
margin = 10.0

three = 3.0 * scale
four = 4.0 * scale

sq_len = three + four

ax_pos = margin
ay_pos = margin

bx_pos = ax_pos + sq_len
by_pos = ay_pos

cx_pos = bx_pos
cy_pos = ay_pos + sq_len

dx_pos = ax_pos
dy_pos = cy_pos

onex_pos = ax_pos + four
oney_pos = ay_pos + four

alx_pos = onex_pos + (cx_pos - onex_pos) / 2.0
aly_pos = oney_pos + margin / 2.0

blx_pos = onex_pos - margin * 3.0 / 4.0
bly_pos = (ay_pos + oney_pos) / 2.0

clx_pos = alx_pos + margin / 4.0
cly_pos = bly_pos

ex_pos = bx_pos + 2 * margin
ey_pos = margin

fx_pos = ex_pos + sq_len
fy_pos = ey_pos

gx_pos = fx_pos
gy_pos = ey_pos + sq_len

hx_pos = ex_pos
hy_pos = gy_pos

twox_pos = ex_pos + four
twoy_pos = ey_pos + four

asqx_pos = (gx_pos + twox_pos) / 2.0 + 2.0
asqy_pos = (gy_pos + twoy_pos) / 2.0

bsqx_pos = (ex_pos + twox_pos) / 2.0 + 2.0
bsqy_pos = (ey_pos + twoy_pos) / 2.0

ix_pos = fx_pos + 2 * margin
iy_pos = margin
idot_pos = ix_pos + four

jx_pos = ix_pos + sq_len
jy_pos = iy_pos
jdot_pos = jy_pos + four

kx_pos = jx_pos
ky_pos = iy_pos + sq_len
kdot_pos = kx_pos - four

lx_pos = ix_pos
ly_pos = ky_pos
ldot_pos = ly_pos - four

csqx_pos = (ix_pos + kx_pos) / 2.0 + 2.0
csqy_pos = (iy_pos + ky_pos) / 2.0

svg_width = 6 * margin + 3 * sq_len
svg_height = 2 * margin + sq_len

def make_id(offset)
  return "svg20181107-03-" + offset.to_s
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
      fill: none;
      stroke: black;
    }
    .#{make_id("l2")} {
      fill: none;
      stroke: black;
      stroke-width: 0.5;
    }
    .#{make_id("f1")} {
      fill: #ffccff;
    }
    .#{make_id("f2")} {
      fill: #ccffcc;
    }
    .#{make_id("t0")} {
      font-family: serif;
      font-size: 8px;
      dominant-baseline: middle;
    }
    .#{make_id("t1")} {
      font-family: serif;
      font-size: 8px;
      text-anchor: end;
      dominant-baseline: middle;
    }
    .#{make_id("t2")} {
      font-family: serif;
      font-size: 4px;
      text-anchor: start;
    }
  CSS
  # first square
  path(
    class: make_id("f1"),
    d: "M #{onex_pos} #{by_pos} L #{bx_pos} #{by_pos} L #{bx_pos} #{oney_pos} Z",
    )
  path(
    class: make_id("f2"),
    d: "M #{onex_pos} #{by_pos} L #{bx_pos} #{oney_pos} L #{onex_pos} #{oney_pos} Z",
    )
  path(
    class: make_id("f1"),
    d: "M #{dx_pos} #{dy_pos} L #{onex_pos} #{oney_pos} L #{onex_pos} #{dy_pos} Z",
    )
  path(
    class: make_id("f2"),
    d: "M #{dx_pos} #{oney_pos} L #{onex_pos} #{oney_pos} L #{dx_pos} #{dy_pos} Z",
    )
  path(
    class: make_id("l2"),
    d: "M #{onex_pos} #{by_pos} L #{bx_pos} #{by_pos} L #{bx_pos} #{oney_pos} Z",
    )
  path(
    class: make_id("l2"),
    d: "M #{onex_pos} #{by_pos} L #{bx_pos} #{oney_pos} L #{onex_pos} #{oney_pos} Z",
    )
  path(
    class: make_id("l2"),
    d: "M #{dx_pos} #{dy_pos} L #{onex_pos} #{oney_pos} L #{onex_pos} #{dy_pos} Z",
    )
  path(
    class: make_id("l2"),
    d: "M #{dx_pos} #{oney_pos} L #{onex_pos} #{oney_pos} L #{dx_pos} #{dy_pos} Z",
    )
  path(
    class: make_id("l1"),
    d: "M #{ax_pos} #{ay_pos} L #{bx_pos} #{by_pos} L #{cx_pos} #{cy_pos} L #{dx_pos} #{dy_pos} Z",
    )
  text(
    class: make_id("t0"),
    x: alx_pos, y: aly_pos,
    ).add_text("a")
  text(
    class: make_id("t0"),
    x: blx_pos, y: bly_pos,
    ).add_text("b")
  text(
    class: make_id("t0"),
    x: clx_pos, y: cly_pos,
    ).add_text("c")

  # second square
  path(
    class: make_id("f1"),
    d: "M #{twox_pos} #{fy_pos} L #{fx_pos} #{fy_pos} L #{fx_pos} #{twoy_pos} Z",
    )
  path(
    class: make_id("f2"),
    d: "M #{twox_pos} #{fy_pos} L #{fx_pos} #{twoy_pos} L #{twox_pos} #{twoy_pos} Z",
    )
  path(
    class: make_id("f1"),
    d: "M #{hx_pos} #{hy_pos} L #{twox_pos} #{twoy_pos} L #{twox_pos} #{hy_pos} Z",
    )
  path(
    class: make_id("f2"),
    d: "M #{hx_pos} #{twoy_pos} L #{twox_pos} #{twoy_pos} L #{hx_pos} #{hy_pos} Z",
    )
  path(
    class: make_id("l2"),
    d: "M #{twox_pos} #{fy_pos} L #{fx_pos} #{fy_pos} L #{fx_pos} #{twoy_pos} Z",
    )
  path(
    class: make_id("l2"),
    d: "M #{twox_pos} #{fy_pos} L #{fx_pos} #{twoy_pos} L #{twox_pos} #{twoy_pos} Z",
    )
  path(
    class: make_id("l2"),
    d: "M #{hx_pos} #{hy_pos} L #{twox_pos} #{twoy_pos} L #{twox_pos} #{hy_pos} Z",
    )
  path(
    class: make_id("l2"),
    d: "M #{hx_pos} #{twoy_pos} L #{twox_pos} #{twoy_pos} L #{hx_pos} #{hy_pos} Z",
    )
  path(
    class: make_id("l1"),
    d: "M #{ex_pos} #{ey_pos} L #{fx_pos} #{fy_pos} L #{gx_pos} #{gy_pos} L #{hx_pos} #{hy_pos} Z",
    )
  text(
    class: make_id("t1"),
    x: bsqx_pos, y: bsqy_pos,
    ).add_text("b")
  text(
    class: make_id("t2"),
    x: bsqx_pos, y: bsqy_pos,
    ).add_text("2")
  text(
    class: make_id("t1"),
    x: asqx_pos, y: asqy_pos,
    ).add_text("a")
  text(
    class: make_id("t2"),
    x: asqx_pos, y: asqy_pos,
    ).add_text("2")

  # third square
  path(
    class: make_id("f1"),
    d: "M #{idot_pos} #{iy_pos} L #{jx_pos} #{jy_pos} L #{jx_pos} #{jdot_pos} Z",
    )
  path(
    class: make_id("f1"),
    d: "M #{jx_pos} #{jdot_pos} L #{kx_pos} #{ky_pos} L #{kdot_pos} #{ky_pos} Z",
    )
  path(
    class: make_id("f2"),
    d: "M #{kdot_pos} #{ky_pos} L #{lx_pos} #{ly_pos} L #{lx_pos} #{ldot_pos} Z",
    )
  path(
    class: make_id("f2"),
    d: "M #{lx_pos} #{ldot_pos} L #{ix_pos} #{iy_pos} L #{idot_pos} #{iy_pos} Z",
    )
  path(
    class: make_id("l2"),
    d: "M #{idot_pos} #{iy_pos} L #{jx_pos} #{jdot_pos} L #{kdot_pos} #{ky_pos} L #{lx_pos} #{ldot_pos} Z",
    )
  path(
    class: make_id("l1"),
    d: "M #{ix_pos} #{iy_pos} L #{jx_pos} #{jy_pos} L #{kx_pos} #{ky_pos} L #{lx_pos} #{ly_pos} Z",
    )
  text(
    class: make_id("t1"),
    x: csqx_pos, y: csqy_pos,
    ).add_text("c")
  text(
    class: make_id("t2"),
    x: csqx_pos, y: csqy_pos,
    ).add_text("2")
end

puts image.render

save_to_file "../../_includes/assets/2018-11-07-maths-history", "03-pythagoras.svg", image.render

