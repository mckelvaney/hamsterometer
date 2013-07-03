#!/usr/bin/env ruby
require 'serialport'
require 'logger'

# redirect STDOUT and STDERR so that we can make this a daemon
$stdout.reopen("/dev/null", "w")
$stderr.reopen("log/error.log", "w")

# try to create the log directory
Dir.mkdir('log/') unless Dir.exists?('log/')

# set up the log object - make sure the log folder is writeable
log = Logger.new('log/hamsterometer.log', 'daily')
log.level = Logger::INFO

# set up the serial port object, with baud rate of 9600
sp = SerialPort.new('/dev/tty.usbserial-A800eL7Y', 9600, 8, 1, SerialPort::NONE)

# recieve part
while TRUE do
	while (i = sp.gets) do
		# output to STDOUT
		puts i
		# output to log
		log.info(i.strip)
	end
end 

Signal.trap("TERM") do
	sp.close
	puts
end

Signal.trap("KILL") do
	sp.close
	puts
end