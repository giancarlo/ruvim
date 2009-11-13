#
# Ruvim - Editor Class
#
require 'ruvim/window'
require 'ruvim/modes'
require 'ruvim/bindings'
require 'ruvim/buffer'
require 'ruvim/page'
require 'ruvim/segment'

module Ruvim
	
	class Editor < Ruvim::Window

		attr_reader :buffer, :file, :selection, :modes, :page, :plugins
		attr_reader :event, :options
		# Input Timeout in millisecond for mappings
		attr_accessor :timeout
		
		Plugins = Hash.new
	private

		def initialize_plugins
			@plugins = Hash.new

			Plugins.each do |name, klass|
				@plugins[name] = klass.new(self)
				klass.mappings(self) if klass.respond_to? :mappings
			end

			$ruvim.plugins.each do |name, k|
				k.class.mappings(self) if k.class.respond_to? :mappings
			end
		end

		def initialize_options
			@options[:isfname] = /[A-Za-z0-9]\.?/ 
		end

	public

		def initialize(parent)
			initialize_modes
			@buffer = Buffer.new
			@page 	= Page.new(self)
			@line 	= Segment.new(self, 0, 0)
			@word   = Segment.new(self, 0, 0)
			@timeout  = 1000
			@tabsize = Curses.TABSIZE
			@selection = Segment.new(self, 0, 0)
			@event = Bindings.new
			@event.map(:origin) {}
			@options = {}
			
			super
			self.alignment=(:client)
			@window.scrollok true
			
			initialize_plugins
			initialize_options
		end

		def tabsize
			@tabsize
		end

		def tabsize=(value)
			@tabsize = value
			redraw
		end

		# Redraws screen
		def redraw
			Curses.TABSIZE= tabsize
			redraw_line(0...@height)
		end

		# Set cursor and buffer position to 0
		def reset
			@cursor.reset
			@buffer.reset
			@page.reset
		end

		# Sets Current Attribute executes block then returns to normal
		def attr(attrib)
			case attrib
			when :selection
				Curses.attron(Curses::A_REVERSE)
				yield
			end
			Curses.standend
		end

		# Takes ranges.
		# @param line Number of line relative to screen.
		def redraw_line(line=@cursor.y)
			if line.respond_to? :each then
				line.each { |r| redraw_line(r) }
			else
				l = @buffer.line.index(@page.start + line)
				@window.setpos(line, 0)
				@window.addstr(l)
				@window.clrtoeol
			end
		end

		#
		#	Window Routines
		#
		def update(key)
		end

		#
		#	Edition Routines
		#

		# Inserts character into the text at current position.
		def insert(k)
			if k == Ruvim::API::CR then
				cr
			else
				@window.addch k
				@buffer.insert k
				forward
				redraw_line
			end
			self
		end
		
		# Removes character at cursor.
		def remove
			back if (@buffer.at_end?)
			ch = @buffer.char
			@buffer.remove
			redraw_line((ch == Ruvim::API::CR) ? (@cursor.y ... @height) : @cursor.y) 
			self
		end

		# Return number of lines
		def lines
			@buffer.data.count(Ruvim::API::CR)
		end

		# Returns Segment of current line.
		def line
			@line.set(buffer.line.start, buffer.line.end)
		end

		# Returns Index for End of Word.
		def find_eow
			i = buffer.index
			i = i + 1 while ((buffer[i] != nil) && buffer[i].match(/\w/))
			return i
		end

		# Returns Segment of current word.
		def word
			@word.set(buffer.index, find_eow)
		end

		def find_pattern_forward(pat_str, s)
			s += 1 while pat_str.match(@buffer[s+1])
			s
		end

		def find_pattern_backward(pat_str, s)
			s -= 1 while pat_str.match(@buffer[s-1])
			s
		end

		def pattern(pat_str)
			s = @buffer.index

			if pat_str.match(@buffer[s]) then
				s = find_pattern_backward(pat_str, s)
				e = find_pattern_forward(pat_str, s)
				Ruvim::Segment.new(self, s, e)
			else
				nil
			end
		end

		def open_file_at_cursor
			open pattern(@options[:isfname])			
		end

		def line_number
			@page.start + @cursor.y
		end

		#
		# Returns Space occupied by the line in the display. If 'index' is given
		# it returns the space occupied by the characters from the start of the line
		# to buffer[index].
		#
		def line_space(index=@buffer.line.end)
			s = 0
			@buffer[@buffer.line.start ... index].each_char do |k|
				s += char_space(k, s)
			end
			
			s
		end

		#
		# Inserts a Carriage Return at cursor.
		#
		def cr
			oy = @cursor.y
			@buffer.insert Ruvim::API::CR
			redraw_line(oy ... @height)
			down.goto_bol
		end

	end

end
