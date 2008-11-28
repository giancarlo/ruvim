#
# Ruvim API - Use to configure application inside Ruvim
#
require 'curses'

require 'ruvim/window'
require 'ruvim/cursor'
require 'ruvim/line'
require 'ruvim/plugin'
require 'ruvim/error'
require 'ruvim/modes'
require 'ruvim/page'
require 'ruvim/editor'
require 'ruvim/statusbar'
require 'ruvim/commandbar'
require 'ruvim/bindings'
require 'ruvim/buffer'
require 'ruvim/mappings'
require 'ruvim/lines'
require 'ruvim/command'
require 'ruvim/io'
require 'ruvim/debug'
require 'ruvim/movement'
require 'ruvim/message'

module Ruvim

	module API

		ESCAPE = 27
		RETURN = 13
		DELETE = Curses::Key::DC
		CR = "\n"

		# Quit
		alias_method :q, :exit

		def debug=(value)
			@debug = value
		end

		# Returns current buffer line
		def line
			@editor.buffer.line
		end

		# Returns current buffer char
		def char
			@editor.buffer.char
		end

		# Exits Application and Closes Screen
		# TODO Check this. I dont like raising with no error
		def exit
			raise RuvimExit
		end

		# Redraws screen. Mapped to Key::RESIZE
		def refresh
			@statusbar.refresh
		end

	end

end
