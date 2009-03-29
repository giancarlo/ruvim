#!/usr/bin/env ruby

require 'ruvim/app'

begin
	Ruvim::Application.new.start
rescue Exception
	#Curses.close_screen
	puts $stderr.string if $stderr.class == StringIO
	puts $!
	puts $@
end
