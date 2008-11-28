#
# Linked List Buffer
#

module Ruvim

	class Buffer

		def initialize
			@root = Node.new(:root)
		end

		def load(file)
			f = File.new(file)
			
			node = @root

			f.bytes.each do |k|
				node.next = Node.new(k, node, nil)
				node = node.next
			end

		ensure
			f.close if f
		end

	end

end
