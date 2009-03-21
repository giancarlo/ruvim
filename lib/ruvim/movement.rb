#
# Ruvim Movement Routines
#

module Ruvim

	class Editor < Ruvim::Window

	private

		# Returns the Space occupied by the char at position s. s is optional but
		# TABS will not return correct size if s is not present. s is the position
		# of the cursor within the line.
		def char_space(k=@buffer.char, s=@cursor.x)
			case k
			when "\t";	return tab(s)
			else; return 1
			end
		end

		# Get the correct x position of the cursor from any point in the screen
		#
		# x is the physical column x position of the current line.
		#
		# Returns array with [space, index]
		#
		def correct_pos(x)
			s = 0; i = 0; d=0

			return [0, 0] if (line.to_str == '')
			
			@buffer.line.to_s.each_char do |k|
				d = char_space(k,s)
				return [s, i] if s+d > x
				s += d; i += 1
			end

			return [s-d, i-1]
		end

		# Returns Space Occupied by Tab at 'cx' position
		def tab(cx=@cursor.x)
			tabsize - cx % tabsize
		end

	public

		# Moves Cursor Up
		def up(col=nil)

			if (@cursor.at_sow?)
				if (@page.start > 0) then
					@page.scroll_up
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
			unless @buffer.line.last?
				if (@cursor.at_eow?) then
					@page.scroll_down
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

		# Gets X, Y Coordinate of index in screen.
		# Returns nil if Outside String
		def get_pos(index)
			
			ln = @buffer.line.number

			return nil unless page.range.include? ln

			[line_space(index), ln - page.start]
		end
		
		# Goto the position for buffer[index]
		def goto(index)
			@buffer.goto index
			ln= @buffer.line.number
			
			page.start= ln unless page.range.include? ln
			
			# set cursor position
			@cursor.y = ln - page.start
			@cursor.x = line_space(index)

			self
		end

		# Moves to Line Number num.
		def goto_line(num)
			@buffer.goto_line num
			num = @buffer.line.number

			page.start= num unless page.range.include? num
			
			@cursor.y = num - page.start
			@cursor.x = 0

			self
		end

		def goto_lastline
			down while (buffer.line.end < @buffer.size)
		end

		def goto_bol
			@cursor.x = 0
			(@buffer.index - @buffer.line.start).times { @buffer.back }
			self
		end

		def goto_eol
			(@buffer.line.end - @buffer.index).times { forward }
			self
		end

	end

end
