#
# Default Mappings File
#

module Ruvim

	module API

		def map(key, *modes, &action)
			editors.each { |e| e.map(key, *modes, &action) }
		end

		def imap(key, &action)
			map(key, :insert, &action)
		end

		def nmap(key, &action)
			map(key, :normal, &action)
		end

	end
	
	class Editor

		def map(key, *mode, &action)
			key = key.bytes.next if key.class == String
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

		# Global Map - Map all the mothafuckin' modes'
		def gmap(k, &action)
			modes.keys.each do |m|
				map(k, m, &action)
			end
		end

	end

	class Editor

		def default_mappings
			
			map('i', :normal) { self.mode=(:insert) }
			nmap('a') { forward.mode=(:insert) }

			gmap(Application::RESIZE) { $ruvim.refresh }

			map(Application::ESCAPE, :insert) { self.mode= (:normal) }
			map(Application::DELETE, :insert, :normal) { remove }

			map(Application::BACKSPACE)  { back }
			imap(Application::BACKSPACE) { back.remove unless buffer.at_start? }
			
			imap(Application::RETURN) { cr }

			map(Application::HOME, :normal, :insert) { goto_bol }
			map(Application::Curses::Key::END, :normal, :insert) { goto_eol }

			map(Application::UP, :normal, :insert) 	{ up }
			map(Application::LEFT, :normal, :insert) { back }
			map(Application::RIGHT, :normal, :insert){ forward }
			map(Application::DOWN, :normal, :insert) { down }

			modes[:insert].bindings.default { |k| insert(k.chr) rescue nil }

		end

	end

end
