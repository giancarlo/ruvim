#
# Plugin Manager for Ruvim
#

require 'ruvim/window'

module Ruvim

	module Plugin

		module Application

			def self.register(name, klass)
				$ruvim.plugins[name] = klass.new
				Ruvim::Application.class_eval("def #{name}; @plugins[#{name.inspect}]; end")

				$ruvim.editors.each do |e|
					klass.mappings(e) if klass.respond_to? :mappings
				end
			end

			def self.unregister(name)
				$ruvim.plugins.delete(name)
			end

			def self.[](which)
				$ruvim.plugins[which]
			end

			def self.each(&block)
				$ruvim.plugins.each(&block)
			end

		end
		
		module Editor

			def self.register(name, plugin)
				Ruvim::Editor::Plugins[name] = plugin
				Ruvim::Editor.class_eval("def #{name}; @plugins[#{name.inspect}]; end")
				# Load Plugins for Current Editors
				$ruvim.editors.each do |e|
					e.plugins[name] = plugin.new(e)			
					plugin.mappings(e) if plugin.respond_to? :mappings
				end
			end

			def self.unregister(name)
				Ruvim::Editor::Plugins.delete(name)
				$ruvim.editors.each do |e|
					e.plugins.delete(name)
				end
			end

			def self.[](which)
				Ruvim::Editor::Plugins[which]
			end

			def self.each(&block)
				Ruvim::Editor::Plugins.each(&block)
			end
		end


	end

end
