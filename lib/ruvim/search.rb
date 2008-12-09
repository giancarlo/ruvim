#
# Ruvim Search Plugin
#

module Ruvim

	class Search

		attr_accessor :prompt
	
		def initialize
			@prompt = '/'
		end

		def find
			what = $ruvim.input(@prompt)

			position = $ruvim.editor.buffer.data.index(what)
			if position.nil? then
				$ruvim.message "Pattern not found: " + what
			else
				$ruvim.editor.goto_index(position)	
			end
		end

		# Adds mappings to editor e.
		def self.mappings(e)
			e.nmap('/') { $ruvim.search.find }
		end
			
	end

	Plugin::Application.register(:search, Search)

end
