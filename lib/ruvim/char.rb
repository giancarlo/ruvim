#
#	Char Class
#

require 'structures/linkedlist'

module Ruvim

	#
	# A Char 
	#
	class Char < Structures::LinkedList::Node
	
		# Byte Size
		def size
			1	
		end
	
		# Physical Size
		# TODO you know what to do.
		def space
			("\t") ? Curses.TABSIZE : 1
		end

	end

end
