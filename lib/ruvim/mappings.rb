#
# Default Mappings File
#

module Ruvim

	module API

		# Maps key to &action for the specified mode
		def map(key, *modes, &action)
			modes.each { |mode| Mode::Modes[mode].bindings.map(key, &action) }
		end

		def imap(key, &action)
			map(key, :insert, &action)
		end

		def nmap(key, &action)
			map(key, :normal, &action)
		end

		# Maps to all modes
		def gmap(key, &action)
			map(key, *Mode::Modes.keys, &action)
		end

	end
	
	class Editor

		def map(key, *mode, &action)
			mode << :normal if mode.empty?
			mode.each { |m| modes[m].bindings.map(key, &action) }
		end

		def nmap(key, &action)
			map(key, :normal, &action)
		end

		# Shortcut for map(key, :insert) { action }
		def imap(key, &action)
			map(key, :insert, &action)
		end

		# Global Map
		def gmap(k, &action)
			map(k, *modes.keys, &action)
		end
	end

	
end
