#!/usr/bin/env ruby

require 'rubygems'
require 'ruvim/app'

begin
	Ruvim::Application.new

	require 'ruvim/plugins/search'
	require 'ruvim/plugins/statusbar'
	require 'ruvim/plugins/command'
	require 'ruvim/plugins/lines'
	require 'ruvim/plugins/filetype'
	require 'ruvim/plugins/syntax'
	
	$ruvim.start
rescue Exception
	Curses.close_screen
	puts $!
	puts $@
end
