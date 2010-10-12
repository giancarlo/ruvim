#!/usr/bin/env ruby
#
# Install!!
#

require 'rbconfig'
require 'fileutils'

include RbConfig

def install_bin

	filename 	= 'ruvim' + (CONFIG['target_os'] =~ /mswin/i ? '.rb' : '')
	from		= 'bin/ruvim.rb'
	bindir		= CONFIG['bindir']

	# Add Shebang
	out = File.join(bindir, filename)
	FileUtils.install(from, out, :mode => 0755, :verbose => true)

	f = File.new(out, "r+")
	f.puts "#!/usr/bin/env #{CONFIG['ruby_install_name']}"
	f.close
end

install_bin
