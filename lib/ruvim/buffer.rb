#
# Ruvim - Buffer Class
#

module Ruvim

	class Buffer
		
		attr_reader :data, :index
		attr_accessor :readonly

		def initialize(initial_data=nil)
			@data  = ''
			@index = 0
			@changed = false
			@line  = Ruvim::Line.new(self)

			load(initial_data) if initial_data
		end

		#
		# Status Functions
		#
		def changed?
			@changed
		end

		# Mark Buffer as changed.
		def touch
			@changed = true
		end

		#
		# Position Functions
		#
		
		# Are we at the end?
		def at_end?
			@index == size
		end

		def at_start?(pos=@index)
			pos == 0
		end

		def at_eol?
			at_end? || (char == "\n")
		end

		def at_bol?
			at_start? || (@data[@index-1] == "\n")
		end

		#
		# Buffer Information Routines
		#

		# Returns size of buffer
		def size
			@data.size
		end

		# Returns Current Line
		def line
			@line
		end

		# Returns EOF index
		def eof
			@data.size
		end

		# Returns string from index to end of line.
		def to_eol
			@data[@index .. line.end]
		end

		# Returns string from index to beggining of line.
		def to_bol
			@data[line.start ... @index]
		end

		def to_end
			@data[@index .. size]
		end

		# Returns string from index to start. Does not include current char.
		def to_start
			@data[0 ... @index]
		end
		
		# Returns current char
		def char
			@data[@index]
		end

		# 
		# Movement Routines
		#
		
		def reset
			@index = 0
		end

		def goto(i)
			@index = i #.nil? ? size : i
			self
		end

		# Gets index of Line number n. Returns EOF if not found.
		def line_index(n)

			i = 0
			n.times do
				i = @data.index(Ruvim::API::CR, i)
				return eof if i == nil
				i += 1 
			end
			i
		end

		def goto_line(ln)
			goto(line_index(ln))
		end

		def goto_eol
			goto(line.end)
		end

		def goto_bol
			goto(line.start)
		end

		def goto_end
			goto(size)
		end

		# Goes back l spaces
		def back(l=1)
			forward(-l)
		end

		def forward(l=1)
			@index += l
			if (@index > size) then
				@index = size
			elsif @index < 0 then
				@index = 0
			end
			self
		end

		#
		# Edition Routines
		#

		# Removes char from buffer
		def remove
			@data.slice!(@index)
			@index -= 1 if @index > size
			touch
			self
		end

		# Insert what into buffer
		def insert(what)
			raise "Buffer is READ-ONLY" if readonly
			@data.insert(@index, what)
			touch
			self
		end

		def load(data)
			@data.replace data
			@changed = false
			reset
		end

		# Writes contents of buffer in the specified Stream stream.
		def write(stream)
			stream.write(@data)
			@changed = false
		end

		#
		# Syntactic Sugar
		#
		def [](index_or_range)
			@data[index_or_range]
		end

	end

end
