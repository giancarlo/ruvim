#
# Handle UNDO and REDO Commands
#

module Ruvim

	class History

		def initialize(editor)
			@editor = editor
			@history = []
		end

		def do(action)
			@history.push(action)
			
		end

		def redo
			@history.push(@history.last.do)
		end

		def undo
			@history.pop.do			
		end

	end

	class Editor
		attr_reader :history
	end

end
