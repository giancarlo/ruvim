#
# Debug Module for Ruvim
#

module Ruvim

	class Debug < Ruvim::Window

		def initialize
			super
			@caption = "Debug"
			@height = 14
			self.align=(:bottom)
		end

		def redraw
			update(@lastkey)
			super
		end

		def update(k)
			@window.setpos(1, 0)
			i = $ruvim.editor.buffer.index
			le= $ruvim.editor.buffer.line.end
			fs= $ruvim.editor.buffer.data.size
			c = $ruvim.editor.buffer.char.inspect rescue nil
			kc= k.bytes.next rescue nil
			lkc=@lastkey.bytes.next rescue ''
			ln =$ruvim.editor.line_number
			lc =$ruvim.editor.lines
			ps = $ruvim.editor.page.start
			pe = $ruvim.editor.page.end
			cx = $ruvim.editor.cursor.x
			cy = $ruvim.editor.cursor.y

			@window.addstr("Key: #{k}(#{kc}); LastKey: #{@lastkey}(#{lkc}) #{i}/#{le}/#{fs} (#{c})".ljust(50))
			@window.setpos(2,0)
			@window.addstr("Line #: #{ln}/#{lc}\tPage: (#{ps}-#{pe})\tCursor: #{cx}, #{cy}")
			@window.setpos(3,0)
			@window.addstr($ruvim.editor.buffer.data.ljust(@width))

			@lastkey = k
		end

	end

	module API

		def module_reload(unit)
			$".delete(unit)
			require unit
		end

	end

	Plugin::Application.register(:debug, Debug)

end

