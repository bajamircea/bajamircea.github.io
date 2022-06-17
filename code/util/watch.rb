#!/usr/bin/env ruby

require 'listen'

class Runner
  def initialize()
    @failed = []
  end

  def run(script)
    success = system(script)
    unless success
      @failed.push(script)
    end
  end

  def print_result()
    if @failed.empty?
      puts 'OK'
    else
      puts 'FAILED: ' + @failed.to_s
    end
  end
end

folder = ARGV.pop
raise "Need to provide a folder to watch" unless folder
raise "Folder does not exist" unless Dir.exist?(folder)

listener = Listen.to(folder) do |m,c,r|
  puts('changed')
  pattern = File.join(folder, 'draw-*.rb')
  r = Runner.new()
  Dir.glob(pattern).each do |script|
    r.run(script)
  end
  r.print_result()
end

listener.start
sleep
