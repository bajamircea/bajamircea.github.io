#!/usr/bin/env ruby

require_relative '../util/svg.rb'

three_four_five = svg({
  id: make_id(1),
  viewBox: "0 0 200 100",
  }) do

  style().add_text(<<-CSS)
    ##{make_id(1)} {
      border: 1px solid #e8e8e8;
    }
  CSS

  defs() do
    marker(
      id: make_id(2),
      viewBox: "0 0 10 10",
      refX: "9", refY: "5",
      markerUnits: "strokeWidth",
      markerWidth: "8",
      markerHeight: "6",
      orient: "auto"
      ) do
      path(
        d: "M 0 0 L 10 5 L 0 10 z",
        class: "arrowheadPath",
        style: "stroke-width: 1; stroke-dasharray: 1, 0;"
        )
    end
  end

  path(
    d: "M 50 50 L 100 50",
    marker_end: "url(##{make_id(2)})",
    fill: "red", stroke: "blue",
    )

  rect(
    x: "20", y: "20",
    width: "30", height: "30",
    fill: "red", stroke: "blue",
    )

end

puts three_four_five.render

save_to_file "../../_includes/assets/2018-11-07-maths-history", "01-three_four_five.svg", three_four_five.render

