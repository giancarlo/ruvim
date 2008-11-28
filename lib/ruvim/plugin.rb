#
# Plugin Manager for Ruvim
#

require 'ruvim/window'

module Ruvim

	module Plugin
		
		@plugins = Hash.new

		def self.register(name, plugin)
			@plugins[name] = plugin
		end

		def self.unregister(name)
#			@plugins.delete(name)
		end

		def self.[](which)
			@plugins[which]
		end

	end

end
