#
# Ruvim - Editor Class
#
require 'ruvim/window'
require 'ruvim/modes'
require 'ruvim/bindings'
require 'ruvim/buffer'
require 'ruvim/page'

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

		def initialize_page
			@page = Ruvim::Page.new(self, 0, @buffer.data.lines.count)
		end

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

		def initialize_buffer
			@lines  = 0
			@buffer = Ruvim::Buffer.new
		end

	public

		def initialize(parent)
			initialize_modes
			initialize_buffer
			initialize_page
			
			super
			self.align=(:client)
			@window.scrollok true
			@tabsize = Curses.TABSIZE

			initialize_plugins
		end

		# Redraws screen
		def redraw
			@window.clear
			@window.addstr(@buffer.data)
			@cursor.restore
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
		
		# Return current char length
		def char_size
			case @buffer.char
			when "\t"
				Curses.TABSIZE
			else
				1
			end
		end
	
		# Return max column
		def column_max
			@buffer.line.size #  - (@mode == :insert ? 0 : 1)
		end

		# Return number of lines
		# TODO Optimize this
		def lines
			@buffer.data.lines.count
		end

		def line_number
			@page.start + @cursor.y
		end

		# Returns Space occupied by the line in the display. If 'col' is given
		# it returns the space occupied by 'col' characters.
		def line_space(col=@buffer.line.end)
			s = 0
			@buffer.data[@buffer.line.start ... col].each_char do |k|
				case k
				when "\t"
					s += tab(s)
				else
					s += 1
				end
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
