#!/usr/bin/env ruby

require 'ruvim/app'

begin
	Ruvim::Application.new

	require 'ruvim/plugins/search'
	require 'ruvim/plugins/statusbar'
	require 'ruvim/plugins/command'
	require 'ruvim/plugins/lines'
	require 'ruvim/plugins/filetype'
	
	$ruvim.start
rescue Exception
	Curses.close_screen
	puts $stderr.string if $stderr.class == StringIO
	puts $!
	puts $@
end
