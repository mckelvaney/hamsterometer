#!/usr/bin/env ruby
require 'serialport'
require 'logger'

# set up the log object - make sure the log folder is writeable
log = Logger.new('/var/log/hamsterometer/hamsterometer.log')
log.level = Logger::INFO

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
