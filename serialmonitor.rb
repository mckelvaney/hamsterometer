#!/usr/bin/env ruby
require 'serialport'
require 'logger'

if ARGV.size < 1
  STDERR.print <<EOF
  Usage: #{$0} serial_port
EOF
  exit(1)
end

log = Logger.new('/var/log/hamsterometer/hamsterometer.log')
log.level = Logger::INFO

sp = SerialPort.new(ARGV[0], 9600, 8, 1, SerialPort::NONE)



# recieve part
Thread.new do
  while TRUE do
    while (i = sp.gets) do
      puts i
      log.info(i.strip)
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