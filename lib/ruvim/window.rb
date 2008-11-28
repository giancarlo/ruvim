#
# Window Class for Ruvim
#

require 'curses'

module Ruvim


	class Window

		# This tell us the space available for alignment.
		# NOTE Make sure Curses is initialized

		# Refreshes all the windows
		def refresh
			Curses.curs_set(0)
			@windows.each { |w| w.refresh if w.visible? }
			@window.refresh
			Curses.curs_set(1)
		end

		# Called when window receives input. k: key code
		def update(k)
			Curses.curs_set(0)
			@windows.each { |w| w.update(k) if w.visible? }
			Curses.curs_set(1)
		end

		# Registers Windows. If after is provided is inserted after that window. after is a Window Object.
		def register(w, after=nil)
			(after) ? (@windows.insert(@windows.index(after), w)) : (@windows << w)
		end

		def unregister(w)
			@windows.delete(w)
		end

		def reset_client
			@client[0] = 0; @client[1] = 0; @client[2] = @width; @client[3] = @height
		end

		def rearrange
			reset_client
			clients = []

			@windows.each do |w|
				(w.align == :client) ? (clients << w) : (w.align=(w.align) if w.visible?)
			end

			clients.each do |w|
				(w.align=w.align if w.visible?)
			end
		end

	private

		def align_top
			move(@parent.client[0], @parent.client[1], @parent.client[2], @parent.height)
			@parent.client[1]	+= @height
			@parent.client[3]	-= @height
		end

		def align_bottom
			@parent.client[3] -= @height
			move(@parent.client[0], @parent.client[3], @parent.client[2], @height)
		end

		def align_client
			move(@parent.client[0], @parent.client[1], @parent.client[2], @parent.client[3])
		end

		def align_left
			move(@parent.client[0], @parent.client[1], @width, @parent.client[3])
			@parent.client[0] += @width
			@parent.client[2] -= @width
		end

		def align_right
			@parent.client[2] -= @width
			move(@parent.client[0], @parent.client[2], @width, @parent.client[3])
		end

	public

		attr_reader :x, :y, :width, :height
		attr_reader :window, :cursor, :client, :parent

		def initialize(parent=$ruvim)
			@window = Curses::Window.new(0,0, 0, 0)
			@client = [0,0, @width, @height]
			@parent = parent

			@cursor = Ruvim::Cursor.new(@window)
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

			reset_client
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
