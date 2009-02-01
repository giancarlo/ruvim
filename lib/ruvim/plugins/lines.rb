#
# Line Number Display - Ruvim!
#

module Ruvim

	module API
		
		# Show line numbers
		def number
			editor.linenumbers.show
		end

		def nonumber
			editor.linenumbers.hide
		end

	end

	class LineNumbers < Ruvim::Window

		attr_accessor :color

		def visible?
			return @editor.visible?
		end

		def initialize(editor)
			super editor.parent
			@editor = editor
			@width  = 4
			@color  = Curses.color_pair(3)
			self.alignment= :left
		end

		def redraw
			@window.clear
			@window.attron(@color)

			(@editor.page.start .. @editor.page.end).each_with_index do |k, n|
				@window.setpos(n, 0)
				@window.addstr(k.to_s.rjust(@width-1))
			end

			# This is for update routine.
			@lines = @editor.lines
			@start = @editor.page.start

			@window.attroff(@color)
		end

		def update(k)
			self.redraw if @editor.lines != @lines || @editor.page.start != @start
		end

	end

	Plugin::Editor.register(:linenumbers, LineNumbers)

end
