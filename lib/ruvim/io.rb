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
				if ($ruvim.input("File was modified. Save (Y|n)? ").downcase != "n") then
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
				file = "[New File] #{@file}"
				buffer.load ''
			end
			
			@changed = false
		ensure
			f.close if f
			reset
			redraw
			return (Ruvim::Message::FILE_LOADED % file)
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
			tabn if @editor.nil?
			@editor.open(file)
		end

		# Creates a new editor
		def tabn
			@editor = Editor.new(@workspace)
			@editors << @editor
			@current_editor = @editors.size-1
		end

		# Opens file in new editor
		def tabe(file='')
			tabn
			@editor.open(file)
		end

		def editor_goto(index)
			# Hide Current Editor
			@editor.hide
			@editor = @editors[@current_editor = index]
			@editor.show
			message "#{@current_editor+1}/#{@editors.size}: #{@editor.file}"
		rescue
			"Invalid Editor Index: #{index}"
		end

		def editor_next
			editor_goto (@current_editor < @editors.size-1) ? @current_editor + 1 : 0
		end

		def editor_previous
			editor_goto ((@current_editor > 0) ? @current_editor : @editors.size) - 1
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
