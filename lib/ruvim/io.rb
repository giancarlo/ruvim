#
# Input/Output routines for ruvim
#

module Ruvim

	class Editor < Ruvim::Window

		def changed?
			buffer.changed?
		end

		# Closes Editor and asks to save file if changed.
		def close
			if changed? then
				write if $ruvim.confirm("File was modified. Save")
			end

			self
		end

		# Opens a New File
		def new_file(file='')
			@file = File.expand_path(file)
			new_setup
		end

		def new_setup
			buffer.load ''
			event.fire(:new_file)			
		end

		def read_directory(dirname)
			result = ''
			Dir.entries(dirname).sort!.each do |filename|
				result += "#{filename}\n"
			end
			result
		end
		
		# Opens a file raises if file was not found
		def open(file='')
			@file = File.expand_path(file)

			if File.exists? @file then
				if File.directory? @file then
					filedata = read_directory @file
					buffer.readonly = true
				else
					f = File.new(@file)
					@filetype = CodeRay::FileType[@file]
					close
					filedata = f.read
				end
				buffer.load(filedata)
			else
				return new_setup
			end

			reset
			parent.rearrange
		ensure
			f.close if f
			event.fire(:open)
		end

		def write(file=@file)
			@file = file
			f = File.new(file, 'w')
			buffer.write(f)
		ensure
			f.close if f
		end

	end

	module API

		# Opens File in current editor.
		def open(file=nil)
			tabn if @editor.nil?

			if file then
				@editor.open(file)
				$ruvim.events.fire(:open)
			end

			Ruvim::Message::FILE_LOADED % file
		end

		# Creates a new editor
		def tabn
			@editors << Editor.new(@workspace)
			editor_goto(@editors.size-1)
		end

		# Opens file in new editor
		def tabe(file='')
			tabn
			open(file)
		end

		# Shows Editor ed
		def editor_show(ed)
			@editor.hide unless @editor.nil?
			@editor = ed
			@editor.show
			$ruvim.message "#{@current_editor+1}/#{@editors.size}: #{@editor.file}"
		end

		def editor_goto(index)
			raise "Invalid Editor Index: #{index}" unless (0...@editors.size).include? index

			editor_show(@editors[@current_editor = index])
		end

		def editor_next
			editor_goto( (@current_editor < @editors.size-1) ? @current_editor + 1 : 0)
		end

		def editor_previous
			editor_goto( ((@current_editor > 0) ? @current_editor : @editors.size) - 1)
		end

		def write(file=@editor.file)
			@editor.write(file)
			Ruvim::Message::FILE_WRITTEN % [file, @editor.buffer.size]
		rescue
			Ruvim::Message::ERROR_FILE_WRITE % $!
		end

		alias_method :w, :write

		# Write And Quit
		def wq
			write
			quit
		end

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
