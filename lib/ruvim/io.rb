#
# Input/Output routines for ruvim
#

module Ruvim

	class Buffer

		def load(data)
			@data = data
			reset
		end

	end

	class Editor < Ruvim::Window

		def changed?
			@changed
		end

		# Closes Editor and asks to save file if changed.
		def close
			if changed? then
				if ($ruvim.input("File was modified. Save? (Y|n)").downcase! != "n") then
					write
				end
			end

			self
		end
		
		def open(file='')
			@file = file

			if (File.exists?(file)) then
				f = File.new(file)
				close
				buffer.load(f.read)
			else
				# New File
				$ruvim.message "New File: #{@file}"
				buffer.load ''
			end
			
			@changed = false
		ensure
			f.close if f
			reset
			redraw
		end

		def write(file=@file)
			@file = file
			f = File.new(file, 'w')
			f.write(@buffer.data)
			@changed = false
		ensure
			f.close if f
		end

	end

	module API

		# Opens File in current editor
		def open(file='')
			if @editor.nil? then
				@editor = Editor.new(@workspace)
				@editors << @editor
				@current_editor = @editors.size-1
			end
			@editor.open(file)

			(Ruvim::Message::FILE_LOADED % file) if file
		end

		def editor_goto(index=@current_editor)
			@editor = @editors[@current_editor]

			message("#{@current_editor}/#{@editors.size}: #{@editor.file}")
		end

		def editor_next
			@current_editor = (@current_editor < @editors.size) ? @current_editor + 1 : 0
			editor_goto
		end

		def editor_previous
			@current_editor = ((@current_editor > 0) ? @current_editor : @editor.size) - 1
			editor_goto
		end

		def write(file=@editor.file)
			@editor.write(file)
			Ruvim::Message::FILE_WRITTEN % [file, @editor.buffer.size]
		rescue
			Ruvim::Message::ERROR_FILE_WRITE % $!
		end

		alias_method :w, :write

		def p(*what)
			result = ''
			what.each { |k| result += k.inspect }
			message(result)
		end

		def print(*what)
			message(what.join)
		end

		def puts(*what)
			print(*what)
		end

	end

end
