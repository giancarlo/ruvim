# 
# Ternary Search Tree
#

module Structures

	module TST

		class NotFound < Exception
		end

		class Node
			
			attr_reader :key, :value
			attr_reader	:left,:right, :ref

			def initialize(key=nil, value=nil)
				@key 	= key
				@value  = value
				@left = @right = @ref = nil
			end

			#
			# Returns true if Node has left or right
			#
			def children?
				(@left != nil) || (@right != nil)
			end

			#
			# Returns true if Node has ref
			#
			def ref?
				@ref != nil
			end
			
			#
			# Searches for key k and returns node if found.
			# Raises if key was not found.
			#
			# str must implement:
			# []
			#
			def node(str, index=0, len=str.length-1)
				k = str[index]

				if (k == @key) then
					return self if index == len
					return @ref.node(str, index+1, len) if @ref
				end
				
				return @left.node(str, index, len) if (k < @key) && @left
				return @right.node(str, index, len) if @right

				raise NotFound
			end

			# 
			# Searches for str and returns node value if found. 
			# Raises Structures::TST::NotFound if key was not found.
			#
			def search(str)
				node(str).value
			end

			#
			# Returns true if key exists false if it doesnt.
			#
			def has_key?(str)
				node(str); true
			rescue NotFound
				false
			end

			#
			# Inserts str and value into tree.
			#
			# str must implement []	
			# 
			def insert(str, value=nil, index=0, len=str.size)
				k = str[index]

				@key = k if @key.nil?

				if k == @key then
					if (index + 1) < len then
						@ref = Structures::TST::Node.new unless @ref
						@ref.insert(str, value, index+1, len)
					else
						@value = value
					end
				elsif k < @key then
					@left = Structures::TST::Node.new unless @left
					@left.insert(str, value, index, len)
				else
					@right = Structures::TST::Node.new unless @right
					@right.insert(str, value, index, len)
				end

			end


		end
	
	end

end
