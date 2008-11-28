#
# Window Class for Ruvim
#

require 'curses'

module Ruvim


	class Window

		# This tell us the space available for alignment.
		# NOTE Make sure Curses is initialized
		Client = [0,0, Curses.cols, Curses.lines]
		
		@windows = Array.new

		# Refreshes all the windows
		def self.refresh
			@windows.each { |w| w.refresh if w.visible? }
		end

		def self.update(k)
			@windows.each { |w| w.update(k) if w.visible? }
		end

		def self.register(w)
			@windows << w
		end

		def self.unregister(w)
			@windows.delete(w)
		end

		def self.reset_client
			Client[0] = 0; Client[1] = 0; Client[2] = Curses.cols; Client[3] = Curses.lines
		end

		def self.rearrange
			self.reset_client

			@windows.each do |w|
				w.align=(w.align) if w.visible?	
			end
		end

	private

		def align_top
			move(Client[0], Client[1], Client[2], @height)
			Client[1]	+= @height
			Client[3]	-= @height
		end

		def align_bottom
			Client[3] -= @height
			move(Client[0], Client[3], Client[2], @height)
		end

		def align_client
			move(Client[0], Client[1], Client[2], Client[3])
		end

		def align_left
			move(Client[0], Client[1], @width, Client[3])
			Client[0] += @width
			Client[2] -= @width
		end

		def align_right
			Client[2] -= @width
			move(Client[0], Client[2], @width, Client[3])
		end

	public

		attr_reader :x, :y, :width, :height
		attr_reader :window, :cursor

		def initialize
			@window = Curses::Window.new(0,0,0,0)
			@cursor = Ruvim::Cursor.new(@window)
			Window.register(self)
			@visible= true
		end

		def close
			Window.unregister(@window)
			@window.close
		end

		def hide
			@window.clear
			move(0,0,0,0)
			@visible = false
			Window.rearrange
		end

		def align
			@align
		end

		# Aligns window to :top, :left, :right, :bottom or :client
		def align=(where)
			@align = where
			return unless visible?
			case where
			when :top
				align_top
			when :bottom
				align_bottom
			when :left
				align_left
			when :right
				align_right
			when :client
				align_client
			else
				raise "Invalid Alignment."
			end
		end

		def show
			move(@x, @y, @width, @height)
			redraw
			@visible = true
			Window.rearrange
		end

		# Override this function to clear and redraw
		def refresh
			@window.refresh
		end

		# Override this function to paint the window
		# key is the last key pressed.
		def update(key)
		end

		def move(x,y,w,h)
			@x = x; @y = y; @width = w; @height = h
			@window.resize(h,w)
			@window.move(y,x)
			
			# make sure the damn thing moved
#			raise "Window was not moved." if (@x != )
		end

		def visible?
			@visible
		end

	end

end
