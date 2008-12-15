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
		
		def open(file='')
			if (File.exists?(file)) then
				@file = file
				f = File.new(file)

				if changed? then
					if ($ruvim.input("File was modified. Save? (Y|n)").downcase! == "y") then
						write
					end
				end

				@buffer.load(f.read)
			else
				# New File
				@buffer.load ''
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
			end
			@editor.open(file)

			(Ruvim::Message::FILE_LOADED % file) if file
		end

		def write(file=@editor.file)
			@editor.write(file)
			message(Ruvim::Message::FILE_WRITTEN % file, @editor.buffer.size)
		rescue
			message(Ruvim::Message::ERROR_FILE_WRITE % $!)
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
