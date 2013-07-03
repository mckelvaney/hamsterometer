#!/usr/bin/env ruby
require 'serialport'
require 'logger'

# try to create the log directory
Dir.mkdir('log/') unless Dir.exists?('log/')

# set up the log object - make sure the log folder is writeable
log = Logger.new('log/hamsterometer.log', 'daily')
log.level = Logger::INFO

# redirect STDOUT and STDERR so that we can make this a daemon
$stdout.reopen("/dev/null", "w")
$stderr.reopen("log/error.log", "w")

# set up the serial port object, with baud rate of 9600
sp = SerialPort.new('/dev/ttyUSB0', 9600, 8, 1, SerialPort::NONE)

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
