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
			#key = key.bytes.next if key.class == String
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

		# Default Mappings for Editor
		def default_mappings
			
			map('i', :normal) { self.mode=(:insert) }
			nmap('I') { goto_bol.mode=(:insert) }
			nmap(Curses::Key::IC) { self.mode=(:insert) }
			nmap('a') { forward.mode=(:insert) }
			nmap('A') { goto_eol.mode=(:insert) }
			nmap('o') { goto_eol.cr.mode=(:insert) }
			nmap('O') { goto_bol.cr.up.mode=(:insert) }

			nmap('G') { goto_lastline }
			nmap('gt') { $ruvim.editor_next }
			nmap('gT') { $ruvim.editor_previous }

			nmap('dd') { $ruvim.cut $ruvim.editor.line }
			nmap('yy') { $ruvim.copy $ruvim.editor.line }
			nmap('p') { $ruvim.paste }

			gmap(Curses::Key::RESIZE) { $ruvim.rearrange }

			map(27, :insert) { self.mode= (:normal) }
			map(Curses::Key::DC, :insert, :normal) { remove }

			map(Curses::Key::BACKSPACE)  { back }
			imap(Curses::Key::BACKSPACE) { back.remove unless buffer.at_start? }
			map(8) { back }
			imap(8) { back.remove unless buffer.at_start? }
			
			imap(13) { cr }

			map(Curses::Key::HOME, :normal, :insert) { goto_bol }
			map(Curses::Key::END, :normal, :insert) { goto_eol }

			map(Curses::Key::UP, :normal, :insert) 	{ up }
			map(Curses::Key::LEFT, :normal, :insert) { back }
			map(Curses::Key::RIGHT, :normal, :insert){ forward }
			map(Curses::Key::DOWN, :normal, :insert) { down }

			map(Curses::Key::NPAGE, :normal, :insert ) { (page.lines-1).times { down } }
			map(Curses::Key::PPAGE, :normal, :insert ) { (page.lines-1).times { up } }

			modes[:insert].bindings.default { |k| insert(k.chr) rescue nil }

		end

	end
	
end
