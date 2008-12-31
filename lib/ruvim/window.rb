#
# Window Class for Ruvim
#

require 'curses'
require 'ruvim/arrange'

module Ruvim


	class Window

		attr_reader :x, :y, :width, :height
		attr_reader :window, :cursor, :client, :parent

		# Refreshes window and its children.
		def refresh
			@window.refresh
			@windows.each { |w| w.refresh if w.visible? }
		end

		# Called when window receives input. k: key code
		def update(k)
			@windows.each { |w| w.update(k) if w.visible? }
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
			@width = 0; @height = 0
			@caption = false
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
			@windows.each { |w| w.hide }
			parent.rearrange
		end

		def redraw
			if @caption then
				@window.setpos(0,0)
				@window.addstr('=' + @caption.ljust(@width-1, '='))
			end
			# Redraw goddamn children
			@windows.each { |w| w.redraw if w.visible? }
		end

		def show
			move(@x, @y, @width, @height)
			@visible = true
			parent.rearrange
			rearrange
		end

		def move(x,y,w,h)
			@x = x; @y = y; @width = w; @height = h
			@window.resize(h,w)
			@window.move(y,x)
		end

		def visible?
			@visible
		end

	end

end
