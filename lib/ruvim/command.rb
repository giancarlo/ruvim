#
# Command Class - Ruvim
#

module Ruvim

	class Command

		attr_accessor :row, :column, :prompt

		# app necessary to bind
		def initialize
			@column = 0
			@prompt = ":"
		end

		def evaluate(command)
			($ruvim.instance_eval(command).inspect) rescue "ERROR: #{$!.to_s}"
		end

		def row
			$ruvim.height-1
		end

		# Gets command from user HAHAHA
		def input
			$ruvim.window.setpos(row, @column)
			$ruvim.window.addstr(@prompt)
			$ruvim.window.clrtoeol

			$ruvim.window.setpos(row, @column + @prompt.length)
			Curses.echo
			command = $ruvim.window.getstr
			Curses.noecho
			
			$ruvim.message evaluate(command)
		end

		# Adds mappings to editor e.
		def self.mappings(e)
			e.nmap(':') { $ruvim.command.input }
		end

	end

	Plugin::Application.register(:command, Command)

end


