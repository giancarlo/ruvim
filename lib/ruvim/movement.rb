#
# Ruvim Movement Routines
#

module Ruvim

	class Editor < Ruvim::Window

		def up(col=nil)

			return self if (@cursor.y == 0)
			@cursor.up

			if col then
				@cursor.x = col
				return self
			end
			
			s = @buffer.previous_line.size
			
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
				@cursor.left
				self
			end
		end

		def forward
			#unless [nil, Ruvim::API::CR].include? @buffer.char then
			if (@cursor.x < column_max) then
				@buffer.forward
				@cursor.right
			end
		end

		def down
			# This doesnt work because lines do not return correct line count if
			# the text after the \n is empty
			# if (row < lines-1) then 

			if (@buffer.line_end < @buffer.size)
				nls = @buffer.next_line_size
				@cursor.x= (nls < @cursor.x) ? nls : @cursor.x
				@cursor.down
				@buffer.goto_eol.forward(@cursor.x+1)
			end
		end

		def goto_bol
			(@buffer.index - @buffer.line_start).times { back }
		end

		def goto_eol
			(@buffer.line_end - @buffer.index).times { forward }
		end

	end

end
