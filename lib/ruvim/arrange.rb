#
# Arrangement routines for Ruvim
#

module Ruvim

	class Window

	private

		def align_top
			move(@parent.client[0], @parent.client[1], @parent.client[2], @parent.height)
			@parent.client[1]	+= @height
			@parent.client[3]	-= @height
		end

		def align_bottom
			@parent.client[3] -= @height
			move(@parent.client[0], @parent.client[3], @parent.client[2], @height)
		end

		def align_client
			move(@parent.client[0], @parent.client[1], @parent.client[2], @parent.client[3])
		end

		def align_left
			move(@parent.client[0], @parent.client[1], @width, @parent.client[3])
			@parent.client[0] += @width
			@parent.client[2] -= @width
		end

		def align_right
			@parent.client[2] -= @width
			move(@parent.client[0], @parent.client[2], @width, @parent.client[3])
		end

	public

		def reset_client
			@client[0] = 0; @client[1] = (@caption ? 1 : 0);
			@client[2] = @window.maxx; @client[3] = @window.maxy
		end

		def rearrange
			@cursor.hide

			reset_client
			clients = []

			@windows.each do |w|
				(w.alignment == :client) ? (clients << w) : w.align
			end

			clients.each do |w|
				w.align
			end

			@cursor.show
		end

		# Aligns window to :top, :left, :right, :bottom or :client
		def alignment=(where)
			@align = where
			align
		end

		def alignment()
			@align
		end

		def align
			return unless visible?

			case @align
			when :top
				align_top
			when :bottom
				align_bottom
			when :left
				align_left
			when :right
				align_right
			when :client
				align_client
			else
				raise "Invalid Alignment."
			end

			rearrange
			redraw
		end
	end
end
