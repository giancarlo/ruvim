#!/usr/bin/env ruby
#
# Install!!
#

require 'rbconfig'
require 'fileutils'

include Config

def uninstall_bin

	filename 	= 'ruvim' + (CONFIG['target_os'] =~ /mswin/i ? '.rb' : '')
	bindir		= CONFIG['bindir']

	FileUtils.rm(File.join(bindir, filename))
end

uninstall_bin
