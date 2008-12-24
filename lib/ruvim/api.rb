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
			@continue = false
		end
		alias_method :qa, :exit

		# Quits current editor and removes them from editors
		def quit
			editor.close
			editors.delete_at @current_editor

			return exit if editors.size == 0

			if @current_editor >= editors.size then
				@current_editor = editors.size
			end
			editor_goto
		end
		alias_method :q, :quit

		# Sets tabsize for current and future editors
		def tabsize=(value)
			editor.tabsize= value
		end

		def tabsize
			editor.tabsize
		end

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

		def insert(text)
			text.each_char { |k| editor.insert(k) }
		end

		def back(step=1)
			step.times { editor.back }
		end

		def forward(step=1)
			step.times { editor.forward }
		end

	end

end
