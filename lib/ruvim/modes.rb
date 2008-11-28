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
		end

	public
		# Select the new mode to symbol newmode
		# TODO yeah this looks ugly
		def mode=(newmode)
			if (@mode==:insert && newmode==:normal) then
				back
			end
			@mode = newmode
		end

		# TODO this might be confusing
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
