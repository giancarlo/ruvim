#
# Ruvim - Buffer Class
#

module Ruvim

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

		# Returns string from index to end of line. Does not include CR
		def to_eol
			@data[@index.. line.end]
		end

		# Returns string from index to beggining of line.
		def to_bol
			@data[line.start ... @index]
		end

		def to_end
			@data[@index .. size]
		end

		def to_start
			@data[0 .. @index]
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
			@index = line.end;	self
		end

		def goto_bol
			@index = line.start; self
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
			#@index += what.size
			self
		end

		#
		# Syntactic Sugar
		#
		def [](index_or_range)
			@data[index_or_range]
		end

	end

end
