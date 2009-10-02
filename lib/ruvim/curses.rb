#
# Ruby Curses Initialization
#

throw "Curses is not installed in this ruby installation" unless require 'curses.so'

Curses.init_screen
Curses.nonl
Curses.cbreak
#Curses.raw
Curses.noecho
Curses.stdscr.keypad(true)

# ESCDELAY might not be defined.
Curses.ESCDELAY= 50 if Curses.respond_to? :ESCDELAY=

Curses.start_color
Curses.use_default_colors if Curses.methods.include? :use_default_colors

Curses.init_pair(3, Curses::COLOR_YELLOW, -1)
Curses.refresh

# Make Sure getch always returns a goddamn INTEGER!

module Curses

	unless Curses.respond_to? 'TABSIZE'
	
		def self.TABSIZE
			8
		end

		def self.TABSIZE=(tabsize)
		end
	
	end 

	#
	# Gets Code. Always returns an integer(or nil !!!)
	#
	def self.getcode
		k = Curses.getch
		k = k.getbyte(0) if k.class == String

		return k
	end

	#
	# Gets code with the specified timeout
	#
	def self.getcodetimeout(timeout)
		Curses.timeout= timeout
		nk = Curses.getcode
		Curses.timeout= -1

		return nk
	end

end
