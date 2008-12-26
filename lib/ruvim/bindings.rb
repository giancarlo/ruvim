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

require 'algorithms/tst'

module Ruvim

	#
	# Bindings Class
	#
	# Binds key events with Proc's.
	#
	class Bindings

		def initialize()
			@map	= Structures::TST::Node.new
			@default= nil
		end

		# 
		# Adds a mapping
		#
		def map(key, &action)
			key = key.bytes.to_a if key.class == String
			key = [key] unless key.class == Array

			key.map! { |k| (k.class == String) ? k.getbyte(0) : k }

			@map.insert(key, action)
		end

		# What to do when no mapping was found
		def default(&action)
			@default = action
		end
	
		#
		# Function to handle multichar mappings.
		#
		# node is the current node where to search for element k
		# Returns nil if not found, the node if more than one found and false if one found.
		#
		def continue(k, node=@map)
			result = node.node([k])
			return result if result.ref 
			
			result.value.call
			false
		rescue Structures::TST::NotFound
			nil
		end

		#
		# Process keycode sequence and call default method
		#
		def process(keys)
			return unless @default
			keys.each { |k| @default.call(k) }
		end
	end

end
