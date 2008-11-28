#
# Default Mappings File
#

module Ruvim

	module API

		def map(key, *mode, &action)
			key = key.bytes.next if key.class == String
			mode << :normal if mode.empty?
			mode.each { |m| self.editor.modes[m].bindings.map(key, &action) }
		end

		def nmap(key, &action)
			map(key, :normal, &action)
		end

		# Shortcut for map(key, :insert) { action }
		def imap(key, &action)
			map(key, :insert, &action)
		end

		# Global Map - Map all the mothafuckin' modes'
		def gmap(k, &action)
			@editor.modes.keys.each do |m|
				map(k, m, &action)
			end
		end

	end

	class Application

		def default_mappings
			
			map('i', :normal) { @editor.mode= :insert; print_mode }
			gmap(RESIZE) { refresh }

			map(ESCAPE, :insert) { @editor.mode= :normal; print_mode }
			map(DELETE, :insert, :normal) { @editor.remove }

			map(':') { 	@command.input }

			map(BACKSPACE)  { @editor.back }
			imap(BACKSPACE) { @editor.back.remove }
			
			imap(RETURN) { @editor.cr }

			map(HOME, :normal, :insert) { @editor.goto_bol }
			# TODO Fix this.
			map(Curses::Key::END, :normal, :insert) { @editor.goto_eol }

			map(UP, :normal, :insert) 	{ @editor.up }
			map(LEFT, :normal, :insert) { @editor.back }
			map(RIGHT, :normal, :insert){ @editor.forward }
			map(DOWN, :normal, :insert) { @editor.down }

			@editor.modes[:insert].bindings.default { |k| @editor.insert(k.chr) rescue nil }

		end

	end

end
