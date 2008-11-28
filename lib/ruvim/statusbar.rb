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
			@statusbar.window.addstr(t.ljust(length))
			@statusbar.refresh
		end

		def update
			print(@text)
		end

		# Displays message on panel
		def display(msg)
#			erase()
#			l = length
			#@text = (msg.size > l) ? msg[0...l] : msg
			self.print(@text = msg)
		end

	end

	class StatusBar < Ruvim::Window

		attr_reader :panels

		def initialize
			super

			@height = 1
			self.align= :bottom
			
			@panels		 = Hash.new
			add_panel(:default, Panel.new(self, 1, 0.8, 20))
		end

		def update(k)
			@panels.each_value { |k| k.update }
		end

		def redraw
			@panels.each_value { |k| k.refresh }
		end

		def message(msg)
			@panels[:default].display(msg)
		end

		def add_panel(name, panel) 
			@panels[name] = panel
		end

	end

	Plugin.register(:statusbar, StatusBar.new)

end
