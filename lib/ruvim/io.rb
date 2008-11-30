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
		
		def open(file=nil)
			@file = file
			f = File.new(file)
			@buffer.load(f.read)
			reset
		rescue
			@buffer.load ''
			$ruvim.message $!
		ensure
			f.close if f
			redraw
		end

		def write(file=@file)
			@file = file
			f = File.new(file, 'w')
			f.write(@buffer.data)
		ensure
			f.close if f
		end

	end

	module API

		def open(file=nil)
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
