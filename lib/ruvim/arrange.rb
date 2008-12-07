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
			@client[2] = @width; @client[3] = @height
		end

		def rearrange
			reset_client
			clients = []

			@windows.each do |w|
				(w.align == :client) ? (clients << w) : (w.align=(w.align) if w.visible?)
			end

			clients.each do |w|
				(w.align=w.align if w.visible?)
			end
		end

		# Aligns window to :top, :left, :right, :bottom or :client
		def align=(where)
			@align = where
			return unless visible?
			case where
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

			reset_client
			redraw
		end
	end
end
