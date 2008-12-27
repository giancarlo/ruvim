#
# Command Class - Ruvim
#

module Ruvim

	class Command

		attr_accessor :prompt

		# app necessary to bind
		def initialize
			@prompt = ":"
		end

		def evaluate(command)
			$ruvim.instance_eval(command)
		rescue Exception
			"ERROR: #{$!.to_s}"
		end

		# Gets command from user HAHAHA
		def input
			$ruvim.message evaluate($ruvim.input(@prompt))
		end

		# Adds mappings to editor e.
		def self.mappings(e)
			e.nmap(':') { $ruvim.command.input }
		end

	end

	Plugin::Application.register(:command, Command)

end


