#!/usr/bin/env ruby
#
# Install!!
#

require 'rbconfig'
require 'fileutils'

include Config

def install_bin

	filename 	= 'ruvim' + (CONFIG['target_os'] =~ /mswin/i ? '.rb' : '')
	from		= 'bin/ruvim.rb'
	bindir		= CONFIG['bindir']

	FileUtils.install(from, File.join(bindir, filename), :mode => 0755, :verbose => true)
end

install_bin
