#!/usr/bin/env ruby

require_relative '../util/svg.rb'

margin = 10.0

text_offset = 2 * margin

svg_width = 900.0
svg_height = 400.0

radius = 55
usage_width = 80

line_top_y = svg_height / 2 - radius
line_bottom_y = svg_height / 2 + radius
line_width = 20
half_width = line_width / 2
line_left_x = margin
line_right_x = svg_width - 2 * margin - usage_width - half_width - radius

step = ((line_right_x - line_left_x ) / 15).round(1)
text_y1 = line_top_y - 2 * line_width - 3 * text_offset
text_y2 = line_top_y - 2 * line_width - 2 * text_offset
text_y3 = line_top_y - 2 * line_width - text_offset

text_y4 = line_bottom_y + 2 * line_width + text_offset
text_y5 = line_bottom_y + 2 * line_width + 2 * text_offset
text_y6 = line_bottom_y + 2 * line_width + 3 * text_offset

def make_id(offset)
  return "svg20150402-01-" + offset.to_s
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
      stroke-width: 0;
      stroke-linecap: butt;
      stroke-linejoin: miter;
      fill: #8ea604;
    }
    .#{make_id("l2")} {
      stroke: black;
      stroke-width: 0;
      stroke-linecap: butt;
      stroke-linejoin: miter;
      fill: #ee6055;
    }
    .#{make_id("l3")} {
      stroke: black;
      stroke-width: 4;
      stroke-linecap: butt;
      stroke-linejoin: miter;
    }
    .#{make_id("t1")} {
      font-family: sans-serif;
      font-size: 16px;
      text-anchor: middle;
      dominant-baseline: middle;
    }
  CSS

  path(
    class: make_id("l1"),
    d: "M #{line_right_x} #{line_top_y - half_width}
    A #{radius + half_width} #{radius + half_width} 90 1 1
    #{line_right_x} #{line_bottom_y + half_width}
    L #{line_right_x - half_width} #{line_bottom_y}
    L #{line_right_x} #{line_bottom_y - half_width}
    A #{radius - half_width} #{radius - half_width} 90 1 0
    #{line_right_x} #{line_top_y + half_width}
    Z",
    )
  path(
    class: make_id("l1"),
    d: "M #{line_right_x - margin - half_width} #{line_bottom_y - half_width}
    V #{line_bottom_y + half_width}
    H #{line_left_x + half_width}
    L #{line_left_x} #{line_bottom_y}
    L #{line_left_x + half_width} #{line_bottom_y - half_width}
    Z",
    )

  for i in 1..7 do
    if i == 6
      next
    end
    middle_x = margin + (2 * i - 1) * step
    lower_y = line_bottom_y - half_width * 1.5
    path(
      class: make_id("l2"),
      d: "M #{middle_x} #{line_top_y - half_width}
      H #{middle_x + 2 * half_width}
      V #{lower_y - half_width}
      L #{middle_x + half_width} #{lower_y}
      L #{middle_x} #{lower_y - half_width}
      Z",
      transform: "rotate(30 #{middle_x} #{line_top_y + radius})",
      )
  end
  path(
    class: make_id("l1"),
    d: "M #{line_left_x} #{line_top_y - half_width}
    H #{line_right_x - margin - half_width}
    L #{line_right_x - margin} #{line_top_y}
    L #{line_right_x - margin - half_width} #{line_top_y + half_width}
    L #{line_left_x} #{line_top_y + half_width}
    Z",
    )

  text(
    class: make_id("t1"),
    x: 2 * step + margin, y: text_y2
    ).add_text("allocate")
  text(
    class: make_id("t1"),
    x: 2 * step + margin, y: text_y3
    ).add_text("memory")
  text(
    class: make_id("t1"),
    x: 4 * step + margin, y: text_y1
    ).add_text("construct")
  text(
    class: make_id("t1"),
    x: 4 * step + margin, y: text_y2
    ).add_text("base")
  text(
    class: make_id("t1"),
    x: 4 * step + margin, y: text_y3
    ).add_text("Base1")
  text(
    class: make_id("t1"),
    x: 6 * step + margin, y: text_y1
    ).add_text("construct")
  text(
    class: make_id("t1"),
    x: 6 * step + margin, y: text_y2
    ).add_text("base")
  text(
    class: make_id("t1"),
    x: 6 * step + margin, y: text_y3
    ).add_text("Base2")
  text(
    class: make_id("t1"),
    x: 8 * step + margin, y: text_y1
    ).add_text("construct")
  text(
    class: make_id("t1"),
    x: 8 * step + margin, y: text_y2
    ).add_text("member")
  text(
    class: make_id("t1"),
    x: 8 * step + margin, y: text_y3
    ).add_text("a")
  text(
    class: make_id("t1"),
    x: 10 * step + margin, y: text_y1
    ).add_text("construct")
  text(
    class: make_id("t1"),
    x: 10 * step + margin, y: text_y2
    ).add_text("member")
  text(
    class: make_id("t1"),
    x: 10 * step + margin, y: text_y3
    ).add_text("b")
  text(
    class: make_id("t1"),
    x: 12 * step + margin, y: text_y1
    ).add_text("init")
  text(
    class: make_id("t1"),
    x: 12 * step + margin, y: text_y2
    ).add_text("vtable")
  text(
    class: make_id("t1"),
    x: 12 * step + margin, y: text_y3
    ).add_text("pointer")
  text(
    class: make_id("t1"),
    x: 14 * step + margin, y: text_y1
    ).add_text("SomeClass")
  text(
    class: make_id("t1"),
    x: 14 * step + margin, y: text_y2
    ).add_text("constructor")
  text(
    class: make_id("t1"),
    x: 14 * step + margin, y: text_y3
    ).add_text("body")
  for i in 1..7 do
    middle_x = margin + 2 * i * step
    line(
      class: make_id("l3"),
      x1: middle_x,
      y1: text_y3 + margin,
      x2: middle_x,
      y2: line_top_y,
      )
  end
  text(
    class: make_id("t1"),
    x: svg_width - usage_width / 2 - margin, y: svg_height / 2
    ).add_text("usage")
  text(
    class: make_id("t1"),
    x: 2 * step + margin, y: text_y4
    ).add_text("deallocate")
  text(
    class: make_id("t1"),
    x: 2 * step + margin, y: text_y5
    ).add_text("memory")
  text(
    class: make_id("t1"),
    x: 4 * step + margin, y: text_y4
    ).add_text("destruct")
  text(
    class: make_id("t1"),
    x: 4 * step + margin, y: text_y5
    ).add_text("base")
  text(
    class: make_id("t1"),
    x: 4 * step + margin, y: text_y6
    ).add_text("Base1")
  text(
    class: make_id("t1"),
    x: 6 * step + margin, y: text_y4
    ).add_text("destruct")
  text(
    class: make_id("t1"),
    x: 6 * step + margin, y: text_y5
    ).add_text("base")
  text(
    class: make_id("t1"),
    x: 6 * step + margin, y: text_y6
    ).add_text("Base2")
  text(
    class: make_id("t1"),
    x: 8 * step + margin, y: text_y4
    ).add_text("destruct")
  text(
    class: make_id("t1"),
    x: 8 * step + margin, y: text_y5
    ).add_text("member")
  text(
    class: make_id("t1"),
    x: 8 * step + margin, y: text_y6
    ).add_text("a")
  text(
    class: make_id("t1"),
    x: 10 * step + margin, y: text_y4
    ).add_text("destruct")
  text(
    class: make_id("t1"),
    x: 10 * step + margin, y: text_y5
    ).add_text("member")
  text(
    class: make_id("t1"),
    x: 10 * step + margin, y: text_y6
    ).add_text("b")
  text(
    class: make_id("t1"),
    x: 12 * step + margin, y: text_y4
    ).add_text("revert")
  text(
    class: make_id("t1"),
    x: 12 * step + margin, y: text_y5
    ).add_text("vtable")
  text(
    class: make_id("t1"),
    x: 12 * step + margin, y: text_y6
    ).add_text("pointer")
  text(
    class: make_id("t1"),
    x: 14 * step + margin, y: text_y4
    ).add_text("SomeClass")
  text(
    class: make_id("t1"),
    x: 14 * step + margin, y: text_y5
    ).add_text("destructor")
  text(
    class: make_id("t1"),
    x: 14 * step + margin, y: text_y6
    ).add_text("body")
  for i in 1..7 do
    middle_x = margin + 2 * i * step
    line(
      class: make_id("l3"),
      x1: middle_x,
      y1: text_y4 - margin,
      x2: middle_x,
      y2: line_bottom_y,
      )
  end
end

puts(image.render)

save_to_file("_includes/assets/2015-04-02-class-lifetime", "01-lifetime.svg", image.render)

