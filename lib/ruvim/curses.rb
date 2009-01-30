#
# Ruby Curses Initialization
#

require 'curses.so'

Curses.init_screen
Curses.nonl
Curses.cbreak
#Curses.raw
Curses.noecho
Curses.stdscr.keypad(true)

# ESCDELAY might not be defined.
Curses.ESCDELAY= 50 rescue nil
Curses.start_color
Curses.use_default_colors rescue nil
Curses.init_pair(3, Curses::COLOR_YELLOW, -1)
Curses.refresh

# Make Sure getch always returns a goddamn INTEGER!

module Curses

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
