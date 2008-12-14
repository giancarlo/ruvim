#
# Handle Key Bindings - Ruvim
#
# Adding Mappings:
#
# In your .ruvimrc file you can use:
#
# map('keys')  { action }
# imap('keys') { action }
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
			if @map.has_key?(key)
				if (x = @map[key].call).class == String then
					x.each_char { process(key) }
				end
			else
				@default.call(key) if @default
			end
		end

	end

end
