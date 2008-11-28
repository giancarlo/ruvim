#
#	Char Class
#

#require 'structures/linkedlist'

module Ruvim

	#
	# A Char 
	#
	class Char # < Structures::LinkedList::Node
	
		# Byte Size
		def size
			1	
		end
	
		# Physical Size
		def space
			case @value
			when "\t"	; Curses.TABSIZE
			else		; 1
			end
		end

	end

end
