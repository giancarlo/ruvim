#
# Implements Smart Tabs
#

module Ruvim
	module SmartTabs
		
		$ruvim.imap(Ruvim::API::RETURN) do
			indent = $ruvim.buffer.line.to_str.match(/\s*/).to_s
			$ruvim.insert Ruvim::API::CR + indent
		end
	end
end
