#
# Ruvim Movement Routines
#

module Ruvim

	class Editor < Ruvim::Window

	REGEX_WORD = /\w/
	REGEX_SPACE = /\s/

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
		# Returns nil if position is outside the screen 
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
			
			@cursor.move(line_space(index), ln - page.start).restore

			self
		end

		# Moves to Line Number num.
		def goto_line(num)
			goto buffer.line_index(num)
		end

		def goto_lastline
			goto @buffer.size
		end

		def goto_firstline
			goto 0
		end

		def goto_bol
			goto @buffer.line.start
		end

		def goto_eol
			goto @buffer.line.end
		end

		def goto_next_word
			if buffer.char && buffer.char.match(REGEX_WORD)
				buffer.forward
				buffer.forward while buffer.char.match REGEX_WORD
			else
				buffer.forward
			end

			buffer.forward while buffer.char && buffer.char.match(REGEX_SPACE)
			goto(buffer.index)
		end

		def goto_previous_word
			if buffer.char && buffer.char.match(REGEX_WORD)
				buffer.back
				buffer.back while (buffer.char.match(REGEX_WORD))
			else
				buffer.back
			end
			buffer.back while buffer.char.match REGEX_SPACE
			buffer.back while (buffer.char.match(REGEX_WORD))

			goto buffer.index
		end

	end

end
