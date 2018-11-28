#!/usr/bin/env ruby

require 'fileutils'

class Svg
  def initialize(name, attrs={}, nodes=[], text=[])
    @name = name
    @attrs = attrs
    @nodes = nodes
    @text = text
  end

  def render(indent = 0)
    result = []

    result.push(element_indent(indent))
    result.push("<#{@name}")
    rendered_attrs = render_attrs()
    result.push(" ") unless rendered_attrs.empty?
    result.push(rendered_attrs)
    rendered_contents = render_contents(indent)
    if rendered_contents.empty?
      result.push("/>")
    else
      result.push(">")
      result.push(rendered_contents)
      result.push("</#{@name}>")
    end

    result.join()
  end

  def add_node(name, attrs={}, &block)
    name = name.to_s.tr("_", "-")
    node = Svg.new(name, attrs)
    @nodes.push(node)
    node.build(&block) if block_given?
    node
  end

  def method_missing(method_name, *args, &block)
    add_node(method_name, *args, &block)
  end

  def add_text(text)
    @text.push(text)
  end

  def build(&block)
    self.instance_eval(&block)
  end

  private

  def element_indent(indent)
    " " * (2 * indent)
  end

  def render_attrs
    result = @attrs.map do |key, value|
      key = key.to_s.tr("_", "-")
      "#{key}=\"#{value}\""
    end

    result.join(" ")
  end

  def render_contents(indent)
    result = []
    unless @text.empty?
      result.push("\n") if @text.first.end_with?("\n")
      result.push(@text.join("\n"))
    end

    unless @nodes.empty?
      cont = [""]
      cont.concat(@nodes.map{|item| item.render(indent + 1)})
      cont.push("")
      result.push(cont.join("\n"))
    end

    if !@nodes.empty? || (!@text.empty? && @text.last.end_with?("\n"))
      result.push(element_indent(indent))
    end

    result.join()
  end
end

def svg(attrs={}, &block)
  node = Svg.new("svg", {
    xmlns: "http://www.w3.org/2000/svg"
    }.merge(attrs))
  node.build(&block) if block_given?
  node
end

def save_to_file(folder, file, contents)
  FileUtils.mkdir_p folder
  path = File.join folder, file
  File.write path, contents
end

