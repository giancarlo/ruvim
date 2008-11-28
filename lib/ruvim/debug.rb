#
# Debug Module for Ruvim
#

module Ruvim

	class Debug < Ruvim::Window

		def initialize
			super

			@height = 14
			self.align=(:bottom)
		end

		def redraw
			update(@lastkey)
		end

		def update(k)
			@window.setpos(0, 0)
			i = $ruvim.editor.buffer.index
			le= $ruvim.editor.buffer.line.end
			fs= $ruvim.editor.buffer.data.size
			c = $ruvim.editor.buffer.char.inspect rescue nil
			kc= k.bytes.next rescue nil
			lkc=@lastkey.bytes.next rescue ''
			ln =$ruvim.editor.line_number
			lc =$ruvim.editor.lines

			@window.addstr("Key: #{k}(#{kc}); LastKey: #{@lastkey}(#{lkc}) #{i}/#{le}/#{fs} (#{c})".ljust(50))
			@window.setpos(1,0)
			@window.addstr("Line #: #{ln}/#{lc}")
			@window.setpos(2,0)
			@window.addstr($ruvim.editor.buffer.data)

			@lastkey = k
		end

	end

	module API

		def module_reload(unit)
			$".delete(unit)
			require unit
		end

	end

	Plugin.register(:debug, Debug.new)

end

