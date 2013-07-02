#!/usr/bin/env ruby
require 'serialport'
if ARGV.size < 1
  STDERR.print <<EOF
  Usage: #{$0} serial_port
EOF
  exit(1)
end

sp = SerialPort.new(ARGV[0], 9600, 8, 1, SerialPort::NONE)



# recieve part
Thread.new do
  while TRUE do
    while (i = sp.gets) do
      puts Time.now.to_s + ' ' + i
    end
  end 
end

# send part
begin
  while TRUE do
    sp.print STDIN.gets.chomp
  end
rescue Interrupt
  sp.close
  puts      #insert a newline character after ^C
end