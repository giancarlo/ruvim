#
# Command Class - Ruvim
#

module Ruvim

	class Command

		attr_accessor :row, :column, :prompt

		# app necessary to bind
		def initialize(application, row=Curses.lines-1, col=0, prompt=':')
			@row    = row
			@column = col
			@prompt = prompt
			@application = application
		end

		# Gets command from user HAHAHA
		def input
			Curses.setpos(@row, @column)
			Curses.addstr(@prompt)
			@application.statusbar.message ""

			Curses.echo
			command = Curses.getstr
			Curses.noecho
			
			begin
				@application.statusbar.message @application.instance_eval(command).inspect
			rescue
				@application.statusbar.message "ERROR: #{$!}"
			end
		end

	end

end


