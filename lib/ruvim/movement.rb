#
# Ruvim Movement Routines
#

module Ruvim

	class Editor < Ruvim::Window

		def up(col=nil)

			if (@cursor.at_sow?)
				if (@page.start > 0) then
					@page.scroll_up
					redraw_line(0 ... @height)
				else
					return self
				end
			else
				@cursor.up
			end

			if col then
				@cursor.x = col
				return self
			end
			
			s = @buffer.line.previous.size
			
			if (s < @cursor.x) then
				@cursor.x = s
				@buffer.goto_bol.back
			else
				@buffer.goto_bol.back(s-@cursor.x+1)
			end

			self
		end

		def back
			@buffer.back
			if @cursor.x == 0 then
				up(@buffer.line.size)
			else
				if (@buffer.char == "\t") then
					@cursor.x = line_space(@buffer.index)
				else
					@cursor.left
			    end	
				self
			end
		end

		# Returns Space Occupied by Tab at 'cx' position
		def tab(cx=@cursor.x)
			@tabsize - cx % @tabsize
		end

		def forward
			case @buffer.char
			when "\n", nil
				return self
			when "\t"
				@cursor.x += tab
			else
				@cursor.right
			end

			@buffer.forward

			self
		end

		def down
			if (@buffer.line.end < @buffer.size)
				if (@cursor.at_eow?) then
					@page.scroll_down
					redraw_line(0...@height)
				else
					@cursor.down
				end
				
				nls = @buffer.line.next.size
				@cursor.x= (nls < @cursor.x) ? nls : @cursor.x
				@buffer.goto_eol.forward(@cursor.x+1)
			end
			self
		end

		def goto_bol
			@cursor.x = 0
			(@buffer.index - @buffer.line.start).times { @buffer.back }
		end

		def goto_eol
			(@buffer.line.end - @buffer.index).times { forward }
		end

	end

end
