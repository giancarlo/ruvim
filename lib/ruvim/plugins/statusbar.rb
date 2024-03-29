#
# Ruvim - StatusBar class
#
# TODO Remove @application later.

module Ruvim

	# You may want to consider moving this class somewhere else for the sake of being cool
	class Panel
		
		attr_reader :text
		attr_accessor :statusbar
	
		# 
		# column 	Column where the panel should be display. 
		# 			If negative it is calculated as to Curses.cols-column
		# length 	Percentage of the screen(float) or fixed value(int)
		# minlen 	Minimum length of the panel
		# text 		Default text of the panel
		#
		def initialize(sb, column, length, minlen, text='')
			@statusbar = sb
			@col	= column
			@length = length
			@minlen = minlen
			@text   = text
		end

		# Returns Physical Length (Not percentage)
		def length
			len = (@length.integer?) ? @length : (@statusbar.width * @length)
			len = @minlen if (len < @minlen)

			return len
		end

		# Returns Column of the panel
		def column
			(@col < 0) ? @statusbar.width+@col : @col				
		end

		def erase
			self.print " " * length
		end

		# TODO change the row to allow a multirow statusbar
		def print(t)
			@statusbar.window.setpos(0, column)
			@statusbar.window.addstr(t.to_s.ljust(length)) unless t.nil?
			@statusbar.refresh
			t
		end

		# Displays message on panel
		def display(msg)
			self.print(@text = msg)
		end

		def refresh
			self.print(@text)
		end

	end

	class StatusBar < Ruvim::Window

		attr_reader :panels

		def initialize
			super

			@panels		 = Hash.new

			@height = 1
			self.alignment= :bottom
			
			add_panel(:default, Panel.new(self, 0, 0.8, 20))
			add_panel :position, Panel.new(self, -16, 10, 10)
			add_panel :mode, Panel.new(self, -2, 1, 1)
		end

		def update(k)
			panels[:mode].display $ruvim.editor.mode.abbr
			panels[:position].display("#{$ruvim.editor.page.start + $ruvim.editor.cursor.y}, #{$ruvim.editor.cursor.x}")
		end

		def redraw
			@panels.each_value { |k| k.refresh }
		end

		def add_panel(name, panel) 
			@panels[name] = panel
		end

	end

	class Application
		
		def message(msg, color=:plain)
			message_setup color, statusbar.window do
				statusbar.panels[:default].display(msg)
			end
		end

		def reset_client
			@client[0] = 0; @client[1] = 0
			@client[2] = Curses.cols; @client[3] = Curses.lines
		end

	end

	Plugin::Application.register(:statusbar, StatusBar)

end
