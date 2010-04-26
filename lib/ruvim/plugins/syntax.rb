#
# Syntax Highglighting for Ruvim
# Uses Coderay
#

module Ruvim

	Curses.init_pair(1, Curses::A_BOLD | Curses::COLOR_RED, -1)
	Curses.init_pair(2, Curses::A_BOLD | Curses::COLOR_BLUE, -1)
	Curses.init_pair(3, Curses::COLOR_YELLOW, -1)
	Curses.init_pair(4, Curses::COLOR_MAGENTA, -1)
	Curses.init_pair(5, Curses::COLOR_RED, -1)

	class Editor

		SYNTAX_COLORS = {
		
			:attribute_name => 1,
			:attribute_name_fat => 33,
			:attribute_value => 31,
			:attribute_value_fat => 31,
			:bin => 135,
			:char => {:self => 36, :delimiter => 34},
			:class => 135,
			:class_variable => 36,
			:color => 32,
			:comment => 37,
			:constant => 2,
			:definition => 132,
			:directive => 3,
			:doc => 46,
			:doc_string => 4,
			:entity => 33,
			:error => 5,
			:exception => 131,
			:float => 135,
			:function => 134,
			:global_variable => 42,
			:hex => 136,
			:include => 33,
			:integer => 134,
			:interpreted => 135,
			:ident => 2,
			:label => 14,
			:local_variable => 33,
			:oct => 135,
			:operator_name => 129,
			:pre_constant => 5,
			:pre_type => 130,
			:predefined => 5, 
			:preprocessor => 36,
			:regexp => {
			  :content => 31,
			  :delimiter => 129,
			  :modifier => 35,
			  :function => 129
			},
			:reserved => 3,
			:shell => {:self => 42, :content => 129},
			:string => 32,
			:symbol => 4,
			:tag => 34,
			:tag_fat => 134,
			:tag_special => 6,
			:type => 134,
			:variable => 34,
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
