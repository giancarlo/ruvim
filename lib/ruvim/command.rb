#
# Command Class - Ruvim
#

module Ruvim

	class Command

		attr_accessor :row, :column, :prompt

		# app necessary to bind
		def initialize
			@row    = Curses.lines-1
			@column = 0
			@prompt = ":"
		end

		def print(what)
			Curses.setpos(@row, @column)
			Curses.addstr(what.ljust(Curses.cols))
		end

		# Gets command from user HAHAHA
		def input
			print @prompt	

			Curses.setpos(@row, @prompt.length)
			Curses.echo
			command = Curses.getstr
			Curses.noecho
			
			print $ruvim.instance_eval(command).inspect rescue print "ERROR: #{$!}"
		end

		# Adds mappings to editor e.
		def self.mappings(e)
			e.nmap(':') { $ruvim.command.input }
		end

	end

	Plugin::Application.register(:command, Command)

end


