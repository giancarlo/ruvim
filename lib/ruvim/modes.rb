#
# Modes - Ruvim
#
require 'ruvim/bindings'

module Ruvim

	class Mode

		attr_reader :bindings, :name, :abbr

		def initialize(name, abbr=name[0])
			@bindings 	= Ruvim::Bindings.new
			@name		= name
			@abbr		= abbr
		end

		Modes = {
			:normal  => Mode.new("Normal"),
			:insert  => Mode.new("Insert"),
			:visual  => Mode.new("Visual")
		}
	end
end
