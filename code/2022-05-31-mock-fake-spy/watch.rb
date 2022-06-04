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

listener = Listen.to('.') do |m,c,r|
  puts 'changed'
  r = Runner.new()
  Dir.glob('./draw-*.rb').each do |script|
    r.run(script)
  end
  r.print_result()
end

listener.start
sleep
