#
# Syntax Highglighting for Ruvim
# Uses Coderay
#

require 'coderay' # Syntax Highglighting

module Ruvim

	class Editor

		# We extend curses colors table to use attr function of Editor class.
		Curses::COLORS = {
		
			:attribute_name => 1,
			:attribute_name_fat => 1,
			:attribute_value => 1,
			:attribute_value_fat => 1,
			:bin => 1,
			:char => 1, #{:self => 1, :delimiter => 1},
			:class => 2,
			:class_variable => 1,
			:color => 1,
			:comment => 6,
			:content => 4,
			:constant => 2,
			:delimiter => 1,
			:definition => 1,
			:directive => 3,
			:doc => 1,
			:doc_string => 4,
			:entity => 1,
			:error => 9,
			:exception => 1,
			:float => 1,
			:function => 1,
			:global_variable => 1,
			:hex => 1,
			:include => 1,
			:inline_delimiter =>1,
			:integer => 1,
			:interpreted => 1,
			:ident => 2,
			:label => 1,
			:local_variable => 1,
			:oct => 1,
			:operator_name => 1,
			:operator => 0,
			:plain => 7,
			:pre_constant => 5,
			:pre_type => 1,
			:predefined => 5, 
			:preprocessor => 1,
			:regexp => 1,# {
			#  :content => 1,
			#  :delimiter => 1,
			#  :modifier => 1,
			#  :function =>1 
			#},
			:reserved => 3,
			:shell => 1, # {:self => 1, :content => 1},
			:space => 0,
			:string => 1,
			:method => 1,
			:symbol => 4,
			:tag => 1,
			:tag_fat => 1,
			:tag_special => 6,
			:type => 1,
			:variable => 1,
			:selection => 7
		}

		$ruvim.events.map(:open) do
			scan = CodeRay.scan($ruvim.editor.buffer, $ruvim.editor.filetype)
		end

		def print(text)

			scan = CodeRay.scan(text, filetype)
			scan.each do |code|
				case code[0] 	
				when String
					attr code[1] { @window.addstr code[0] }
				when :open
				when :close
				end
			end
		end

	end

	$ruvim.editor.redraw

end
