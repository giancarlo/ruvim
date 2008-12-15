#
# Ruby Curses Initialization
#

require 'curses'

Curses.init_screen
Curses.nonl
Curses.cbreak
#Curses.raw
Curses.noecho
Curses.stdscr.keypad(true)

# ESCDELAY might not be defined.
Curses.ESCDELAY= 50 rescue nil
Curses.start_color
Curses.use_default_colors
Curses.init_pair(3, Curses::COLOR_YELLOW, -1)
Curses.refresh
