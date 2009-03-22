#
# API - Ruvim
#

module Ruvim

	module API

		ESCAPE = 27
		RETURN = 13
		DELETE = Curses::Key::DC
		CR = "\n"


		def mode(newmode)
			editor.mode= newmode
		end

		# Returns current editor page object.
		def page
			editor.page
		end

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

			return self.exit if editors.size == 0

			editor_goto((@current_editor >= editors.size) ? @current_editor = editors.size-1 : @current_editor)
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

		# Returns current editor selection
		def selection
			$ruvim.editor.selection
		end

		# Inserts content from $ruvim.buffer[:copy] into editor
		def paste
			$ruvim.insert $ruvim.buffers[:copy].data
			$ruvim.editor.redraw
		end

		# Copies text from segment or current selection
		def copy(segment=selection)
			$ruvim.buffers[:copy].data.replace segment
		end

		# Cuts segment from current editor.
		def cut(segment=selection)
			copy segment
			segment.delete
		end

	end
end
