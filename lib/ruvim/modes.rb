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

	class Editor < Ruvim::Window

	private
		def initialize_modes
			@modes = {}
			Mode::Modes.each { |k, v| @modes[k]= v.clone }
			@mode = :normal
		end

	public
		# Select the new mode to symbol newmode
		def mode=(newmode)
			raise ArgumentError.new("Invalid Mode: #{newmode}") unless @modes.include? newmode
			@mode = newmode
		end

		def mode
			@modes[@mode]
		end
	end
end
