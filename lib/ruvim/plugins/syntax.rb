#
# Syntax Highglighting for Ruvim
# Uses Coderay
#

require 'coderay' # Syntax Highglighting

module Ruvim

	class Editor

		attr_reader :syntax

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
			:key => 2,
			:keyword => 3,
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
			:selection => 254
		}

		$ruvim.events.map(:open) do
			
		end

		def get_line_text(line)
			@syntax[@page.start + line]
		end

		alias :redraw_line_old :redraw_line

		def redraw_line(line=@cursor.y)
			rebuild_syntax
			redraw_line_old(line)
		end

		def print(scan)
			scan.each do |code|
				case code[0]	
				when "\n"
					
				when String
					attr code[1] { @window.addstr code[0] }
				when :open
				when :close
				end
			end
		end

	private
		
		# We will rebuild the syntax info from the beginning of the file to the end of the current line
		def rebuild_syntax
			text = buffer.data
			synt = []
			text.each_line do |line|
				synt.push CodeRay.scan(line, filetype)
			end

			@syntax = synt
			#$ruvim.input text
=begin
			if @syntax then
				@syntax.slice!(0, line_number)
				@syntax = synt.concat(@syntax)
			else
				@syntax = synt
			end
=end
		end

	end

	$ruvim.editor.redraw

end
