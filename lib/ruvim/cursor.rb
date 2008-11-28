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

		def show
			@visible = true
		end

		def hide
			@visible = false
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

	end

end
