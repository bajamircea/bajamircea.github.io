#!/usr/bin/env ruby

require_relative '../util/svg.rb'

$crt_id = 1

def make_id(arg)
  return "svg20251114-" + $crt_id.to_s + "-" + arg
end

image = svg({
  id: make_id("box"),
  width: "100%",
  viewBox: "0 0 430 90",
  }) do

  style().add_text(<<-CSS)
    ##{make_id("box")} {
      border: 1px solid #e8e8e8;
      background-color: #f5f5f5;
    }
    .#{make_id("l1")} {
      stroke: #000000;
      stroke-width: 2;
      fill: none;
    }
    .#{make_id("t1")} {
      font-family: sans-serif;
      font-size: 16px;
      text-anchor: middle;
      dominant-baseline: middle;
    }
    .#{make_id("t2")} {
      font-family: sans-serif;
      font-size: 14px;
      text-anchor: left;
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

  line(
    class: make_id("l1"),
    x1: 10, y1: 25,
    x2: 415, y2: 25,
    marker_end: "url(##{make_id("arrow")})"
  )

  base = 1650
  data = {
    1682 => {
      0 => "Penn",
    },
    1750 => {
      0 => "Woolman",
      1 => "Franklin",
      2 => "Hume",
    },
    1840 => {
      0 => "Tom Sawyer",
    },
    1930 => {
      0 => "Gatsby",
      1 => "Atticus",
    },
    2025 => {
      0 => "Now"
    },
  }
  for year, people in data do
    tick = 10 + (year - base)
    text(
      class: make_id("t1"),
      x: tick, y: 15
    ).add_text(year.to_s)
    line(
      class: make_id("l1"),
      x1: tick, y1: 22,
      x2: tick, y2: 28
    )
    people.each do |offset, person|
      text(
        class: make_id("t2"),
        x: tick, y: (40 + offset * 18)
      ).add_text(person)
    end
  end

end

#puts(image.render)

save_to_file("_includes/assets/2025-11-14-one-hundred-years", "01-timeline.svg", image.render)

$crt_id += 1
