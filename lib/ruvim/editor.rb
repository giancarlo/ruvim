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
		attr_reader :active
		attr_reader	:bindings
		attr_reader :modes
		attr_reader :page
		attr_reader :plugins
		
		Plugins = Hash.new

	public :eval
	
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
			
			super
			self.alignment=(:client)
			@window.scrollok true
			@tabsize = Curses.TABSIZE

			initialize_plugins
		end

		# Redraws screen
		def redraw
			redraw_line(0...@height)
		end

		# Set cursor and buffer position to 0
		def reset
			@cursor.reset
			@buffer.reset
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

		# This processes the keys sent by the application.
		# This method exists because update order conflicts with input.
		def process(key)
			mode.bindings.process key
		end

		#
		#	Edition Routines
		#

		def insert(k)
			@window.addch k
			@buffer.insert k
			forward
			redraw_line
		end
		
		def remove
			# Can't remove nil
			return if (@buffer.at_end?)
			ch = @buffer.char
			@buffer.remove
			redraw_line((ch == Ruvim::API::CR) ? (@cursor.y ... @height) : @cursor.y) 
		end

		#
		#	Movement Routines @ ruvim/movement.rb
		#

		
		#
		#	INFO CODE
		#
		
		# Return number of lines
		# TODO Optimize this
		def lines
			@buffer.data.lines.count
		end

		def line
			Segment.new(self, buffer.line.start, buffer.line.end)
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
