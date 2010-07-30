#
# Ruvim Segment
#

module Ruvim

	class Segment

		attr_reader :start, :end

		def initialize(editor, start, last)
			@editor = editor
			@highlight = true
			set(start, last)
		end

		# Updates Selection end to Current Editor Index
		def update
			self.set(@start, @editor.buffer.index)
			highlight if @highlight
		end

		def highlight
			position = @editor.position
			
			@editor.redraw
			@editor.goto(start).attr(:selection) do
				#@editor.print to_str
				@editor.window.addstr to_str
			end

			@editor.goto position
		end

		def space
			s = 0
			@editor.buffer.data[range].each_char do |k|
				s += @editor.char_space(k, s)
			end

			s
		end

		# NOTE Review these two methods

		def start
			@start < @end ? @start : @end
		end

		def end
			@start > @end ? @start : @end
		end

		# Sets position of segment and returns self
		def set(segment_start, segment_end=@end)

			@start = segment_start
			@end = segment_end

			self
		end

		# Returns column of segment in screen
		#def column
		#	@editor.line_space(@start)
		#end

		# Returns row of the segment in screen
		#def row
		#	@editor.page.start	
		#end

		# Returns vertical space of the segment by counting the number of lines in the text.
		def vspace
			@editor.buffer.data[range].lines.count
		end

		def size
			(@end - @start).abs
		end

		# Returns Selection as A Range of the buffer indexes.
		def range
			#(@end > @start) ? (@start .. @end) : (@end .. @start)
			(start .. self.end)
		end

		# Removes segment from buffer and editor and sets cursor 
		# position to the start of the segment
		def delete
			result = @editor.buffer.data.slice!(range)
			@editor.goto(@start).redraw
			@editor.buffer.touch

			return result
		end

		def to_str
			@editor.buffer.data[range]
		end

		def each(&block)
			to_str.each_char(&block)
		end
	end

end
