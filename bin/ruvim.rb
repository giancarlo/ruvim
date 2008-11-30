#!/usr/bin/env ruby
# Ruvim - Ruby Vim Clone
#
# by Giancarlo Bellido
#

require 'curses'

# Initializing Curses. This is fucking horrible here.
# TODO Find a better place.
Curses.init_screen
Curses.nonl
Curses.cbreak
#Curses.raw
Curses.noecho
Curses.stdscr.keypad(true)

# ESCDELAY might not be defined.
Curses.ESCDELAY= 50 rescue nil
Curses.start_color
Curses.use_default_colors
Curses.init_pair(3, Curses::COLOR_YELLOW, -1)
Curses.refresh

$: << "../lib" << "/home/giancarlo/projects/algorithms/lib"

require 'ruvim/core'

module Ruvim

	Version = "0.1"


	class Application < Window

		include Ruvim::API
		include Curses::Key
		
		attr_reader :editors, :editor, :plugins, :workspace
		
		private

		def initialize_resources
			# Load ~/.ruvimrc and Evaluate
			path = File.expand_path("~/.ruvimrc")

			if File.exists?(path) then
				ruvimrc = File.new(path)
				eval(ruvimrc.read)
				ruvimrc.close
			end
		end

		def initialize_buffers
			@buffers = Hash.new
			@buffers[:copy] = Buffer.new
		end

		def initialize_plugins
			@plugins = Hash.new
		end

		def initialize_editors
			@editors = Array.new
		end

		def initialize_window
			@window  = Curses.stdscr
			@client  = [@x = 0, @y = 0, @width = Curses.cols, @height = Curses.lines]
			@windows = Array.new
			@visible = true

			@workspace = Window.new
			@workspace.align= :client
		end

		public :eval, :instance_eval

		public

		def initialize
			# this might be wrong but whatever
			$ruvim = self

			initialize_window
			initialize_plugins
			initialize_buffers
			initialize_editors

			open

			initialize_resources
		end

		# 
		# EVENTS
		#
		
		def refresh
			Curses.refresh
			super
			editor.refresh
		end

		def update(k)
			@editor.process(k)
			super
		end

		# We need to make sure we use the whole screen
		def rearrange
			@width  = Curses.stdscr.maxx
			@height = Curses.stdscr.maxy
			super
		end

		def start
			editor.cursor.restore
			refresh

			while true
				k = Curses.getch
				update(k)
				editor.cursor.restore
				refresh
			end

		rescue RuvimExit
			cleanup
		end

		def cleanup
			Curses.close_screen
			puts "Goodbye"
		end

		# This will print a message at the bottom of the screen
		# NOTE Statusbar overrides this function
		def message(what)
			@window.setpos(Curses.lines, 0)
			@window.addstr(what.to_s)
			@window.clrtoeol
		end

	end

end

Ruvim::Application.new
$ruvim.start
