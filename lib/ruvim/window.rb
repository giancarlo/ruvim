#
# Window Class for Ruvim
#

require 'curses'
require 'ruvim/arrange'

module Ruvim


	class Window

		attr_reader :x, :y, :width, :height
		attr_reader :window, :cursor, :client, :parent

		# This tell us the space available for alignment.
		# NOTE Make sure Curses is initialized

		# Refreshes all the windows
		def refresh
			@cursor.hide
			@window.refresh
			@windows.each { |w| w.refresh if w.visible? }
			@cursor.show
		end

		# Called when window receives input. k: key code
		def update(k)
			@cursor.hide
			@windows.each { |w| w.update(k) if w.visible? }
			@cursor.show
		end

		# Registers Windows. If after is provided is inserted after that window. after is a Window Object.
		def register(w, after=nil)
			(after) ? (@windows.insert(@windows.index(after), w)) : (@windows << w)
		end

		def unregister(w)
			@windows.delete(w)
		end


		def initialize(parent=$ruvim)
			@window = Curses::Window.new(0,0, 0, 0)
			@cursor = Ruvim::Cursor.new(@window)
			@client = [0,0, @width, @height]
			@parent = parent

			@windows = Array.new
			
			parent.register(self)
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
			parent.rearrange
			rearrange
		end

		def align
			@align
		end


		def redraw
			if @caption then
				@window.setpos(0,0)
				@window.addstr('=' + @caption.ljust(@width-1, '='))
			end
		end

		def show
			move(@x, @y, @width, @height)
			redraw
			@visible = true
			parent.rearrange
			rearrange
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
