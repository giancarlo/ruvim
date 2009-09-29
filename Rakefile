require './lib/ruvim/version'

require 'rake/packagetask'
require 'rake/gempackagetask'
require 'rake/rdoctask'
require 'rake/testtask'

spec = Gem::Specification.new do |s|
	s.name    = "ruvim"
	s.version = Ruvim::VERSION 
	s.summary = "Ruvim - Ruby Text Editor"
	s.description = "Ruby Text Editor based on VIM."
	s.files = 	[ "Rakefile", "README"] +
				Dir.glob("lib/**/*") +
				Dir.glob("{bin,test}/*")

	s.require_path = 'lib'

	s.author = "Giancarlo Bellido"
	s.email  = "giancarlo.bellido@gmail.com"
	s.homepage= "http://cpb.coaxialhost.com"
	s.rubyforge_project = "ruvim"
end

Rake::TestTask.new do |t|
	t.libs << "test"
	t.pattern = 'test/*.rb'
	t.verbose = true
end

Rake::GemPackageTask.new(spec) do |p|
	p.gem_spec = spec
#	p.need_tar = true
#	p.need_zip = true
end

Rake::RDocTask.new do |r|
	r.rdoc_dir 	= 'doc'
	r.title 	= 'Ruvim'
	r.rdoc_files.include('lib/**/*.rb')
end

desc "Default Action"
task :default => [ :test ]

desc "Install #{spec.name}-#{spec.version}"
task :install => [:package] do
	sh "#{RUBY} -S gem install --local pkg/#{spec.name}-#{spec.version} --no-update-sources"
	sh "#{RUBY} bin/install.rb"
end

desc "Uninstall #{spec.name}-#{spec.version}"
task :uninstall do
	sh "#{RUBY} -S gem uninstall #{spec.name} -v#{spec.version} -Ix"
	sh "#{RUBY} bin/uninstall.rb"
end

