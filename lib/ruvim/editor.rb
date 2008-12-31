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

		attr_reader :buffer, :file
		attr_reader :selection
		attr_reader :modes
		attr_reader :page
		attr_reader :plugins
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

	public

		def initialize(parent)
			initialize_modes
			@buffer = Buffer.new
			@page 	= Page.new(self)
			@line 	= Segment.new(self, 0, 0)
			@timeout  = 1000
			@tabsize = Curses.TABSIZE
			@selection = Segment.new(self, 0, 0)
			
			super
			self.alignment=(:client)
			@window.scrollok true

			initialize_plugins
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
		end

		def redraw_char(c)
				
		end

		# Takes ranges
		def redraw_line(line=@cursor.y)
			if line.class == Range then
				line.each { |r| redraw_line(r) }
			else
				@window.setpos(line, 0)
				l = @buffer.line.index(@page.start + line)
				@window.addstr(l)
				@window.clrtoeol
			end
		end
		
		#
		#	Window Routines
		#
		def update(key)
			# Do Nothing because the application gives priority to self.process
		end

		#
		#	Edition Routines
		#

		def insert(k)
			if k == Ruvim::API::CR then
				cr
			else
				@window.addch k
				@buffer.insert k
				@changed = true
				forward
				redraw_line
			end
			self
		end
		
		def remove
			return if (@buffer.at_end?)
			ch = @buffer.char
			@buffer.remove
			@changed = true
			redraw_line((ch == Ruvim::API::CR) ? (@cursor.y ... @height) : @cursor.y) 
			self
		end

		# Return number of lines
		# TODO Optimize this
		def lines
			@buffer.data.count(Ruvim::API::CR)
		end

		# Returns Segment of current line.
		def line
			@line.set(buffer.line.start, buffer.line.end)
		end

		def line_number
			@page.start + @cursor.y
		end

		# Returns Space occupied by the line in the display. If 'col' is given
		# it returns the space occupied by 'col' characters.
		def line_space(col=@buffer.line.end)
			s = 0
			@buffer[@buffer.line.start ... col].each_char do |k|
				s += char_space(k, s)
			end

			s
		end

		def cr
			oy = @cursor.y
			@buffer.insert Ruvim::API::CR
			redraw_line(oy ... @height)
			down.goto_bol
		end

	end

end
