#
# Editor Class - Test Ruvim
#

$: << '../lib'

require 'ruvim/editor'

@editor = Ruvim::Editor.new
Curses.init_screen
Curses.refresh

while k = Curses.getch
	k
end
