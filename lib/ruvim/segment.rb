#
# Ruvim Segment
#

module Ruvim

	class Segment
		
		attr_reader :start, :end
		
		def initialize(editor, start, last)
			@editor = editor
			@start  = start
			@end   = last
		end

		def space
			s = 0
			@editor.buffer.data[@start .. @end].each_char do |k|
				s += @editor.char_space(k, s)
			end

			s
		end

		# Returns column of segment in screen
		def column
			@editor.correct_pos(@start - @editor.buffer.bol(@start))
		end

		# Returns row of the segment in screen
		def row
		end

		# Vertical Space of the Segment
		def vspace
			
		end

		def size
			@end - @start
		end

		def to_str
			@editor.buffer.data[@start .. @end]
		end

		def each(&block)
			to_str.each_char(&block)
		end

	end

end
