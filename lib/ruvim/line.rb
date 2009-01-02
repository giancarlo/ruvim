#
# Line Class - Ruvim
#
# This is a helper class for Buffer. It manages the current line of the Buffer.
#

module Ruvim

	class Line

	private
		
		# Gets line end. makes sure to exclude CR chars.
		def line_end(i=@buffer.index)
			e = self.end i
			e -= 1 if @buffer.data[e-1] == "\r"
			e
		end

	public

		def initialize(buffer)
			@buffer = buffer
		end

		def each(&block)
			to_str.each_char(&block)
		end

		def start(i = @buffer.index)
			return 0 if i == 0
			(e = @buffer.data.rindex(Ruvim::API::CR, i-1)) ? e+1 : 0
		end

		def end(i = @buffer.index)
			(e = @buffer.data.index(Ruvim::API::CR, i)) ? e : @buffer.eof
		end

		# Returns true if buffer is at the last line.
		def last?
			(self.end == @buffer.eof)	
		end

		# TODO Optimize
		def number
			@buffer.data[0..@buffer.index].count(Ruvim::API::CR)
		end

		def size
			self.end - self.start
		end

		def index(i)
			s = 0
			i.times do
				s = @buffer.data.index(Ruvim::API::CR, s)
				return "" unless s
				s += 1
			end

			@buffer.data[s ... line_end(s)]
		end
		
		# Returns Line
		def to_str
			@buffer.data[self.start ... line_end]	
		end

		# Returns Line + CR chars
		def to_s
			@buffer.data[self.start .. self.end]
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
