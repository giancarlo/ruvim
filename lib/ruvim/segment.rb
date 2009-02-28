#
# Ruvim Segment
#

module Ruvim

	class Segment
		
		def initialize(editor, start, last)
			@editor = editor
			@highlight = false
			@start  = start
			@end   = last
		end

		def start
			@start
		end

		def end
			@end
		end

		def highlight=(value)
			@highlight = value
		end

		def space
			s = 0
			@editor.buffer.data[@start .. @end].each_char do |k|
				s += @editor.char_space(k, s)
			end

			s
		end

		# Sets position of segment and returns self
		def set(segment_start, segment_end=@end)
			@start = segment_start
			@end = segment_end
			self
		end

		# Returns column of segment in screen
		def column
			@editor.line_space(@start)
		end

		# Returns row of the segment in screen
		def row
			@editor.page.start	
		end

		# Vertical Space of the Segment
		def vspace
			
		end

		def size
			@end - @start
		end

		# Removes segment from buffer and editor and sets cursor 
		# position to the start of the segment
		def delete
			result = @editor.buffer.data.slice!(start .. self.end)
			@editor.goto @start
			@editor.redraw

			return result
		end

		def to_str
			@editor.buffer.data[@start .. @end]
		end

		def each(&block)
			to_str.each_char(&block)
		end

	end

end
