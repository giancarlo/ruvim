require 'curses';

Curses.init_screen
Curses.start_color
Curses.use_default_colors

puts "Colors: " + Curses.colors.to_s

Curses.colors.times do |clr|
	Curses.init_pair(clr, 1, clr)
	Curses.attron Curses.color_pair clr
	Curses.addstr(" ")
	Curses.attroff Curses.color_pair clr
end

Curses.refresh

Curses.getch
