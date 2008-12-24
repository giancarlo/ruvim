#
# Ruvim Search Plugin
#

module Ruvim

	class Search

		attr_accessor :prompt, :last, :rprompt
	
		def initialize
			@prompt  = '/'
			@rprompt = '?'
		end

		# 
		# Finds next 'what' from current buffer index + 'i'.
		#
		def find(what = $ruvim.input(@prompt), i=0)
			# TODO Merge find and rfind and separate search.

			@last = what

			position = $ruvim.editor.buffer.data.index(@last, $ruvim.editor.buffer.index + i)

			if position.nil? then
				# Continue from the beggining
				$ruvim.message "Search Hit BOTTOM. Continuing at TOP."
				position = $ruvim.editor.buffer.data.index(@last)

				if position.nil? then
					$ruvim.message "Pattern not found: " + @last
					return
				end
			end
			
			$ruvim.editor.goto(position)	
		
		end

		# 
		# Finds previous 'what' from current buffer index - 'i'.
		#
		def rfind(what = $ruvim.input(@rprompt), i=0)
			@last = what

			position = $ruvim.editor.buffer.data.rindex(@last, $ruvim.editor.buffer.index + i)

			if position.nil? then
				# Continue from the beggining
				$ruvim.message "Search Hit TOP. Continuing at BOTTOM."
				position = $ruvim.editor.buffer.data.rindex(@last, $ruvim.editor.buffer.eof)

				if position.nil? then
					$ruvim.message "Pattern not found: " + @last
					return
				end
			end
			
			$ruvim.editor.goto(position)	
		
		end

		# Adds mappings to editor e.
		def self.mappings(e)
			e.nmap('/') { $ruvim.search.find }
			e.nmap('n') { $ruvim.search.find($ruvim.search.last, 1) if $ruvim.search.last }
			e.nmap('N') { $ruvim.search.rfind($ruvim.search.last, -1) if $ruvim.search.last }
			e.nmap('?') { $ruvim.search.rfind }
		end
			
	end

	Plugin::Application.register(:search, Search)

end
