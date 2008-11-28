#
# Ruvim - Buffer Class
#

module Ruvim

	module API
		
		# Returns Current Buffer
		def buffer
			editor.buffer
		end

	end

	class Buffer
		
		attr_reader :index, :data

		def initialize(data='', index=0)
			@data 		= data
			@index		= index
			@line		= Ruvim::Line.new(self)
		end

		#
		# Position Functions
		#
		
		# Are we at the end?
		def at_end?
			@index == size
		end

		def at_beginning?(pos=@index)
			pos == 0
		end

		def at_eol?
			@index == line_end
		end

		#
		# Buffer Information Routines
		#

		# Returns size of buffer
		def size
			@data.size
		end

		def line
			@line
		end
		
		# Return Line string at Index.
		def line_index(i)
			x = 0
			i.times do
				x = @data.index(Ruvim::API::CR, x)
				return "" unless x
				x += 1
			end
			
			@data[x ... line_end(x)]
		end

		# TODO Optimize!
		def next_line_size
			next_line.size
		end

		# Returns string from index to end of line. Does not include CR
		def to_eol
			@data[@index.. line_end]
		end

		# Returns string from index to beggining of line.
		def to_bol
			@data[line_start ... @index]
		end
		
		def previous_line
			e = line_start-1
			return nil if e == -1
			s = line_start(e)
			@data[s ... e]
		end

		def next_line
			s = line_end+1
			return "" if s >= size
			e = line_end(s)
			@data[s ... e]			
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

		def goto_eol
			@index = line_end;	self
		end

		def goto_bol
			@index = line_start; self
		end

		# Goes back l spaces
		def back(l=1)
			forward -l
		end

		def forward(l=1)
			@index += l
			if (@index >= @data.size) then
				@index = @data.size
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
			(@index ... @data.size-1).each do |k|
				@data[k] = @data[k+1]
			end
			
			@data.chop!
			self
		end

		# Insert what into buffer
		def insert(what)
			@data.insert(@index, what)
			@index += what.size
			self
		end

	end

end
