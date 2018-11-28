#!/usr/bin/env ruby

require 'listen'


listener = Listen.to('.') do |m,c,r|
  puts 'changed'
  success = system('./draw-01.rb')
  success = system('./draw-02.rb')
  success = system('./draw-03.rb')
#  if success
#    puts 'OK'
#  else
#    puts 'FAILED'
#  end
end

listener.start
sleep
