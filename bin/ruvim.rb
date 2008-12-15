#!/usr/bin/env ruby
# Ruvim - Ruby Vim Clone
#
# by Giancarlo Bellido
#

require 'ruvim/curses'
require 'ruvim/core'

module Ruvim

	Version = "0.1"

	class Application < Window

		include Ruvim::API
		include Curses::Key
		
		attr_reader :editors, :editor, :plugins, :workspace
		attr_accessor :continue
		
		private

		# Load ~/.ruvimrc and Evaluate
		def initialize_resources
			path = File.expand_path("~/.ruvimrc")

			if File.exists?(path) then
				ruvimrc = File.new(path)
				instance_eval(ruvimrc.read)
				ruvimrc.close
			end
		end

		def initialize_buffers
			@buffers = { :copy => Buffer.new }
		end

		def initialize_plugins
			@plugins = Hash.new
		end

		def initialize_editors
			@editors = Array.new
		end

		def initialize_window
			@window  = Curses.stdscr
			@cursor  = Cursor.new(@window)
			@client  = [@x = 0, @y = 0, @width = Curses.cols, @height = Curses.lines]
			@windows = Array.new
			@visible = true

			@workspace = Window.new

			@workspace.alignment= :client
		end

		public :eval, :instance_eval

		public

		def initialize
			$ruvim = self
			@continue = true

			initialize_window
			initialize_plugins
			initialize_buffers
			initialize_editors

			# Lets check ARGS
			(ARGV.size > 0) ? (ARGV.each { |arg| open(arg) }) : open

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

			while @continue
				k = Curses.getch
				update(k)
				editor.cursor.restore
				refresh
			end

			cleanup
		end

		def cleanup
			Curses.close_screen
		end

		# This will print a message at the bottom of the screen
		# NOTE Statusbar overrides this function
		def message(what)
			@window.setpos(Curses.lines-1, 0)
			@window.addstr(what.to_s)
			@window.clrtoeol
		end

		# Gets input
		# You may override this function
		def input(prompt='?')
			@window.setpos(Curses.lines-1, 0)
			@window.addstr(prompt)
			@window.clrtoeol

			@window.setpos(Curses.lines-1, prompt.length)
			Curses.echo
			inp = @window.getstr
			Curses.noecho
			
			return inp
		end

	end

end

Ruvim::Application.new
$ruvim.start
