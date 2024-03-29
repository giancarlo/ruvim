#
# Enables filetype for Editor. It detects the file type based on its extension, name or content.
#

# External Libraries
require 'coderay/helpers/file_type'

module Ruvim

	class Editor

		def filetype
			@file ? CodeRay::FileType[@file] : :ruby
		end

	end

	module FileType

		ByFilename  = {
			['Rakefile'] => :ruby
		}

		ByExtension = {
			['.rb'] => :ruby,
			['.html', '.htm'] => :html,
			['.php', '.php4', '.php5'] => :php,
			['.xml'] => :xml
		}

		Bind = {}

		def self.by_extension(extension)
			ByExtension.each do |m, v|
				return v if m.include? extension
			end

			nil
		end

		def self.by_filename(file)
			ByFilename.each do |m, v|
				return v if m.include? file
			end
			
			nil
		end

		def self.bind
			return FileType::Bind
		end

	end

	module API

		# Load Plugins associated with current filetype
		$ruvim.events.map(:open) do
			ft = $ruvim.editor.filetype

			if (FileType.bind.include? ft)
				FileType.bind[ft].call
			end
		end

		def filetype(*extension, &block)
			return editor.filetype if extension.empty?

			extension.each do |ext|
				if FileType.bind[ext].class != Array then
					FileType.bind[ext] = []
				end

				FileType.bind[ext].push(&block)
			end
		end
	end
end
