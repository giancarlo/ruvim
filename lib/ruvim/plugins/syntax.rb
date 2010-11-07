#
# Syntax Highglighting for Ruvim
# Uses Coderay
#

require 'coderay' # Syntax Highglighting
	
class String
	attr_accessor :symbol_type
end

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

		def get_line_text(line)
			@syntax[@page.start + line]
		end

		def print(scan)
			return if scan.nil?

			scan.each do |code|
				case code.symbol_type	
				when :open
				when :close
				else
					attr(code.symbol_type) { @window.addstr code }
				end
			end
		end

		alias :old_redraw_line :redraw_line
		alias :old_redraw :redraw

		def redraw_line(line=@cursor.y)
			rebuild_syntax if buffer.changed?
			old_redraw_line(line)
		end

		def redraw
			rebuild_syntax
			old_redraw
		end

	private
		
		# We will rebuild the syntax info from the beginning of the file to the end of the current line
		# TODO This will be extremely slow find a better way
		def rebuild_syntax
			@syntax  = []
			line    = []
			current = ''
			text = buffer.data
				 
			CodeRay.scan_stream(text, filetype) do |k, a|
				if a==:space || a==:plain || a==:content then
					k.each_char do |c|
						if c=="\n" then
							unless current.empty? then
								current.symbol_type = a
								line.push current 
							end
							@syntax.push line

							line = []
							current = ''
							current.symbol_type = a
						else
							current += c
						end
					end
				else
					k.symbol_type = a
					line.push k
				end

				if !current.empty? then
					current.symbol_type = a
					line.push current
					current =''
				end
			end

			@syntax.push line unless line.empty?

		end

	end

	$ruvim.editor.redraw

end
