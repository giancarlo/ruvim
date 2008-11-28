#
# Line Class - Ruvim
#

module Ruvim

	class Line

		def initialize(buffer)
			@buffer = buffer
		end

		def start
			(e = @buffer.data.rindex(Ruvim::API::CR, @buffer.index-1)) ? e+1 : 0
		end

		def end
			(e = @buffer.data.index(Ruvim::API::CR, @buffer.index)) ? e : @buffer.data.size
		end

		def number
			@number
		end

		def size
			self.end - self.start
		end

		# Returns Line
		def to_s
			@buffer.data[self.start ... self.end]	
		end

	end

end
