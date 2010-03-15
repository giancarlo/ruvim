#
# Ruvim - Ruby Vim Clone
#
# by Giancarlo Bellido
#
require 'ruvim/curses'
require 'ruvim/version'
require 'ruvim/window'
require 'ruvim/cursor'
require 'ruvim/line'
require 'ruvim/plugin'
require 'ruvim/error'
require 'ruvim/modes'
require 'ruvim/page'
require 'ruvim/editor'
require 'ruvim/bindings'
require 'ruvim/buffer'
require 'ruvim/mappings'
require 'ruvim/io'
require 'ruvim/movement'
require 'ruvim/message'
require 'ruvim/api'

module Ruvim

	class Application < Window

		include Ruvim::API
		include Curses::Key
		
		attr_reader :editors, :editor, :plugins, :workspace, :buffers
		attr_reader :events
		
		private

		def initialize_buffers
			@buffers = { :copy => Buffer.new }
		end

		def initialize_plugins
			@plugins = Hash.new
		end

		def initialize_editors
			@editors = Array.new
			@editor  = nil
		end

		def reset_client
			@client[0] = 0; @client[1] = 0
			@client[2] = Curses.cols; @client[3] = Curses.lines - 1
		end

		def initialize_window
			@window  = Curses.stdscr
			@cursor  = Cursor.new(@window)
			@client  = [0,0,Curses.cols,Curses.lines-1]
			@windows = Array.new
			@visible = true

			@workspace = Window.new

			@workspace.alignment= :client
		end

		def initialize_arguments
			(ARGV.size > 0) ? (ARGV.each { |arg| tabe(arg) }) : open
		end

		# Load ~/.ruvimrc and Evaluate
		def initialize_resources
			path = File.expand_path("~/.ruvimrc")

			if File.exists?(path) then
				ruvimrc = File.new(path)
				$ruvim.instance_eval(ruvimrc.read)
				ruvimrc.close
			end
		rescue
			raise "Error Loading Resource File: #{path}\n#{$!}"
		end

		def initialize_mappings
			map('i', :normal) { editor.mode=(:insert) }
			nmap('I') { editor.goto_bol.mode=(:insert) }
			nmap(Curses::Key::IC) { editor.mode=(:insert) }
			nmap('a') { editor.forward.mode=(:insert) }
			nmap('A') { editor.goto_eol.mode=(:insert) }
			nmap('o') { editor.goto_eol.mode=(:insert); editor.mode.bindings.fire RETURN }
			nmap('O') { editor.goto_bol.cr.up.mode=(:insert) }

			nmap('G') { editor.goto_lastline }
			nmap('gg') { editor.goto_firstline }
			nmap('gt') { editor_next }
			nmap('gT') { editor_previous }
			nmap('gf') { editor.open_file_at_cursor }
			nmap('$') { editor.goto_eol }
			nmap('w') { editor.goto_next_word }
			nmap('b') { editor.goto_previous_word }

			nmap('dd') { cut editor.line }
			nmap('dw') { cut editor.word }
			nmap('yy') { copy editor.line }
			nmap('p') { paste }
			nmap('v') do
				mode :visual
				selection.set(buffer.index, buffer.index)
			end

			#
			# Visual Mode Default Mappings
			#
			vmap(Curses::Key::UP) { editor.up.selection.update }
			vmap(Curses::Key::DOWN) { editor.down.selection.update }
			vmap(Curses::Key::LEFT) { editor.back.selection.update }
			vmap(Curses::Key::RIGHT) { editor.forward.selection.update }

			vmap("d") { cut selection; mode :normal }
			vmap("y") { copy selection; mode :normal }

			gmap(Curses::Key::RESIZE) { $ruvim.rearrange }

			map(27, :insert, :visual) { editor.mode= (:normal) }
			map(Curses::Key::DC, :insert, :normal) { editor.remove }

			map(Curses::Key::BACKSPACE)  { editor.back }
			imap(Curses::Key::BACKSPACE) { editor.back.remove unless buffer.at_start? }
			map(127)  { editor.back }
			imap(127) { editor.back.remove unless buffer.at_start? }

			map(8) { editor.back }
			imap(8) { editor.back.remove unless buffer.at_start? }
			
			imap(Ruvim::API::RETURN) { editor.cr }

			map(Curses::Key::HOME, :normal, :insert) { editor.goto_bol }
			map(Curses::Key::END, :normal, :insert) { editor.goto_eol }

			map(Curses::Key::UP, :normal, :insert) 	{ editor.up }
			map(Curses::Key::LEFT, :normal, :insert) { editor.back }
			map(Curses::Key::RIGHT, :normal, :insert){ editor.forward }
			map(Curses::Key::DOWN, :normal, :insert) { editor.down }
			map("j", :normal, :visual) { editor.down }
			map("k", :normal, :visual) { editor.up }
			map("l", :normal, :visual) { editor.forward }
			map("h", :normal, :visual) { editor.back }

			map(">>", :normal) { editor.indent }
			map("<<", :normal) { editor.unindent }

			map(Curses::Key::NPAGE, :normal, :insert ) { page.lines.times { editor.down } }
			map(Curses::Key::PPAGE, :normal, :insert ) { page.lines.times { editor.up } }

			Mode::Modes[:insert].bindings.default { |k| insert(k.chr) }
		end

		public

		def initialize
			$ruvim = self
			@caption  = nil
			@continue = true

			@events = Bindings.new
			@events.map(:origin) {}

			initialize_window
			initialize_plugins
			initialize_buffers
			initialize_mappings
			initialize_editors
			initialize_arguments
		end

		def refresh
			Curses.refresh
			super
			editor.refresh
		end

		def rearrange
			@width  = Curses.stdscr.maxx
			@height = Curses.stdscr.maxy
			super
		end

		# Gets Input and Uses Timeout to get multiple chars for mappings
		def getch
			
			k = Curses.getcode 

			n = editor.mode.bindings.continue(k)
			return if n == false
			k = [k]
			
			while n

				nk = Curses.getcodetimeout(editor.timeout)

				(n.value.call if n.value; return) if nk == nil

				k << nk
				n = editor.mode.bindings.continue(nk, n.ref)
				return if n == false
			end

			editor.mode.bindings.process(k)
		rescue
			message $!
		ensure
			update(k)
		end

		def start
			initialize_resources

			editor.cursor.restore
			refresh

			while @continue
				getch
				editor.cursor.restore
				refresh
			end

			cleanup
		end

		def cleanup
			@editors.each { |e| e.close }
			
			Curses.close_screen
		end

		# This will print a message at the bottom of the screen
		# NOTE Statusbar overrides this function
		def message(what)
			@window.setpos(Curses.lines-1, 0)
			@window.addstr(what.to_s) unless what.nil?
			@window.clrtoeol
		end

		# Gets input
		# You may override this function
		def input(prompt='?')
			@window.setpos(Curses.lines-1, 0)
			@window.addstr(prompt)
			@window.clrtoeol

			@window.setpos(Curses.lines-1, prompt.length)
			Curses.refresh
			Curses.echo
			inp = @window.getstr
			Curses.noecho
			
			return inp
		end


		# Prompts the user for confirmation
		def confirm(prompt)
			while true
				response = input(prompt + "[Y/n]? ")

				case response
				when 'n','N'
					return false
				when 'y','Y', ''
					return true
				end	
			end
		end
	end
end
