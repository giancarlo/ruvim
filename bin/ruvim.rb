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
Curses.noecho
Curses.stdscr.keypad(true)

# ESCDELAY might not be defined.
Curses.ESCDELAY= 50 rescue nil
Curses.start_color
Curses.use_default_colors
Curses.refresh

$: << "../lib" << "/home/giancarlo/projects/algorithms/lib"

require 'ruvim/core'

module Ruvim

	Version = "0.1"


	class Application

		include Ruvim::API
		include Curses::Key
		
		attr_reader :editor, :statusbar
		
		private

		def initialize_resources
			# Load ~/.ruvimrc and Evaluate
			path = File.expand_path("~/.ruvimrc")

			if File.exists?(path) then
				@statusbar.message "Loading Resources"
				ruvimrc = File.new(path)
				eval(ruvimrc.read)
				ruvimrc.close
			end
		end

		def initialize_buffers
			@statusbar.message "Initializing Buffers"
			@buffers = Hash.new
			@buffers[:copy] = Buffer.new
		end

		# Statusbar is created in ruvim/statusbar.rb
		def initialize_statusbar
			@statusbar 	= Plugin[:statusbar]

			@statusbar.message "Setting up Status Bar"
			@statusbar.add_panel :position, Panel.new(@statusbar, -16, 10, 10)
			@statusbar.add_panel :mode, Panel.new(@statusbar, -2, 1, 1)
			
		end

		def print_mode
			@statusbar.panels[:mode].display @editor.mode.abbr
		end

		def print_position
			@statusbar.panels[:position].display("#{@editor.cursor.y}, #{@editor.cursor.x}")
		end

		def restore_position
			@editor.cursor.restore
		end

		def initialize_editors
			@editors = Array.new
		end

		def initialize_widgets
			@plugins = Hash.new
			@command = Ruvim::Command.new(self)
		end

		public :eval, :instance_eval

		public

		def initialize

			# this might be wrong but whatever
			$ruvim = self

			initialize_statusbar
			initialize_buffers
			initialize_editors
			initialize_widgets

			open

			print_position
			print_mode

			initialize_resources
			@statusbar.message "Ruvim #{Ruvim::Version}"

		end

		# 
		# EVENTS
		#
		
		def refresh
			Curses.refresh
			Ruvim::Window.refresh
		end

		def update(k)
			@editor.process(k)
			Ruvim::Window.update(k)
		end

		def start
			restore_position
			refresh

			while (k = Curses.getch)
				update(k)
				restore_position
				refresh
			end

		rescue RuvimExit
			cleanup
		end

		def cleanup
			Curses.close_screen
		end

	end

end

Ruvim::Application.new
$ruvim.debug= true
$ruvim.start
