#
# File Backup Plugin
#

module Ruvim

	class Backup

		def initialize()
			@enabled = true
		end

		def enable
			@enabled = true
		end

		def disable
			@enabled = false
		end

	end

	Plugin::Application.register(:backup, Backup)

end
