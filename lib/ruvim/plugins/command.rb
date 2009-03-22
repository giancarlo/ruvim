#
# Command Class - Ruvim
#

module Ruvim

	class Command

	private

		def evaluate(command)
			$ruvim.instance_eval(command)
		rescue Exception
			"ERROR: #{$!.to_s}"
		end

	public
		attr_accessor :prompt

		# app necessary to bind
		def initialize
			@prompt = ":"
		end

		# Gets command from user HAHAHA
		def input
			result = evaluate($ruvim.input(@prompt))

			# Handle Special Commands
			case result
			when Numeric
				$ruvim.editor.goto_line(result) 
			end

			$ruvim.message result
		end

		# Adds mappings to editor e.
		def self.mappings(e)
			e.nmap(':') { $ruvim.command.input }
		end

	end

	Plugin::Application.register(:command, Command)

end


