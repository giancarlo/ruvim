#
# Syntax Highglighting for Ruvim
# Uses Coderay
#

module Ruvim

	class Editor

		SYNTAX_COLORS = {
		
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
			:constant => 2,
			:definition => 1,
			:directive => 3,
			:doc => 1,
			:doc_string => 4,
			:entity => 1,
			:error => 5,
			:exception => 1,
			:float => 1,
			:function => 1,
			:global_variable => 1,
			:hex => 1,
			:include => 1,
			:integer => 1,
			:interpreted => 1,
			:ident => 2,
			:label => 1,
			:local_variable => 1,
			:oct => 1,
			:operator_name => 1,
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
			:string => 1,
			:symbol => 4,
			:tag => 1,
			:tag_fat => 1,
			:tag_special => 6,
			:type => 1,
			:variable => 1,
			:selection => 7
		}

		def apply_color type
			color = 0 unless color = SYNTAX_COLORS[type]

			@window.attron Curses.color_pair color
			yield
			@window.attroff Curses.color_pair color
		end

		def print(text)

			scan = CodeRay.scan(text, filetype)
			scan.each do |code|
				case code[0] 	
				when String
					apply_color code[1] { @window.addstr code[0] }
				when :open
				when :close
				end
			end
		end

	end

end
