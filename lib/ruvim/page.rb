#
# Page Class for Editor Class - Ruvim
#
# A Page is the visible area of the file in the window.
#

module Ruvim

	class Page

		def initialize(editor)
			@editor= editor
			@start = 0
		end

		def start
			@start
		end
		
		def start=(value)
			@start = value
			@editor.redraw
			self
		end

		def end
			lines = @editor.lines
			max   = start + @editor.height

			(lines > max) ? max : lines
		end

		def reset
			self.start = 0	
		end

		# Return a Range from start to end
		def range
			(start .. self.end)
		end

		def lines
			self.end - start
		end

		def scroll_up(n=1)
			self.start=(@start - n)
		end

		def scroll_down
			scroll_up(-1)
		end

	end

end

