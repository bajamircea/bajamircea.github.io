#!/usr/bin/env ruby

require_relative '../util/svg.rb'

margin = 10.0

line_width = 2 * margin

svg_width = 900.0
svg_height = 630.0

width = (svg_width - 3 * margin) / 2
height = (svg_height - 5 * margin) / 2

radius = (height - 7 * line_width) / 2

offset_y = radius * 0.86

arch_x1 = margin + width / 2
arch_x2 = arch_x1 + margin + width
arch_y1 = margin + 3 * line_width + radius - offset_y
arch_y2 = arch_y1 + 2 * offset_y
arch_y3 = arch_y1 + 3 * margin + height
arch_y4 = arch_y3 + 2 * offset_y

offset = radius * 0.5

circle_x1 = margin + width / 2 - offset
circle_x2 = circle_x1 + 2 * offset
circle_x3 = circle_x1 + margin + width
circle_x4 = circle_x3 + 2 * offset

circle_y1 = margin + 3 * line_width + radius
circle_y2 = circle_y1 + 3 * margin + height

text_x1 = circle_x1 - line_width
text_x2 = circle_x2 + line_width
text_x3 = circle_x3 - line_width
text_x4 = circle_x4 + line_width
text_y1 = circle_y1 - radius - line_width * 1.5
text_y2 = text_y1 - line_width / 2
text_y3 = text_y2 + line_width
text_y4 = circle_y1 + radius + line_width * 3
text_y5 = circle_y2 - radius - line_width * 1.5
text_y6 = text_y5 - line_width / 2
text_y7 = text_y6 + line_width
text_y8 = circle_y2 + radius + line_width * 3

def make_id(offset)
  return "svg20160407-01-" + offset.to_s
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
      stroke: #8f0063;
      stroke-width: 2;
      stroke-linecap: butt;
      stroke-linejoin: miter;
      fill: none;
    }
    .#{make_id("l2")} {
      stroke: #f1e0ec;
      stroke-width: 2;
      stroke-linecap: butt;
      stroke-linejoin: miter;
      fill: none;
    }
    .#{make_id("l3")} {
      stroke: black;
      stroke-width: 2;
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

  path(
    class: make_id("l1"),
    d: "M #{arch_x1} #{arch_y1}
        A #{radius} #{radius} 90 0 0
        #{arch_x1} #{arch_y2}",
    )
  path(
    class: make_id("l1"),
    d: "M #{arch_x1} #{arch_y1}
        A #{radius} #{radius} 90 1 1
        #{arch_x1} #{arch_y2}",
    )
  path(
    class: make_id("l1"),
    d: "M #{arch_x1} #{arch_y1}
        A #{radius} #{radius} 90 0 1
        #{arch_x1} #{arch_y2}",
    )
  path(
    class: make_id("l1"),
    d: "M #{arch_x1} #{arch_y1}
        A #{radius} #{radius} 90 1 0
        #{arch_x1} #{arch_y2}",
    )

  path(
    class: make_id("l2"),
    d: "M #{arch_x2} #{arch_y1}
        A #{radius} #{radius} 90 0 1
        #{arch_x2} #{arch_y2}",
    )
  path(
    class: make_id("l1"),
    d: "M #{arch_x2} #{arch_y1}
        A #{radius} #{radius} 90 0 0
        #{arch_x2} #{arch_y2}",
    )
  path(
    class: make_id("l1"),
    d: "M #{arch_x2} #{arch_y1}
        A #{radius} #{radius} 90 1 1
        #{arch_x2} #{arch_y2}",
    )
  path(
    class: make_id("l1"),
    d: "M #{arch_x2} #{arch_y1}
        A #{radius} #{radius} 90 1 0
        #{arch_x2} #{arch_y2}",
    )

  path(
    class: make_id("l2"),
    d: "M #{arch_x1} #{arch_y3}
        A #{radius} #{radius} 90 0 0
        #{arch_x1} #{arch_y4}",
    )
  path(
    class: make_id("l1"),
    d: "M #{arch_x1} #{arch_y3}
        A #{radius} #{radius} 90 1 1
        #{arch_x1} #{arch_y4}",
    )
  path(
    class: make_id("l1"),
    d: "M #{arch_x1} #{arch_y3}
        A #{radius} #{radius} 90 0 1
        #{arch_x1} #{arch_y4}",
    )
  path(
    class: make_id("l1"),
    d: "M #{arch_x1} #{arch_y3}
        A #{radius} #{radius} 90 1 0
        #{arch_x1} #{arch_y4}",
    )

  path(
    class: make_id("l2"),
    d: "M #{arch_x2} #{arch_y3}
        A #{radius} #{radius} 90 1 1
        #{arch_x2} #{arch_y4}",
    )
  path(
    class: make_id("l2"),
    d: "M #{arch_x2} #{arch_y3}
        A #{radius} #{radius} 90 1 0
        #{arch_x2} #{arch_y4}",
    )
  path(
    class: make_id("l1"),
    d: "M #{arch_x2} #{arch_y3}
        A #{radius} #{radius} 90 0 0
        #{arch_x2} #{arch_y4}",
    )
  path(
    class: make_id("l1"),
    d: "M #{arch_x2} #{arch_y3}
        A #{radius} #{radius} 90 0 1
        #{arch_x2} #{arch_y4}",
    )

  text(
    class: make_id("t1"),
    x: text_x1, y: text_y1
    ).add_text("Has identity")
  text(
    class: make_id("t1"),
    x: text_x2, y: text_y2
    ).add_text("Can be")
  text(
    class: make_id("t1"),
    x: text_x2, y: text_y3
    ).add_text("moved from")
  text(
    class: make_id("t1"),
    x: text_x3, y: text_y1
    ).add_text("Has identity")
  text(
    class: make_id("t1"),
    x: text_x4, y: text_y2
    ).add_text("Can be")
  text(
    class: make_id("t1"),
    x: text_x4, y: text_y3
    ).add_text("moved from")
  text(
    class: make_id("t1"),
    x: text_x1, y: text_y5
    ).add_text("Has identity")
  text(
    class: make_id("t1"),
    x: text_x2, y: text_y6
    ).add_text("Can be")
  text(
    class: make_id("t1"),
    x: text_x2, y: text_y7
    ).add_text("moved from")
  text(
    class: make_id("t1"),
    x: text_x3, y: text_y5
    ).add_text("Has identity")
  text(
    class: make_id("t1"),
    x: text_x4, y: text_y6
    ).add_text("Can be")
  text(
    class: make_id("t1"),
    x: text_x4, y: text_y7
    ).add_text("moved from")

  text(
    class: make_id("t1"),
    x: circle_x3 - 2 * line_width - 2 * offset, y: text_y4
    ).add_text("lvalue")
  text(
    class: make_id("t1"),
    x: circle_x4 + line_width + 2 * offset, y: text_y4
    ).add_text("rvalue")
  text(
    class: make_id("t1"),
    x: circle_x1 - line_width - 2 * offset, y: text_y8
    ).add_text("glvalue")
  text(
    class: make_id("t1"),
    x: circle_x2 + 2 * line_width + 2 * offset, y: text_y8
    ).add_text("prvalue")
  text(
    class: make_id("t1"),
    x: arch_x2, y: text_y8
    ).add_text("xvalue")

  path(
    class: make_id("l3"),
    d: "M #{circle_x1 - line_width - 2 * offset} #{text_y8 - line_width}
        L #{circle_x1 - line_width} #{circle_y2 + line_width}",
    marker_end: "url(##{make_id("arrow")})"
  )
  path(
    class: make_id("l3"),
    d: "M #{circle_x2 + 2 * line_width + 2 * offset} #{text_y8 - line_width}
        L #{circle_x2 + 2 * line_width} #{circle_y2 + line_width}",
    marker_end: "url(##{make_id("arrow")})"
  )
  path(
    class: make_id("l3"),
    d: "M #{circle_x3 - 2 * line_width - 2 * offset} #{text_y4 - line_width}
        L #{circle_x3 - 2 * line_width} #{circle_y1 + line_width}",
    marker_end: "url(##{make_id("arrow")})"
  )
  path(
    class: make_id("l3"),
    d: "M #{circle_x4 + line_width + 2 * offset} #{text_y4 - line_width}
        L #{circle_x4 + line_width} #{circle_y1 + line_width}",
    marker_end: "url(##{make_id("arrow")})"
  )
  path(
    class: make_id("l3"),
    d: "M #{arch_x2} #{text_y8 - line_width}
        V #{circle_y2 + line_width}",
    marker_end: "url(##{make_id("arrow")})"
  )
end

puts image.render

save_to_file "../../_includes/assets/2016-04-07-move-forward", "01-diagrams.svg", image.render

