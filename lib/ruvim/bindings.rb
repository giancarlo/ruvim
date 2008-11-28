#
# Handle Key Bindings - Ruvim
#

module Ruvim

	#
	# Bindings Class
	#
	# Binds key events with Proc's.
	#
	class Bindings

		def initialize()
			@map	= Hash.new
		end

		# 
		# Adds a mapping
		#
		def map(key, &action)
			@map[key] = action
		end

		# What to do when no mapping was found
		def default(&action)
			@default = action
		end

		# key: Key Code
		def process(key)
			return @map[key].call if @map.has_key?(key)
				
			@default.call(key) if @default
		end

	end

end
