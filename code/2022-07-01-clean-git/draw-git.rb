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

$white_commit = "#ffffff"
$blue_commit = "#2d93ad"
$pink_commit = "#ff36ab"
$pink1_commit = "#ffcdea"
$pink2_commit = "#ff9bd5"
$pink3_commit = "#ff69c0"
$purple_commit = "#9665ac"

def make_id(id, offset)
  return "svg20220701-" + id.to_s + "-" + offset.to_s
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
      args = {
        stroke_width:4, fill: "none",
        stroke: line[:stroke] || $neutral_line,
        d: path_d}
      if line[:dash]
        args[:stroke_dasharray] = '5, 5'
      end
      path(args)
    end
  end
end

def add_comments(id, image, comments)
  for c in comments
    image.build do
      text(class: make_id(id, "t1"), x: c[:x], y: c[:y],
        fill: c[:fill] || $neutral_line,
        text_anchor: c[:anchor] || "middle",
        ).add_text(c[:text])
    end
  end
end


def create_image(id, name, size_x, size_y, timelines, commits, lines, comments, print)
  image = svg({
    id: make_id(id, 1),
    width: "100%",
    viewBox: "0 0 #{size_x} #{size_y}",
    }) do

    style().add_text(<<-CSS)
      ##{make_id(id, 1)} {
        border: 1px solid #e8e8e8;
        background-color: #f5f5f5;
      }
      .#{make_id(id, "t1")} {
        font-family: sans-serif;
        font-size: 16px;
        font-weight: bold;
        dominant-baseline: middle;
      }
    CSS
  end

  add_timelines(image, timelines)
  add_lines(image, commits, lines)
  add_commits(image, commits)
  add_comments(id, image, comments)

  if print
    puts(image.render)
  end

  save_to_file("_includes/assets/2022-07-01-clean-git", name, image.render)
end

timelines = [
  {from: 0, to: 260, y: 10 },
  {from: 10, to: 160, y: 90 },
]
commits = [
  { x: 10, y: 10, },
  { x: 110, y: 10 },
  { x: 210, y: 10 },
  { x: 110, y: 90, fill: $orange_commit },
]
lines = [
  { from: 0, to: 1, },
  { from: 1, to: 2, },
  { from: 0, to: 3, },
]
comments = [
]

create_image(0, "00-cover.svg", 250, 100, timelines, commits, lines, comments, false)

timelines = [
  {from: 0, to: 450, y: 60},
]
commits = [
  { x: 50, y: 60, fill: $neutral_commit},
  { x: 150, y: 60, fill: $neutral_commit},
  { x: 250, y: 60, fill: $neutral_commit},
  { x: 350, y: 60, fill: $neutral_commit},
  { x: 450, y: 140, fill: $neutral2_commit},
]
lines = [
  { from: 0, to: 1, },
  { from: 1, to: 2, },
  { from: 2, to: 3, },
  { from: 3, to: 4, },
]
comments = [
  { x: 250, y: 20, text: "origin"},
  { x: 350, y: 20, text: "master"},
  { x: 450, y: 106, text: "staging"},
]
create_image(1, "01-linear.svg", 1000, 170, timelines, commits, lines, comments, false)

timelines = [
  {from: 0, to: 500, y: 60},
  {from: 350, to: 500, y: 140},
]
commits = [
  { x: 50, y: 60, fill: $neutral_commit},
  { x: 150, y: 60, fill: $neutral_commit},
  { x: 250, y: 60, fill: $neutral_commit},
  { x: 350, y: 60, fill: $neutral_commit},
  { x: 450, y: 60, fill: $neutral_commit},
  { x: 450, y: 140, fill: $orange_commit},
]
lines = [
  { from: 0, to: 1, },
  { from: 1, to: 2, },
  { from: 2, to: 3, },
  { from: 3, to: 4, },
  { from: 3, to: 5, },
]
comments = [
  { x: 510, y: 60, text: "master", anchor: "start"},
  { x: 510, y: 140, text: "some_branch", anchor: "start"},
]
create_image(2, "02-branch.svg", 1000, 180, timelines, commits, lines, comments, false)

timelines = [
  {from: 0, to: 1700, y: 60},
  {from: 350, to: 550, y: 140, noarrow: true},
  {from: 750, to: 1250, y: 220, noarrow: true},
  {from: 1450, to: 1650, y: 220, noarrow: true},
  {from: 950, to: 1150, y: 300, noarrow: true},
  {from: 0, to: 1700, y: 380},
  {from: 250, to: 1350, y: 460, noarrow: true},
  {from: 350, to: 750, y: 540, noarrow: true},
  {from: 1050, to: 1450, y: 540, noarrow: true},
]
commits = [
  { x: 50, y: 60, fill: $blue_commit}, # 0
  { x: 550, y: 60, fill: $blue_commit},
  { x: 1250, y: 60, fill: $blue_commit},
  { x: 1650, y: 60, fill: $blue_commit},
  { x: 450, y: 140, fill: $red_commit}, # 4
  { x: 850, y: 220, fill: $green_commit}, # 5
  { x: 950, y: 220, fill: $green_commit},
  { x: 1050, y: 220, fill: $green_commit},
  { x: 1150, y: 220, fill: $green_commit},
  { x: 1550, y: 220, fill: $green_commit},
  { x: 1050, y: 300, fill: $purple_commit}, #10
  { x: 150, y: 380, fill: $orange_commit}, # 11
  { x: 250, y: 380, fill: $orange_commit},
  { x: 350, y: 380, fill: $orange_commit},
  { x: 550, y: 380, fill: $orange_commit},
  { x: 750, y: 380, fill: $orange_commit},
  { x: 1050, y: 380, fill: $orange_commit},
  { x: 1250, y: 380, fill: $orange_commit},
  { x: 1350, y: 380, fill: $orange_commit},
  { x: 1450, y: 380, fill: $orange_commit},
  { x: 1650, y: 380, fill: $orange_commit},
  { x: 350, y: 460, fill: $pink_commit}, # 21
  { x: 450, y: 460, fill: $pink_commit},
  { x: 950, y: 460, fill: $pink_commit},
  { x: 1250, y: 460, fill: $pink_commit},
  { x: 450, y: 540, fill: $pink_commit}, # 25
  { x: 550, y: 540, fill: $pink_commit},
  { x: 650, y: 540, fill: $pink_commit},
  { x: 1150, y: 540, fill: $pink_commit},
  { x: 1250, y: 540, fill: $pink_commit},
  { x: 1350, y: 540, fill: $pink_commit},
]
lines = [
  { from: 4, to: 1, stroke: $unstable_line },
  { from: 4, to: 14, stroke: $unstable_line },
  { from: 6, to: 16, stroke: $unstable_line },
  { from: 8, to: 2, stroke: $unstable_line },
  { from: 8, to: 17, stroke: $unstable_line },
  { from: 9, to: 3, stroke: $unstable_line },
  { from: 9, to: 20, stroke: $unstable_line },
  { from: 10, to: 8, stroke: $unstable_line },
  { from: 24, to: 18, stroke: $unstable_line },
  { from: 27, to: 15, stroke: $unstable_line },
  { from: 30, to: 19, stroke: $unstable_line },
  { from: 0, to: 1, },
  { from: 0, to: 4, after: 350 },
  { from: 0, to: 11, },
  { from: 1, to: 2, },
  { from: 2, to: 3, },
  { from: 5, to: 6, },
  { from: 6, to: 7, },
  { from: 7, to: 8, },
  { from: 6, to: 10, },
  { from: 11, to: 12, },
  { from: 12, to: 13, },
  { from: 12, to: 21, },
  { from: 13, to: 14, },
  { from: 13, to: 25, },
  { from: 14, to: 15, },
  { from: 15, to: 5, },
  { from: 15, to: 16, },
  { from: 16, to: 17, },
  { from: 16, to: 28, },
  { from: 17, to: 18, },
  { from: 18, to: 19, },
  { from: 19, to: 9, },
  { from: 19, to: 20, },
  { from: 21, to: 22, },
  { from: 22, to: 23, },
  { from: 23, to: 24, },
  { from: 25, to: 26, },
  { from: 26, to: 27, },
  { from: 28, to: 29, },
  { from: 29, to: 30, },
]
comments = [
  { x: 1700, y: 60, text: "master", anchor: "start"},
  { x: 1700, y: 140, text: "hotfix", anchor: "start"},
  { x: 1700, y: 220, text: "release", anchor: "start"},
  { x: 1700, y: 300, text: "bugfix", anchor: "start"},
  { x: 1700, y: 380, text: "develop", anchor: "start"},
  { x: 1700, y: 500, text: "feature", anchor: "start"},
  { x: 50, y: 20, text: "tag 0.1"},
  { x: 550, y: 20, text: "tag 0.2"},
  { x: 1250, y: 20, text: "tag 1.0"},
  { x: 1650, y: 20, text: "tag 1.1"},
]
create_image(3, "03-git-flow.svg", 1800, 600, timelines, commits, lines, comments, false)

timelines = [
  {from: 1600, to: 1700, y: 60},
  {from: 1600, to: 1700, y: 220},
]
commits = [
  { x: 50, y: 60, fill: $blue_commit}, # 0
  { x: 550, y: 380, fill: $blue_commit},
  { x: 1250, y: 380, fill: $blue_commit},
  { x: 1650, y: 220, fill: $blue_commit},
  { x: 450, y: 300, fill: $red_commit}, # 4
  { x: 850, y: 220, fill: $green_commit}, # 5
  { x: 950, y: 220, fill: $green_commit},
  { x: 1050, y: 300, fill: $green_commit},
  { x: 1150, y: 300, fill: $green_commit},
  { x: 1550, y: 140, fill: $green_commit},
  { x: 1050, y: 220, fill: $purple_commit}, #10
  { x: 150, y: 60, fill: $orange_commit}, # 11
  { x: 250, y: 60, fill: $orange_commit},
  { x: 350, y: 140, fill: $orange_commit},
  { x: 550, y: 220, fill: $orange_commit},
  { x: 750, y: 140, fill: $orange_commit},
  { x: 1050, y: 140, fill: $orange_commit},
  { x: 1250, y: 220, fill: $orange_commit},
  { x: 1350, y: 60, fill: $orange_commit},
  { x: 1450, y: 60, fill: $orange_commit},
  { x: 1650, y: 60, fill: $orange_commit},
  { x: 350, y: 60, fill: $pink_commit}, # 21
  { x: 450, y: 60, fill: $pink_commit},
  { x: 950, y: 60, fill: $pink_commit},
  { x: 1250, y: 60, fill: $pink_commit},
  { x: 450, y: 140, fill: $pink_commit}, # 25
  { x: 550, y: 140, fill: $pink_commit},
  { x: 650, y: 140, fill: $pink_commit},
  { x: 1150, y: 140, fill: $pink_commit},
  { x: 1250, y: 140, fill: $pink_commit},
  { x: 1350, y: 140, fill: $pink_commit},
]
lines = [
  { from: 4, to: 1, stroke: $unstable_line },
  { from: 4, to: 14, stroke: $unstable_line },
  { from: 6, to: 16, stroke: $unstable_line },
  { from: 8, to: 2, stroke: $unstable_line },
  { from: 8, to: 17, stroke: $unstable_line },
  { from: 9, to: 3, stroke: $unstable_line },
  { from: 9, to: 20, stroke: $unstable_line },
  { from: 10, to: 8, stroke: $unstable_line },
  { from: 24, to: 18, stroke: $unstable_line },
  { from: 27, to: 15, stroke: $unstable_line },
  { from: 30, to: 19, stroke: $unstable_line },
  { from: 0, to: 1, after: 50},
  { from: 0, to: 4, after: 50 },
  { from: 0, to: 11, },
  { from: 1, to: 2, },
  { from: 2, to: 3, },
  { from: 5, to: 6, },
  { from: 6, to: 7, },
  { from: 7, to: 8, },
  { from: 6, to: 10, },
  { from: 11, to: 12, },
  { from: 12, to: 13, },
  { from: 12, to: 21, },
  { from: 13, to: 14, after: 50 },
  { from: 13, to: 25, },
  { from: 14, to: 15, after: 150 },
  { from: 15, to: 5, },
  { from: 15, to: 16, },
  { from: 16, to: 17, after: 50 },
  { from: 16, to: 28, },
  { from: 17, to: 18, },
  { from: 18, to: 19, },
  { from: 19, to: 9, },
  { from: 19, to: 20, },
  { from: 21, to: 22, },
  { from: 22, to: 23, },
  { from: 23, to: 24, },
  { from: 25, to: 26, },
  { from: 26, to: 27, },
  { from: 28, to: 29, },
  { from: 29, to: 30, },
]
comments = [
  { x: 1700, y: 220, text: "master", anchor: "start"},
  { x: 1700, y: 60, text: "develop", anchor: "start"},
  { x: 50, y: 20, text: "tag 0.1"},
  { x: 550, y: 340, text: "tag 0.2"},
  { x: 1250, y: 340, text: "tag 1.0"},
  { x: 1650, y: 180, text: "tag 1.1"},
]
create_image(4, "04-uh-oh.svg", 1800, 430, timelines, commits, lines, comments, false)

timelines = [
  {from: 1600, to: 1700, y: 60},
  {from: 1600, to: 1700, y: 220},
]
commits = [
  { x: 50, y: 60, }, # 0
  { x: 550, y: 380, },
  { x: 1250, y: 380, },
  { x: 1650, y: 220, },
  { x: 450, y: 300, }, # 4
  { x: 850, y: 220, }, # 5
  { x: 950, y: 220, },
  { x: 1050, y: 300, },
  { x: 1150, y: 300, },
  { x: 1550, y: 140, },
  { x: 1050, y: 220, }, #10
  { x: 150, y: 60, }, # 11
  { x: 250, y: 60, },
  { x: 350, y: 140, },
  { x: 550, y: 220, },
  { x: 750, y: 140, },
  { x: 1050, y: 140, },
  { x: 1250, y: 220, },
  { x: 1350, y: 60, },
  { x: 1450, y: 60, },
  { x: 1650, y: 60, fill: $white_commit },
  { x: 350, y: 60, }, # 21
  { x: 450, y: 60, },
  { x: 950, y: 60, },
  { x: 1250, y: 60, },
  { x: 450, y: 140, }, # 25
  { x: 550, y: 140, },
  { x: 650, y: 140, },
  { x: 1150, y: 140, },
  { x: 1250, y: 140, },
  { x: 1350, y: 140, },
]
lines = [
  { from: 4, to: 1, stroke: $unstable_line },
  { from: 4, to: 14, stroke: $unstable_line },
  { from: 6, to: 16, stroke: $unstable_line },
  { from: 8, to: 2, stroke: $unstable_line },
  { from: 8, to: 17, stroke: $unstable_line },
  { from: 9, to: 3, stroke: $unstable_line },
  { from: 9, to: 20, stroke: $unstable_line },
  { from: 10, to: 8, stroke: $unstable_line },
  { from: 24, to: 18, stroke: $unstable_line },
  { from: 27, to: 15, stroke: $unstable_line },
  { from: 30, to: 19, stroke: $unstable_line },
  { from: 0, to: 1, after: 50},
  { from: 0, to: 4, after: 50 },
  { from: 0, to: 11, },
  { from: 1, to: 2, },
  { from: 2, to: 3, },
  { from: 5, to: 6, },
  { from: 6, to: 7, },
  { from: 7, to: 8, },
  { from: 6, to: 10, },
  { from: 11, to: 12, },
  { from: 12, to: 13, },
  { from: 12, to: 21, },
  { from: 13, to: 14, after: 50 },
  { from: 13, to: 25, },
  { from: 14, to: 15, after: 150 },
  { from: 15, to: 5, },
  { from: 15, to: 16, },
  { from: 16, to: 17, after: 50 },
  { from: 16, to: 28, },
  { from: 17, to: 18, },
  { from: 18, to: 19, },
  { from: 19, to: 9, },
  { from: 19, to: 20, },
  { from: 21, to: 22, },
  { from: 22, to: 23, },
  { from: 23, to: 24, },
  { from: 25, to: 26, },
  { from: 26, to: 27, },
  { from: 28, to: 29, },
  { from: 29, to: 30, },
]
comments = [
  { x: 1700, y: 220, text: "master", anchor: "start"},
  { x: 1700, y: 60, text: "develop", anchor: "start"},
  { x: 50, y: 20, text: "tag 0.1"},
  { x: 550, y: 340, text: "tag 0.2"},
  { x: 1250, y: 340, text: "tag 1.0"},
  { x: 1650, y: 180, text: "tag 1.1"},
]
create_image(5, "05-uh-oh.svg", 1800, 430, timelines, commits, lines, comments, false)

timelines = [
  {from: 0, to: 800, y: 60},
  {from: 0, to: 800, y: 140},
  {from: 0, to: 800, y: 220},
]
commits = [
  { x: 50, y: 60, fill: $purple_commit},
  { x: 300, y: 60, fill: $purple_commit},
  { x: 450, y: 60, fill: $purple_commit},
  { x: 150, y: 140, fill: $blue_commit},
  { x: 250, y: 140, fill: $blue_commit},
  { x: 350, y: 140, fill: $blue_commit},
  { x: 450, y: 140, fill: $blue_commit},
  { x: 150, y: 220, fill: $pink_commit},
  { x: 250, y: 220, fill: $pink_commit},
  { x: 350, y: 220, fill: $pink_commit},
  { x: 450, y: 220, fill: $pink_commit},
  { x: 550, y: 220, fill: $pink_commit},
  { x: 550, y: 60, fill: $purple_commit},
  { x: 650, y: 60, fill: $purple_commit},
  { x: 650, y: 220, fill: $pink_commit},
  { x: 750, y: 220, fill: $pink_commit},
]
lines = [
  { from: 0, to: 1, },
  { from: 1, to: 2, },
  { from: 0, to: 3, },
  { from: 3, to: 4, },
  { from: 4, to: 5, },
  { from: 5, to: 2, },
  { from: 5, to: 6, },
  { from: 0, to: 7, },
  { from: 7, to: 8, },
  { from: 8, to: 9, },
  { from: 9, to: 10, },
  { from: 10, to: 11, },
  { from: 2, to: 11, },
  { from: 2, to: 12, },
  { from: 12, to: 13, },
  { from: 11, to: 13, },
  { from: 11, to: 14, },
  { from: 13, to: 15, },
  { from: 14, to: 15, },
]
comments = [
  { x: 810, y: 60, text: "master", anchor: "start"},
  { x: 810, y: 140, text: "blue_branch", anchor: "start"},
  { x: 810, y: 220, text: "pink_branch", anchor: "start"},
]
create_image(6, "06-interlaced.svg", 1000, 280, timelines, commits, lines, comments, false)

timelines = [
  {from: 350, to: 550, y: 60, noarrow: true},
  {from: 750, to: 1250, y: 60, noarrow: true},
  {from: 1450, to: 1650, y: 60, noarrow: true},
  {from: 0, to: 1700, y: 140},
  {from: 250, to: 1350, y: 220, noarrow: true},
  {from: 350, to: 750, y: 300, noarrow: true},
  {from: 1050, to: 1450, y: 300, noarrow: true},
]
commits = [
  { x: 50, y: 140, fill: $orange_commit}, # 0
  { x: 150, y: 140, fill: $orange_commit},
  { x: 250, y: 140, fill: $orange_commit},
  { x: 350, y: 140, fill: $orange_commit},
  { x: 450, y: 140, fill: $red_commit}, # 4
  { x: 450, y: 60, fill: $green_commit},
  { x: 550, y: 140, fill: $orange_commit}, # 6
  { x: 750, y: 140, fill: $orange_commit},
  { x: 850, y: 60, fill: $green_commit},
  { x: 950, y: 140, fill: $purple_commit},
  { x: 950, y: 60, fill: $green_commit},
  { x: 1050, y: 140, fill: $purple_commit},
  { x: 1050, y: 60, fill: $green_commit},
  { x: 1150, y: 140, fill: $purple_commit},
  { x: 1150, y: 60, fill: $green_commit},
  { x: 1350, y: 140, fill: $orange_commit}, # 15
  { x: 1450, y: 140, fill: $orange_commit},
  { x: 1550, y: 140, fill: $purple_commit},
  { x: 1550, y: 60, fill: $green_commit},
  { x: 350, y: 220, fill: $pink_commit}, # 19
  { x: 450, y: 220, fill: $pink_commit},
  { x: 950, y: 220, fill: $pink_commit},
  { x: 1250, y: 220, fill: $pink_commit},
  { x: 450, y: 300, fill: $pink_commit}, # 23
  { x: 550, y: 300, fill: $pink_commit},
  { x: 650, y: 300, fill: $pink_commit},
  { x: 1150, y: 300, fill: $pink_commit},
  { x: 1250, y: 300, fill: $pink_commit},
  { x: 1350, y: 300, fill: $pink_commit},
]
lines = [
  { from: 0, to: 1, },
  { from: 0, to: 5, after: 50 },
  { from: 1, to: 2, },
  { from: 1, to: 3, },
  { from: 1, to: 4, },
  { from: 4, to: 5, dash: true },
  { from: 4, to: 6, },
  { from: 6, to: 7, },
  { from: 7, to: 8, },
  { from: 7, to: 9, },
  { from: 8, to: 10, },
  { from: 9, to: 10, dash: true },
  { from: 9, to: 11, },
  { from: 11, to: 12, dash: true },
  { from: 10, to: 12, },
  { from: 11, to: 13, },
  { from: 12, to: 14, },
  { from: 13, to: 14, dash: true },
  { from: 13, to: 15, },
  { from: 15, to: 16, },
  { from: 16, to: 17, },
  { from: 16, to: 18, },
  { from: 17, to: 18, dash: true },
  { from: 2, to: 19, },
  { from: 19, to: 20, },
  { from: 20, to: 21, },
  { from: 21, to: 22, },
  { from: 22, to: 15, stroke: $unstable_line },
  { from: 3, to: 23, },
  { from: 23, to: 24, },
  { from: 24, to: 25, },
  { from: 25, to: 7, stroke: $unstable_line },
  { from: 11, to: 26, },
  { from: 26, to: 27, },
  { from: 27, to: 28, },
  { from: 28, to: 16, stroke: $unstable_line },
]
comments = [
  { x: 1700, y: 60, text: "release", anchor: "start"},
  { x: 1700, y: 140, text: "develop", anchor: "start"},
  { x: 1700, y: 260, text: "feature", anchor: "start"},
  { x: 50, y: 100, text: "tag 0.1"},
  { x: 450, y: 20, text: "tag 0.2"},
  { x: 1150, y: 20, text: "tag 1.0"},
  { x: 1550, y: 20, text: "tag 1.1"},
]
create_image(7, "07-trunk-based.svg", 1800, 350, timelines, commits, lines, comments, false)

timelines = [
  {from: 0, to: 350, y: 60},
  {from: 50, to: 400, y: 160},
  {from: 600, to: 1100, y: 60},
  {from: 650, to: 1050, y: 160, noarrow: true},
]
commits = [
  { x: 50, y: 60, fill: $orange_commit },
  { x: 300, y: 60, fill: $orange_commit },
  { x: 150, y: 160, fill: $pink_commit },
  { x: 250, y: 160, fill: $pink_commit },
  { x: 350, y: 160, fill: $pink_commit },
  { x: 650, y: 60, fill: $orange_commit },
  { x: 900, y: 60, fill: $orange_commit },
  { x: 750, y: 160, fill: $pink_commit },
  { x: 850, y: 160, fill: $pink_commit },
  { x: 950, y: 160, fill: $pink_commit },
  { x: 1050, y: 60, fill: $orange_commit },
]
lines = [
  { from: 0, to: 1, },
  { from: 0, to: 2, },
  { from: 2, to: 3, },
  { from: 3, to: 4, },

  { from: 5, to: 6, },
  { from: 5, to: 7, },
  { from: 7, to: 8, },
  { from: 8, to: 9, },
  { from: 9, to: 10, stroke: $unstable_line},
  { from: 6, to: 10, },
]
comments = [
  { x: 300, y: 20, text: "develop"},
  { x: 350, y: 120, text: "feature"},
  { x: 1050, y: 20, text: "develop"},
]
create_image(8, "08-merge-commit.svg", 1200, 200, timelines, commits, lines, comments, false)

timelines = [
  {from: 0, to: 150, y: 60},
  {from: 50, to: 400, y: 160},
  {from: 600, to: 1000, y: 60},
]
commits = [
  { x: 50, y: 60, fill: $orange_commit },
  { x: 150, y: 160, fill: $pink_commit },
  { x: 250, y: 160, fill: $pink_commit },
  { x: 350, y: 160, fill: $pink_commit },
  { x: 650, y: 60, fill: $orange_commit },
  { x: 750, y: 60, fill: $pink_commit },
  { x: 850, y: 60, fill: $pink_commit },
  { x: 950, y: 60, fill: $pink_commit },
]
lines = [
  { from: 0, to: 1, },
  { from: 1, to: 2, },
  { from: 2, to: 3, },

  { from: 4, to: 5, },
  { from: 5, to: 6, },
  { from: 6, to: 7, },
]
comments = [
  { x: 50, y: 20, text: "develop"},
  { x: 350, y: 120, text: "feature"},
  { x: 950, y: 20, text: "develop"},
]
create_image(9, "09-fast-forward.svg", 1200, 200, timelines, commits, lines, comments, false)

timelines = [
  {from: 0, to: 350, y: 60},
  {from: 50, to: 400, y: 160},
  {from: 600, to: 1050, y: 60},
]
commits = [
  { x: 50, y: 60, fill: $orange_commit },
  { x: 300, y: 60, fill: $orange_commit },
  { x: 150, y: 160, fill: $pink1_commit },
  { x: 250, y: 160, fill: $pink2_commit },
  { x: 350, y: 160, fill: $pink3_commit },
  { x: 650, y: 60, fill: $orange_commit },
  { x: 900, y: 60, fill: $orange_commit },
  { x: 1000, y: 60, fill: $pink_commit },
]
lines = [
  { from: 0, to: 1, },
  { from: 0, to: 2, },
  { from: 2, to: 3, },
  { from: 3, to: 4, },

  { from: 5, to: 6, },
  { from: 6, to: 7, },
]
comments = [
  { x: 300, y: 20, text: "develop"},
  { x: 350, y: 120, text: "feature"},
  { x: 1000, y: 20, text: "develop"},
]
create_image(10, "10-squash.svg", 1200, 200, timelines, commits, lines, comments, false)

timelines = [
  {from: 0, to: 200, y: 60},
  {from: 50, to: 400, y: 160},
  {from: 600, to: 800, y: 60},
  {from: 750, to: 1100, y: 160},
]
commits = [
  { x: 50, y: 60, fill: $orange_commit },
  { x: 150, y: 60, fill: $orange_commit },
  { x: 150, y: 160, fill: $pink_commit },
  { x: 250, y: 160, fill: $pink_commit },
  { x: 350, y: 160, fill: $pink_commit },
  { x: 650, y: 60, fill: $orange_commit },
  { x: 750, y: 60, fill: $orange_commit },
  { x: 850, y: 160, fill: $pink_commit },
  { x: 950, y: 160, fill: $pink_commit },
  { x: 1050, y: 160, fill: $pink_commit },
]
lines = [
  { from: 0, to: 1, },
  { from: 0, to: 2, },
  { from: 2, to: 3, },
  { from: 3, to: 4, },
  { from: 5, to: 6, },
  { from: 6, to: 7, },
  { from: 7, to: 8, },
  { from: 8, to: 9, },
]
comments = [
  { x: 150, y: 20, text: "develop"},
  { x: 350, y: 120, text: "feature"},
  { x: 750, y: 20, text: "develop"},
  { x: 1050, y: 120, text: "feature"},
]
create_image(11, "11-rebase.svg", 1200, 200, timelines, commits, lines, comments, false)

timelines = [
  {from: 0, to: 200, y: 60},
  {from: 50, to: 500, y: 160},
  {from: 600, to: 800, y: 60},
  {from: 750, to: 900, y: 160},
]
commits = [
  { x: 50, y: 60, fill: $orange_commit },
  { x: 150, y: 60, fill: $orange_commit },
  { x: 150, y: 160, fill: $neutral2_commit },
  { x: 250, y: 160, fill: $pink1_commit },
  { x: 350, y: 160, fill: $pink2_commit },
  { x: 450, y: 160, fill: $neutral2_commit },
  { x: 650, y: 60, fill: $orange_commit },
  { x: 750, y: 60, fill: $orange_commit },
  { x: 750, y: 160, fill: $neutral_commit },
  { x: 850, y: 160, fill: $pink_commit },
]
lines = [
  { from: 0, to: 1, },
  { from: 0, to: 2, },
  { from: 2, to: 3, },
  { from: 3, to: 4, },
  { from: 4, to: 5, },
  { from: 6, to: 7, },
  { from: 6, to: 8, },
  { from: 8, to: 9, },
]
comments = [
  { x: 150, y: 20, text: "develop"},
  { x: 450, y: 120, text: "feature"},
  { x: 750, y: 20, text: "develop"},
  { x: 850, y: 120, text: "feature"},
]
create_image(12, "12-rebase-i.svg", 1200, 200, timelines, commits, lines, comments, false)

timelines = [
  {from: 50, to: 200, y: 60},
  {from: 0, to: 400, y: 160},
  {from: 750, to: 900, y: 60},
  {from: 600, to: 1000, y: 160},
]
commits = [
  { x: 50, y: 160, fill: $orange_commit },
  { x: 150, y: 160, fill: $orange_commit },
  { x: 250, y: 160, fill: $purple_commit },
  { x: 350, y: 160, fill: $orange_commit },
  { x: 150, y: 60, fill: $green_commit },
  { x: 650, y: 160, fill: $orange_commit }, # 5
  { x: 750, y: 160, fill: $orange_commit },
  { x: 850, y: 160, fill: $purple_commit },
  { x: 950, y: 160, fill: $orange_commit },
  { x: 750, y: 60, fill: $green_commit },
  { x: 850, y: 60, fill: $green_commit },
]
lines = [
  { from: 0, to: 1, },
  { from: 0, to: 4, },
  { from: 1, to: 2, },
  { from: 2, to: 3, },
  { from: 5, to: 6, },
  { from: 5, to: 9, },
  { from: 6, to: 7, },
  { from: 7, to: 8, },
  { from: 9, to: 10, },
  { from: 7, to: 10, dash:true },
]
comments = [
  { x: 150, y: 20, text: "release"},
  { x: 350, y: 120, text: "develop"},
  { x: 850, y: 20, text: "release"},
  { x: 950, y: 120, text: "develop"},
]
create_image(13, "13-cherry-pick.svg", 1200, 200, timelines, commits, lines, comments, false)

timelines = [
  {from: 0, to: 200, y: 60},
  {from: 600, to: 800, y: 60},
]
commits = [
  { x: 50, y: 60, fill: $pink_commit },
  { x: 150, y: 60, fill: $pink1_commit },
  { x: 250, y: 60, fill: $pink3_commit },
  { x: 650, y: 60, fill: $pink_commit },
  { x: 750, y: 60, fill: $pink_commit },
  { x: 750, y: 160, fill: $pink1_commit },
]
lines = [
  { from: 0, to: 1, },
  { from: 1, to: 2, },
  { from: 3, to: 4, },
  { from: 3, to: 5, },
]
comments = [
  { x: 150, y: 20, text: "feature"},
  { x: 250, y: 20, text: "workspace"},
  { x: 750, y: 20, text: "feature"},
]
create_image(14, "14-amend.svg", 1200, 200, timelines, commits, lines, comments, false)

timelines = [
  {from: 0, to: 200, y: 60},
  {from: 600, to: 800, y: 60},
]
commits = [
  { x: 50, y: 60, fill: $pink_commit },
  { x: 150, y: 60, fill: $pink_commit },
  { x: 150, y: 160, fill: $pink1_commit },
  { x: 650, y: 60, fill: $pink_commit },
  { x: 750, y: 60, fill: $pink_commit },
  { x: 750, y: 160, fill: $pink1_commit },
]
lines = [
  { from: 0, to: 1, },
  { from: 0, to: 2, },
  { from: 3, to: 4, },
  { from: 3, to: 5, },
]
comments = [
  { x: 150, y: 120, text: "origin"},
  { x: 150, y: 20, text: "feature"},
  { x: 750, y: 20, text: "origin,feature"},
]
create_image(15, "15-force-push.svg", 1200, 200, timelines, commits, lines, comments, false)


