#
# Ruvim Search Plugin
#

module Ruvim

	module API

		def gsub(regex, replace)
			buffer.data.gsub!(regex, re)
			editor.redraw
		end

		def sub(regex, replace)
			buffer.data.sub(regex, re)
			editor.redraw
		end

		def match(regex)
			buffer.data.match(regex)
		end

		def find(regex)
			$ruvim.search.find(regex)
		end

	end

	class Search

		attr_accessor :prompt, :last, :rprompt
	
		def initialize
			@prompt  = '/'
			@rprompt = '?'
		end

	private

		def not_found
			$ruvim.message "Pattern not found: " + @last.inspect
		end

		def find_a(from, direction)
			position = (direction == :bottom) ? $ruvim.buffer.data.index(@last, from) : $ruvim.buffer.data.rindex(@last, from)
		end

		def input(p=@prompt)
			$ruvim.input(p)
		end

	public
		# 
		# Finds next 'what' from current buffer index + 'i'.
		#
		def find(what = $ruvim.input(@prompt), offset=0, direction=:bottom, continue=:top)
			position = find_a($ruvim.buffer.index + offset, direction)

			if position.nil? then
				$ruvim.message "Search Hit #{direction}. Continuing at #{continue}"
				from = (direction == :bottom) ? 0 : $ruvim.editor.buffer.eof
				position = find_a(from, direction)

				return not_found if position.nil?
			end
			
			$ruvim.editor.goto(position)	
		end
		
		def search
			find(@last = Regexp.new(input))
		end

		def search_next
			find(@last, 1)
		end

		def search_previous
			find(@last, -1, :top, :bottom)
		end

		def rsearch
			find(@last = Regexp.new(input(@rprompt)), 0, :top, :bottom)
		end

		# Adds mappings to editor e.
		def self.mappings(e)
			e.nmap('/') { $ruvim.search.search  }
			e.nmap('n') { $ruvim.search.search_next     if $ruvim.search.last }
			e.nmap('N') { $ruvim.search.search_previous if $ruvim.search.last }
			e.nmap('?') { $ruvim.search.rsearch }
		end
			
	end

	Plugin::Application.register(:search, Search)

end
