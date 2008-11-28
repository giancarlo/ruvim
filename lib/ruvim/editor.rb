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

		def initialize
			super
			self.align=(:client)

			initialize_modes
			initialize_buffer
			initialize_page
			initialize_plugins
		end

		# Redraws screen
		def redraw
			@window.clear
			@window.addstr(@buffer.data)
			restore
		end

		# Takes ranges
		def redraw_line(line=@cursor.y)
			if line.class == Range then
				line.each { |r| redraw_line(r) }
			else
				@window.setpos(line, 0)
				
				#l = (line==@row) ? @buffer.line : @buffer.line_index(page.start + line)
				# Fix this
				l = @buffer.line_index(page.start+line)
				@window.addstr(l.ljust(@width))
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
			return if (@buffer.at_end?)
			ox = @cursor.x
			oy = @cursor.y
			@buffer.remove
			redraw_line((ox == 0) ? (oy ... @height) : oy) 
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

		# TODO Fix this shit
		def line_number
			@page.start + @cursor.y
		end

		def cr
			@buffer.insert Ruvim::API::CR
			@cursor.x = 0
			redraw_line(@cursor.y .. self.lines)

			@cursor.down
			@lines += 1				
		end

	end

end
