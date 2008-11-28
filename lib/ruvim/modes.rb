#
# Modes - Ruvim
#

module Ruvim

	class Editor < Ruvim::Window

	private
		def initialize_modes
			@modes = {
				:normal  => Mode.new("Normal"),
				:insert  => Mode.new("Insert"),
				:visual  => Mode.new("Visual"),
				:command => Mode.new("Command")
			}

			@mode = :normal

			default_mappings
		end

	public
		# Select the new mode to symbol newmode
		def mode=(newmode)
			@mode = newmode
		end

		def mode
			@modes[@mode]
		end

	end

	class Mode

		attr_reader :bindings, :name, :abbr

		def initialize(name, abbr=name[0])
			@bindings 	= Ruvim::Bindings.new
			@name		= name
			@abbr		= abbr
		end

	end

end
