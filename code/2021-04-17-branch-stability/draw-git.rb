#!/usr/bin/env ruby

require_relative '../util/svg.rb'

# for lines
$neutral_line = "#2f332b"
$stable_line = "#5f3b16"
$unstable_line = "#8f4300"

# for commits
$neutral_commit = "#2d93ad"
$neutral2_commit = "#6ac3d9"

$green_commit = "#8ea604"
$green2_commit = "#a8ac03"
$green3_commit = "#c2b102"
$green4_commit = "#dcb601"

$orange_commit = "#f5bb00"
$red_commit = "#ee6055"

def make_id(offset)
  return "svg20210417-01-" + offset.to_s
end

def add_timelines(image, timelines)
  for t in timelines
    path_d = "M #{t[:from]} #{t[:y] - 28}"
    if t[:noarrow]
      path_d += " L #{t[:to]} #{t[:y] - 28}"
      path_d += " L #{t[:to]} #{t[:y] + 28}"
    else
      path_d += " L #{t[:to] - 28} #{t[:y] - 28}"
      path_d += " L #{t[:to]} #{t[:y]}"
      path_d += " L #{t[:to] - 28} #{t[:y] + 28}"
    end
    path_d += " L #{t[:from]} #{t[:y] + 28} Z"
    image.build do
      path(stroke: "none", fill: "#ffffff",d: path_d)
    end
  end
end

def add_commits(image, commits)
  for commit in commits
    image.build do
      circle(cx: commit[:x], cy: commit[:y],
        r:20, stroke_width:4,
        stroke: commit[:stroke] || $neutral_line,
        fill: commit[:fill] || $neutral_commit)
    end
  end
end

def add_lines(image, commits, lines)
  for line in lines
    from = commits[line[:from]]
    to = commits[line[:to]]
    image.build do
      path_d = "M #{from[:x] + 20} #{from[:y]}"
      if from[:y] == to[:y]
        path_d += " L #{to[:x] - 20} #{to[:y]}"
      else
        y_off = to[:y] > from[:y] ? 20 : -20
        mid_x = (from[:x] + to[:x])/2
        mid_y = (from[:y] + to[:y])/2
        if line[:after]
          mid_x = from[:x] + line[:after]
        end
        path_d += " L #{mid_x - 20} #{from[:y]}"
        path_d += " Q #{mid_x} #{from[:y]} #{mid_x} #{from[:y] + y_off}"
        path_d += " L #{mid_x} #{to[:y] - y_off}"
        path_d += " Q #{mid_x} #{to[:y]} #{mid_x + 20} #{to[:y]}"
        path_d += " L #{to[:x] -20} #{to[:y]}"
      end
      path(
        stroke_width:4, fill: "none",
        stroke: line[:stroke] || $neutral_line,
        d: path_d)
    end
  end
end

def add_comments(image, comments)
  for c in comments
    image.build do
      text(class: make_id("t1"), x: c[:x], y: c[:y],
        fill: c[:fill] || $neutral_line
        ).add_text(c[:text])
    end
  end
end


def create_image(id, name, size_x, size_y, timelines, commits, lines, comments, print)
  image = svg({
    id: make_id(1),
    width: "100%",
    viewBox: "0 0 #{size_x} #{size_y}",
    }) do

    style().add_text(<<-CSS)
      ##{make_id(1)} {
        border: 1px solid #e8e8e8;
        background-color: #f5f5f5;
      }
      .#{make_id("t1")} {
        font-family: sans-serif;
        font-size: 16px;
        font-weight: bold;
        text-anchor: middle;
        dominant-baseline: middle;
      }
    CSS
  end

  add_timelines(image, timelines)
  add_lines(image, commits, lines)
  add_commits(image, commits)
  add_comments(image, comments)

  if print
    puts image.render
  end

  save_to_file "../../_includes/assets/2021-04-17-branch-stability", name, image.render
end

timelines = [
  {from: 50, to: 450, y: 100},
  {from: 0, to: 400, y: 200, noarrow: true},
]
commits = [
  { x: 100, y: 100, },
  { x: 200, y: 100, stroke: $stable_line},
  { x: 300, y: 100, stroke: $unstable_line, fill: $neutral2_commit},
  { x: 100, y: 200, fill: $red_commit},
  { x: 200, y: 200, fill: $green_commit},
  { x: 300, y: 200, stroke: $unstable_line, fill: $orange_commit},
  { x: 100, y: 300, fill: $green_commit},
  { x: 200, y: 300, fill: $green2_commit},
  { x: 300, y: 300, fill: $green3_commit},
  { x: 400, y: 300, fill: $green4_commit},
]
lines = [
  { from: 0, to: 1, },
  { from: 0, to: 4, stroke: $stable_line},
  { from: 3, to: 8, stroke: $unstable_line, after: 150},
]
comments = [
  { x: 200, y: 50, text: "master"},
  { x: 300, y: 50, text: "staging", fill: $unstable_line},
]

create_image(0, "00-sample.svg", 600, 400, timelines, commits, lines, comments, false)

timelines = [
  {from: 0, to: 550, y: 60},
]
commits = [
  { x: 50, y: 60, fill: $green_commit},
  { x: 150, y: 60, fill: $green_commit},
  { x: 250, y: 60, fill: $green_commit},
  { x: 350, y: 60, fill: $green_commit},
  { x: 450, y: 60, fill: $green_commit},
  { x: 550, y: 140, fill: $green4_commit},
]
lines = [
  { from: 0, to: 1, },
  { from: 1, to: 2, },
  { from: 2, to: 3, },
  { from: 3, to: 4, },
  { from: 4, to: 5, },
]
comments = [
  { x: 350, y: 20, text: "origin"},
  { x: 450, y: 20, text: "master"},
  { x: 550, y: 106, text: "staging"},
]
create_image(1, "01-linear.svg", 600, 170, timelines, commits, lines, comments, false)

timelines = [
  {from: 0, to: 550, y: 60},
  {from: 80, to: 480, y: 160, noarrow: true},
]
commits = [
  { x: 50, y: 60, fill: $green_commit},
  { x: 300, y: 60, fill: $green_commit},
  { x: 150, y: 160, fill: $red_commit, stroke: $unstable_line},
  { x: 250, y: 160, fill: $green4_commit, stroke: $unstable_line},
  { x: 350, y: 160, fill: $green_commit, stroke: $unstable_line},
  { x: 450, y: 60, fill: $green3_commit},
]
lines = [
  { from: 0, to: 1, },
  { from: 0, to: 2, stroke: $unstable_line},
  { from: 2, to: 3, stroke: $unstable_line},
  { from: 3, to: 4, stroke: $unstable_line},
  { from: 4, to: 5, stroke: $unstable_line},
  { from: 1, to: 5, },
]
comments = [
  { x: 450, y: 20, text: "develop"},
  { x: 350, y: 120, text: "feature a"},
]
create_image(2, "02-feature.svg", 600, 200, timelines, commits, lines, comments, false)

timelines = [
  {from: 0, to: 600, y: 60},
  {from: 80, to: 580, y: 160, noarrow: true},
]
commits = [
  { x: 50, y: 60, fill: $green_commit},
  { x: 300, y: 60, fill: $green_commit},
  { x: 150, y: 160, fill: $red_commit, stroke: $unstable_line},
  { x: 250, y: 160, fill: $green4_commit, stroke: $unstable_line},
  { x: 350, y: 160, fill: $green_commit, stroke: $unstable_line},
  { x: 450, y: 160, fill: $green3_commit},
  { x: 550, y: 60, fill: $green_commit},
]
lines = [
  { from: 0, to: 1, },
  { from: 0, to: 2, stroke: $unstable_line},
  { from: 2, to: 3, stroke: $unstable_line},
  { from: 3, to: 4, stroke: $unstable_line},
  { from: 4, to: 5, stroke: $unstable_line},
  { from: 1, to: 5, after: 100},
  { from: 5, to: 6, stroke: $unstable_line},
  { from: 1, to: 6, },
]
comments = [
  { x: 550, y: 20, text: "develop"},
  { x: 450, y: 120, text: "feature b"},
]
create_image(4, "04-merge-down.svg", 600, 200, timelines, commits, lines, comments, false)

timelines = [
  {from: 0, to: 550, y: 60},
  {from: 80, to: 500, y: 160, noarrow: true},
]
commits = [
  { x: 50, y: 60, fill: $green_commit},
  { x: 300, y: 60, fill: $green_commit},
  { x: 150, y: 160, fill: $red_commit, stroke: $unstable_line},
  { x: 250, y: 160, fill: $green4_commit, stroke: $unstable_line},
  { x: 350, y: 160, fill: $green_commit, stroke: $unstable_line},
  { x: 450, y: 160, fill: $green3_commit},
]
lines = [
  { from: 0, to: 1, },
  { from: 0, to: 2, stroke: $unstable_line},
  { from: 2, to: 3, stroke: $unstable_line},
  { from: 3, to: 4, stroke: $unstable_line},
  { from: 1, to: 5, after: 100},
]
comments = [
  { x: 300, y: 20, text: "develop"},
  { x: 450, y: 120, text: "feature c"},
]
create_image(5, "05-rebase.svg", 600, 200, timelines, commits, lines, comments, false)

timelines = [
  {from: 0, to: 550, y: 60},
  {from: 80, to: 500, y: 160, noarrow: true},
]
commits = [
  { x: 50, y: 60, fill: $green4_commit, stroke: $stable_line},
  { x: 300, y: 60, fill: $green4_commit, stroke: $stable_line},
  { x: 150, y: 160, fill: $green3_commit},
  { x: 250, y: 160, fill: $green2_commit},
  { x: 350, y: 160, fill: $green_commit},
  { x: 450, y: 60, fill: $green4_commit, stroke: $stable_line},
]
lines = [
  { from: 0, to: 1, stroke: $stable_line},
  { from: 0, to: 2},
  { from: 2, to: 3},
  { from: 3, to: 4},
  { from: 4, to: 5},
  { from: 1, to: 5, stroke: $stable_line},
]
comments = [
  { x: 450, y: 20, text: "develop"},
  { x: 350, y: 120, text: "release x"},
]
create_image(6, "06-release-branch.svg", 600, 200, timelines, commits, lines, comments, false)
