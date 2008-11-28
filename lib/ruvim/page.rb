#
# Page Class for Editor Class - Ruvim
#
# A Page is the visible area of the file in the window.
#

module Ruvim

	class Page
		
		def initialize(editor, s, e)
			@editor= editor
			@start = s
		end

		# TODO Optimize this
		def start
			@start
		end

		# TODO Optimize thsi shit
		def end
			lines = @editor.buffer.data.lines.count - 1
			max   = start + @editor.height

			(lines > max) ? max : lines
		end

		# Return a Range from start to end
		def range
			(start .. self.end)
		end

		# Returns current page number
		def number
#			@editor.lines 
		end

	end

end

