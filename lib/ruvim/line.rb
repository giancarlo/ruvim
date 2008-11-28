#
# Line Class - Ruvim
#

module Ruvim

	class Line

		def initialize(buffer)
			@buffer = buffer
		end

		def start(i = @buffer.index)
			return 0 if i == 0
			(e = @buffer.data.rindex(Ruvim::API::CR, i-1)) ? e+1 : 0
		end

		def end(i = @buffer.index)
			(e = @buffer.data.index(Ruvim::API::CR, i)) ? e : @buffer.eof
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

		# Creates a new Line Object with the next line.
		def next
			s = self.end + 1
			return "" if s >= @buffer.size
			e = self.end(s)
			@buffer.data[s ... e]			
		end

		def previous
			e = self.start - 1
			return nil if e == -1
			s = self.start(e)
			@buffer.data[s ... e]
		end
	end

end
