#!/usr/bin/env ruby

require 'listen'

listener = Listen.to('.') do |m,c,r|
  puts 'changed'
  success = system('./draw.rb')
  if success
    puts 'OK'
  else
    puts 'FAILED'
  end
end

listener.start
sleep
