#
# API - Ruvim
#

module Ruvim

	module API

		ESCAPE = 27
		RETURN = 13
		DELETE = Curses::Key::DC
		CR = "\n"

		# Returns current buffer
		def buffer
			editor.buffer
		end

		# Exits Application and Closes Screen
		def exit
			$ruvim.continue = false
		end
		alias_method :q, :exit

		# Returns current line
		def line
			editor.buffer.line.to_s
		end

		# Returns Current char
		def char
			editor.buffer.char
		end

		def cursor
			editor.cursor
		end

	end

end
