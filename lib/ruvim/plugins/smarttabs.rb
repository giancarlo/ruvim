#
# Implements Smart Tabs
#

$ruvim.imap(Ruvim::API::RETURN) do
	indent = $ruvim.line.match(/\s*/).to_s
	$ruvim.insert Ruvim::API::CR + indent
end
