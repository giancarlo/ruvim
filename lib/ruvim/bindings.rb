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
			@default= nil
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
	
		# Function to handle multichar mappings
		def continue(k)
			# A ternary tree would be useful here
			# TODO Finish this. For now it will return false. It will only accept single char bindings.
			false			
		end

		# key: Key Code
		def process(key)
			if @map.has_key?(key)
				if (x = @map[key].call).class == Array then
					x.each { |k| process(k) }
				end
			else
				@default.call(key) if @default
			end
		end

	end

end
