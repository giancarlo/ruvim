#
# Debug Module for Ruvim
#

module Ruvim

	class Debug < Ruvim::Window

		def initialize
			@lastkey = ''
			super
			@caption = " Debug "
			@height = 14
			self.alignment= :bottom
		end

		def redraw
			update(@lastkey)
			super
		end

		def print(row, what)
			@window.setpos(row,0)
			@window.addstr(what.ljust(@width))
		end

		def update(k)
			@window.setpos(1, 0)
			i = $ruvim.editor.buffer.index
			le= $ruvim.editor.buffer.line.end
			fs= $ruvim.editor.buffer.data.size
			c = $ruvim.editor.buffer.char.inspect
			kc= k.bytes.next rescue nil
			lkc=@lastkey.bytes.next rescue ''
			ln =$ruvim.editor.line_number
			lc =$ruvim.editor.lines
			ps = $ruvim.editor.page.start
			pe = $ruvim.editor.page.end
			cx = $ruvim.editor.cursor.x
			cy = $ruvim.editor.cursor.y

			print 1, "Key: #{k}(#{kc}); LastKey: #{@lastkey}(#{lkc}) #{i}/#{le}/#{fs} (#{c})"
			print 2, "Line #: #{ln}/#{lc}\tPage: (#{ps}-#{pe})\tCursor: #{cx}, #{cy}"
			print 3, "Current Line: " + $ruvim.editor.buffer.line
			print 4, "$stderr: " + $stderr.string rescue nil

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

