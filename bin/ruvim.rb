#!/usr/bin/env ruby
# Ruvim - Ruby Vim Clone
#
# by Giancarlo Bellido
#

require 'ruvim/curses'
require 'ruvim/version'
require 'ruvim/window'
require 'ruvim/cursor'
require 'ruvim/line'
require 'ruvim/plugin'
require 'ruvim/error'
require 'ruvim/modes'
require 'ruvim/page'
require 'ruvim/editor'
require 'ruvim/bindings'
require 'ruvim/buffer'
require 'ruvim/mappings'
require 'ruvim/io'
require 'ruvim/movement'
require 'ruvim/message'
require 'ruvim/api'

module Ruvim

	class Application < Window

		include Ruvim::API
		include Curses::Key
		
		attr_reader :editors, :editor, :plugins, :workspace
		
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

		def initialize_arguments
			(ARGV.size > 0) ? (ARGV.each { |arg| open(arg) }) : open
		end

		public

		def initialize
			$ruvim = self
			@continue = true

			initialize_window
			initialize_plugins
			initialize_buffers
			initialize_editors
			initialize_arguments
			initialize_resources
		end

		def refresh
			Curses.refresh
			super
			editor.refresh
		end

		def update(k)
			@editor.process(k)
			super
		end

		def rearrange
			@width  = Curses.stdscr.maxx
			@height = Curses.stdscr.maxy
			super
		end

		# Gets Input and Uses Timeout to get multiple chars for mappings
		def getch
			
			k = Curses.getch 
			
			while editor.mode.bindings.continue(k)
				Curses.timeout= @timeout
				if x = Curses.getch then
					k = [k] unless (k.class == Array)
					k << x
				end
				Curses.timeout= -1
			end

			update(k)
		end

		def start
			editor.cursor.restore
			refresh

			while @continue
				getch
				editor.cursor.restore
				refresh
			end

			cleanup
		end

		def cleanup
			@editors.each { |e|	e.close }
			
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

Ruvim::Application.new.start
