#!/usr/bin/env ruby
require 'serialport'
require 'logger'

if ARGV.size < 1
  STDERR.print <<EOF
  Usage: #{$0} serial_port
EOF
  exit(1)
end

# set up the log object - make sure the log folder is writeable
log = Logger.new('/var/log/hamsterometer/hamsterometer.log')
log.level = Logger::INFO

# set up the serial port object, with baud rate of 9600
sp = SerialPort.new(ARGV[0], 9600, 8, 1, SerialPort::NONE)

# recieve part
Thread.new do
  while TRUE do
    while (i = sp.gets) do
      # output to STDOUT
      puts i
      # output to log
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