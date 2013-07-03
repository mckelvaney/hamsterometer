#!/usr/bin/env ruby
require 'serialport'
require 'logger'


if ARGV.size < 1
  STDERR.print <<EOF
 Usage: #{$0} serial_port debug
EOF
  exit(1)
end

debug = ARGV[1] || false

# try to create the log directory
Dir.mkdir('log/') unless Dir.exists?('log/')

# redirect STDOUT and STDERR so that we can make this a daemon
$stdout.reopen("log/out.log", "w")
$stderr.reopen("log/error.log", "w")

# set up the log object - make sure the log folder is writeable
log = Logger.new('log/hamsterometer.log', 'daily')
log.level = Logger::INFO

# set up the serial port object, with baud rate of 9600
sp = SerialPort.new(ARGV[0], 9600, 8, 1, SerialPort::NONE)

# recieve part
while TRUE do
	while (i = sp.gets) do
		# output to STDOUT
		puts i if debug
		# output to log
		log.info(i.strip)
	end
end 

Signal.trap("TERM") do
	sp.close
	puts Exiting
end

Signal.trap("KILL") do
	sp.close
	puts Exiting
end