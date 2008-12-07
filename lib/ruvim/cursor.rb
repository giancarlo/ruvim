#
# Cursor Class
#

module Ruvim

	class Cursor

		attr_accessor :x, :y

		def initialize(win, x=0, y=0)
			@window = win
			@x = x; @y =y
			restore
		end

		# Moves Cursor
		def restore
			@window.setpos(@y, @x)
		end

		def visible?
			@visible
		end

		def position
			[@x, @y]
		end

		def move(nx, ny)
			@x = nx; @y = ny
		end

		def show
			Curses.curs_set(1)
		end

		def hide
			Curses.curs_set(0)
		end

		def up(unit=1)
			down(-unit)
		end

		def down(unit=1)
			@y += unit
		end

		def left(unit=1)
			right(-unit)
		end

		def right(unit=1)
			@x += unit
		end

		def reset
			@x = @y = 0
		end

		# At End of Window?
		def at_eow?
			@y == @window.maxy-1
		end

		# At Start of Window?
		def at_sow?
			@y == 0
		end

	end

end
