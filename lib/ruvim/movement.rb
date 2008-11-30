#
# Ruvim Movement Routines
#

module Ruvim

	class Editor < Ruvim::Window

		# Returns the Space occupied by the char at position s. s is optional but
		# TABS will not return correct size if s is not present.
		def char_space(k=@buffer.char, s=@cursor.x)
			case k
			when "\t";	return tab(s)
			else; return 1
			end
		end

		# Get the correct position of the cursor from any point in the screen
		def correct_pos(x)
			s = 0; i = 0
			@buffer.line.each do |k|
				d = char_space(k,s)
				return [s, i] if s+d > x
				s += d; i += 1
			end

			return [s, i]
		end

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
		
			@buffer.goto_bol.back

			nx, i = correct_pos(@cursor.x)
			@buffer.back(@buffer.line.size - i)
			@cursor.x = nx

			self
		end

		def back
			@buffer.back
			if @cursor.x == 0 then
				up(line_space)
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
				
				@buffer.goto_eol.forward

				nx, i = correct_pos(@cursor.x)
				@buffer.forward(i)
				@cursor.x = nx
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
